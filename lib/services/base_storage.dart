import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseStorage<T> {
  final String storageKey;
  T? _cachedData;

  BaseStorage(this.storageKey);

  /// Converts a model to a map (to be implemented by subclasses)
  Map<String, dynamic> toMap(T model);

  /// Converts a map to a model (to be implemented by subclasses)
  T fromMap(Map<String, dynamic> map);

  Future<void> saveData(T data) async {
    _cachedData = data;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(toMap(data)));
  }

  Future<T?> getData() async {
    if (_cachedData != null) {
      return _cachedData;
    }

    final prefs = await SharedPreferences.getInstance();
    final resultString = prefs.getString(storageKey);

    if (resultString != null) {
      try {
        _cachedData = fromMap(jsonDecode(resultString));
      } catch (e) {
        log('Error decoding settings: $e');
        prefs.remove(storageKey);
        _cachedData = null;
      }
    }
    return _cachedData;
  }

  T? get cachedData => _cachedData;
}
