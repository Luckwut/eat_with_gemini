import '../models/settings_model.dart';
import 'base_storage.dart';

class SettingsStorage extends BaseStorage<SettingsModel> {
  static final SettingsStorage _instance = SettingsStorage._internal();

  SettingsStorage._internal() : super('app_settings');

  factory SettingsStorage() => _instance;

  @override
  Map<String, dynamic> toMap(SettingsModel model) {
    return model.toMap();
  }

  @override
  SettingsModel fromMap(Map<String, dynamic> map) {
    return SettingsModel.fromMap(map);
  }
}
