import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageHandler {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    return image;
  }

  Future<XFile?> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    return image;
  }

  Future<String?> storeImage(XFile image) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagePath = join(appDir.path, basename(image.path));

    final File savedImage = await File(image.path).copy(imagePath);

    return savedImage.path;
  }
}
