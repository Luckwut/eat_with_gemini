import 'package:image_picker/image_picker.dart';

import '../models/feature_type_enum.dart';
import '../models/gemini_api_model.dart';
import '../models/settings_model.dart';
import 'gemini_api_service.dart';
import 'gemini_feature_factory.dart';
import 'settings_storage.dart';

class GeminiFeatureService {
  final _geminiApiService = GeminiApiService();
  final _settingsStorage = SettingsStorage();

  GeminiFeatureFactory? _featureFactory;

  SettingsModel? settings;

  String apiKey = '';
  String geminiModel = '';

  Future<void> _loadEssentials() async {
    settings = await _settingsStorage.getData();
    apiKey = settings?.apiKey ?? '';
    geminiModel = settings?.geminiModel ?? '';

    _featureFactory = GeminiFeatureFactory(_geminiApiService);
  }

  Future<Text> generateFeature(
    FeatureType featureType,
    XFile image,
  ) async {
    if (settings == null || _featureFactory == null) {
      await _loadEssentials();
    }

    return _featureFactory!.callFeature(
      featureType,
      image: image,
      apiKey: apiKey,
      geminiModel: geminiModel,
    );
  }

  void close() {
    _geminiApiService.close();
  }
}
