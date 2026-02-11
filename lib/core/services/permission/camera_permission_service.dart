import 'package:permission_handler/permission_handler.dart' as ph;

import 'permission_service.dart';
import 'permission_status.dart';

/// Contrato para permiso de cámara. Implementa [PermissionService] (una responsabilidad: cámara).
abstract class CameraPermissionService implements PermissionService {}

class CameraPermissionServiceImpl implements CameraPermissionService {
  @override
  Future<PermissionStatus> request() async {
    final status = await ph.Permission.camera.request();
    return PermissionService.fromPh(status);
  }

  @override
  Future<bool> isGranted() async {
    final status = await ph.Permission.camera.status;
    return status.isGranted;
  }

  @override
  Future<bool> openAppSettings() => ph.openAppSettings();
}
