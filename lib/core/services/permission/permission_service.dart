import 'package:permission_handler/permission_handler.dart' as ph;

import 'permission_status.dart';

/// Contrato base que **todos** los servicios de permiso implementan (POO + SOLID: D).
/// Una sola abstracción para solicitar, verificar y abrir ajustes; cada tipo (cámara, fotos, ubicación)
/// tiene su implementación concreta que conoce el [Permission] específico.
abstract class PermissionService {
  /// Solicita el permiso. Retorna el estado resultante.
  Future<PermissionStatus> request();

  /// Comprueba si el permiso está concedido sin solicitarlo.
  Future<bool> isGranted();

  /// Abre la configuración de la app para que el usuario pueda conceder el permiso.
  Future<bool> openAppSettings();

  /// Convierte el estado de [permission_handler] al enum del dominio (evita duplicar lógica).
  static PermissionStatus fromPh(ph.PermissionStatus status) {
    if (status.isGranted) return PermissionStatus.granted;
    if (status.isPermanentlyDenied) return PermissionStatus.permanentlyDenied;
    if (status.isRestricted) return PermissionStatus.restricted;
    if (status.isLimited) return PermissionStatus.limited;
    if (status.isProvisional) return PermissionStatus.provisional;
    return PermissionStatus.denied;
  }
}
