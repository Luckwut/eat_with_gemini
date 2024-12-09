import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/image_handler.dart';

class DescriptionBottomSheet extends StatelessWidget {
  final String imagePath;
  final String description;
  final Function(XFile) onImageSelected;

  DescriptionBottomSheet({
    super.key,
    required this.imagePath,
    required this.description,
    required this.onImageSelected,
  });

  final _imageHandler = ImageHandler();

  Future<void> _handleImageSelection(
    BuildContext context,
    Future<XFile?> futureImage,
  ) async {
    XFile? image = await futureImage;

    if (image != null) {
      onImageSelected(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 250.0,
            width: 250.0,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.black12,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircularProgressIndicator(), // Placeholder loading indicator
                Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.auto_awesome,
                      size: 48.0,
                    );
                  },
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child; // Display the image if it was already loaded.
                    } else {
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 500),
                        child: child,
                      ); // Fade in the image once loaded.
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.image),
                      Text(
                        'Select a Picture',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    _handleImageSelection(
                      context,
                      _imageHandler.pickImageFromGallery(),
                    );
                  },
                ),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.camera_alt),
                      Text(
                        'Take a Picture',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    _handleImageSelection(
                      context,
                      _imageHandler.pickImageFromCamera(),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
