import 'package:permission_handler/permission_handler.dart' as ph;

import 'permission_service.dart';
import 'permission_status.dart';

/// Contrato para permiso de fotos/galería. Implementa [PermissionService] (una responsabilidad: fotos).
abstract class PhotosPermissionService implements PermissionService {}

class PhotosPermissionServiceImpl implements PhotosPermissionService {
  @override
  Future<PermissionStatus> request() async {
    final status = await ph.Permission.photos.request();
    return PermissionService.fromPh(status);
  }

  @override
  Future<bool> isGranted() async {
    final status = await ph.Permission.photos.status;
    return status.isGranted;
  }

  @override
  Future<bool> openAppSettings() => ph.openAppSettings();
}
