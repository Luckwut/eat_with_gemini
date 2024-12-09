class SettingsModel {
  String apiKey;
  String geminiModel;

  SettingsModel({
    required this.apiKey,
    required this.geminiModel,
  });

  Map<String, dynamic> toMap() {
    return {
      'apiKey': apiKey,
      'geminiModel': geminiModel,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      apiKey: map['apiKey'],
      geminiModel: map['geminiModel'],
    );
  }
}