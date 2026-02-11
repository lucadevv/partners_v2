/// Resultado de obtener la ubicación actual.
class LocationResult {
  const LocationResult({
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;
}

/// Servicio para solicitar permisos de ubicación y obtener la posición actual.
/// Usado desde features que necesitan la ubicación del dispositivo (ej. promos, alcance).
abstract class LocationService {
  /// Solicita permiso de ubicación (whenInUse) y obtiene la posición actual.
  /// Retorna [LocationResult] si el permiso fue concedido y se pudo obtener la posición.
  /// Retorna null si el permiso fue denegado, permanentemente denegado o hubo error.
  Future<LocationResult?> requestPermissionAndGetCurrentPosition();
}
