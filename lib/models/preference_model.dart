class PreferenceModel {
  String dietaryPreference;
  String healthConsideration;

  PreferenceModel({
    required this.dietaryPreference,
    required this.healthConsideration,
  });

  Map<String, dynamic> toMap() {
    return {
      'dietaryPreference': dietaryPreference,
      'healthConsideration': healthConsideration,
    };
  }

  factory PreferenceModel.fromMap(Map<String, dynamic> map) {
    return PreferenceModel(
      dietaryPreference: map['dietaryPreference'],
      healthConsideration: map['healthConsideration'],
    );
  }
}