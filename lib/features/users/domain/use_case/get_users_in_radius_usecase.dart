import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/users/domain/entities/user_location_entity.dart';
import 'package:partners/features/users/domain/repository/users_map_repository.dart';

/// Caso de uso para obtener usuarios en el radio (lat/lng) para el mapa.
class GetUsersInRadiusUsecase {
  final UsersMapRepository _repository;

  GetUsersInRadiusUsecase({required UsersMapRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<UserLocationEntity>>> call({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
  }) {
    return _repository.getUsersInRadius(
      centerLat: centerLat,
      centerLng: centerLng,
      radiusKm: radiusKm,
    );
  }
}
