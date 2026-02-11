import 'package:permission_handler/permission_handler.dart' as ph;

import 'permission_service.dart';
import 'permission_status.dart';

/// Contrato para permiso de ubicación. Implementa [PermissionService] (una responsabilidad: ubicación).
abstract class LocationPermissionService implements PermissionService {}

class LocationPermissionServiceImpl implements LocationPermissionService {
  @override
  Future<PermissionStatus> request() async {
    final status = await ph.Permission.locationWhenInUse.request();
    return PermissionService.fromPh(status);
  }

  @override
  Future<bool> isGranted() async {
    final status = await ph.Permission.locationWhenInUse.status;
    return status.isGranted;
  }

  @override
  Future<bool> openAppSettings() => ph.openAppSettings();
}
