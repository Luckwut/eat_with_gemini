import 'feature_type_enum.dart';

class DatabaseResponseModel {
  int? id; // Assigned by SQLite
  String title;
  String responseData;
  FeatureType featureType;
  String modelType;
  String? imagePath;
  DateTime createdAt;

  DatabaseResponseModel({
    this.id,
    required this.title,
    required this.responseData,
    required this.featureType,
    required this.modelType,
    this.imagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id, | Assigned by SQLite
      'title': title,
      'response_data': responseData,
      'feature_type': featureType.name,
      'model_type': modelType,
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory DatabaseResponseModel.fromMap(Map<String, dynamic> map) {
    return DatabaseResponseModel(
      id: map['id'],
      title: map['title'],
      responseData: map['response_data'],
      featureType: FeatureType.values.firstWhere(
        (e) => e.name == map['feature_type'],
      ),
      modelType: map['model_type'],
      imagePath: map['image_path'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
