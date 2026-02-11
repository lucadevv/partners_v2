import 'package:equatable/equatable.dart';

/// Entidad que representa un usuario dentro del radio de alcance de una promo.
class ScopeUserEntity extends Equatable {
  final double latitude;
  final double longitude;

  const ScopeUserEntity({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}
