import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  Future requestCameraPermission();
  // Future<bool> handleCameraPermission(BuildContext context);
  Future requestGaleriPermission();
  // Future<bool> handleGaleriPermission(BuildContext context);
}

class PermissionServiceImpl implements PermissionService {
  @override
  Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  // @override
  // Future<bool> handleCameraPermission(BuildContext context) async {
  //   PermissionStatus cameraPermissionStatus = await requestCameraPermission();

  //   if (cameraPermissionStatus != PermissionStatus.granted) {
  //     print(
  //         '😰 😰 😰 😰 😰 😰 Permission to camera was not granted! 😰 😰 😰 😰 😰 😰');
  //     await showDialog(
  //       context: context,
  //       builder: (context) => AppAlertDialog(
  //           onConfirm: () => openAppSettings(),
  //           title: 'Camera Permission',
  //           subtitle: 'This app needs camera access to take pictures'),
  //     );
  //     return false;
  //   }
  //   return true;
  // }

  @override
  Future<PermissionStatus> requestGaleriPermission() async {
    return await Permission.storage.request();
  }

  // @override
  // Future<bool> handleGaleriPermission(BuildContext context) async {
  //   PermissionStatus galeriPermissionStatus = await requestGaleriPermission();

  //   if (galeriPermissionStatus != PermissionStatus.granted) {
  //     print(
  //         '😰 😰 😰 😰 😰 😰 Permission to galeri was not granted! 😰 😰 😰 😰 😰 😰');
  //     await showDialog(
  //       context: context,
  //       builder: (_) => AppAlertDialog(
  //           onConfirm: () => openAppSettings(),
  //           title: 'Galeri Permission',
  //           subtitle: 'This app needs galeri access to take pictures'),
  //     );
  //     return false;
  //   }
  //   return true;
  // }
}
