import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/feature_type_enum.dart';
import '../../display_response/response_screen.dart';

class ResponseListTile extends StatelessWidget {
  final int id;
  final String title;
  final FeatureType featureType;
  final DateTime createdAt;

  const ResponseListTile({
    super.key,
    required this.id,
    required this.title,
    required this.featureType,
    required this.createdAt,
  });

  IconData _featureIcon(FeatureType featureType) {
    switch (featureType) {
      case FeatureType.recipeCreator:
        return Icons.auto_fix_high;
      case FeatureType.dishDeconstructor:
        return Icons.lunch_dining;
      case FeatureType.suitabilityAnalyzer:
        return Icons.remove_red_eye;
      default:
        return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('yyyy/MM/dd').format(createdAt);
    String time = DateFormat('HH:mm:ss').format(createdAt);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ResponseScreen(
              id: id,
              createdAt: createdAt,
            ),
          ),
        );
      },
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.deepPurple,
          ),
          child: Icon(_featureIcon(featureType)),
        ),
        title: Text(
          title,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
        subtitle: Text(
          '$time $date',
          style: const TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
