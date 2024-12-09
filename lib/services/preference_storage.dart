import '../models/preference_model.dart';
import 'base_storage.dart';

class PreferenceStorage extends BaseStorage<PreferenceModel> {
  static final PreferenceStorage _instance = PreferenceStorage._internal();

  PreferenceStorage._internal() : super('user_preference');

  factory PreferenceStorage() => _instance;

  @override
  Map<String, dynamic> toMap(PreferenceModel model) {
    return model.toMap();
  }

  @override
  PreferenceModel fromMap(Map<String, dynamic> map) {
    return PreferenceModel.fromMap(map);
  }
}
