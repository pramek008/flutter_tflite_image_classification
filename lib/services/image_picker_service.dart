import 'dart:io';

import 'package:exam_face_mask_detection/services/permission_service.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerServices {
  final ImagePicker _picker = ImagePicker();
  final permissionService = GetIt.I.get<PermissionService>();
  late File _image;

  Future<File> pickImage() async {
    if (await Permission.storage.isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _image = File(image.path);
      }
      return _image;
    } else {
      await permissionService.requestGaleriPermission();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _image = File(image.path);
      }
      return _image;
    }

    // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   _image = File(image.path);
    // }
    // return _image;
  }

  Future<File> takeImage() async {
    if (await Permission.camera.isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        _image = File(image.path);
      }
      return _image;
    } else {
      await permissionService.requestCameraPermission();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        _image = File(image.path);
      }
      return _image;
    }

    // final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    // if (image != null) {
    //   _image = File(image.path);
    // }
    // return _image;
  }
}
