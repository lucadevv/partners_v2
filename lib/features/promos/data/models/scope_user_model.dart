import 'package:partners/features/promos/domain/entities/scope_user_entity.dart';

/// Modelo de datos para usuario en radio de alcance.
class ScopeUserModel {
  const ScopeUserModel({
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;

  ScopeUserEntity toEntity() {
    return ScopeUserEntity(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
