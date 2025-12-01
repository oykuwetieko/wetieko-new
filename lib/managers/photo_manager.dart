import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PhotoManager {
  final ImagePicker _picker = ImagePicker();


  Future<File?> pickFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }


  Future<File?> pickFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
