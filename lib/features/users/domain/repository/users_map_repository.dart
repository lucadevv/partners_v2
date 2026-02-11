import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/users/domain/entities/user_location_entity.dart';

/// Repositorio de usuarios con ubicación para el mapa (capa Domain).
abstract class UsersMapRepository {
  Future<Either<AppException, List<UserLocationEntity>>> getUsersInRadius({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
  });
}
