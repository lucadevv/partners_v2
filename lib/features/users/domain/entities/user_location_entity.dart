import 'package:equatable/equatable.dart';

/// Entidad que representa un usuario con ubicación (lat/lng) para el mapa.
class UserLocationEntity extends Equatable {
  final double latitude;
  final double longitude;

  const UserLocationEntity({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}
