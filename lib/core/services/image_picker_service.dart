import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImageFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) return null;

    return File(file.path).path;
  }
}