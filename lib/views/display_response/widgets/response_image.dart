import 'dart:io';

import 'package:flutter/material.dart';

class ResponseImage extends StatelessWidget {
  final String imagePath;

  const ResponseImage({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
        color: Colors.black12,
      ),
      child: Center(
        child: imagePath.isNotEmpty && File(imagePath).existsSync()
            ? Image.file(
                File(imagePath),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Failed to load image :(',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24.0,
                    ),
                  );
                },
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  } else {
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 500),
                      child: child,
                    );
                  }
                },
              )
            : const Text(
                'Image not found :(',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24.0,
                ),
              ),
      ),
    );
  }
}
