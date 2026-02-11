import 'package:partners/features/users/domain/entities/user_location_entity.dart';

/// Modelo de datos para usuario con ubicación (capa Data).
class UserLocationModel {
  const UserLocationModel({
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;

  UserLocationEntity toEntity() {
    return UserLocationEntity(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
