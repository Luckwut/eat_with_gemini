import 'package:flutter/material.dart';

class ResponseData extends StatelessWidget {
  final String modelType;
  final String date;
  final String time;

  const ResponseData({
    super.key,
    required this.modelType,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          modelType,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          '$time $date',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

