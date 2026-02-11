import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/users/data/datasource/users_map_datasource.dart';
import 'package:partners/features/users/domain/entities/user_location_entity.dart';
import 'package:partners/features/users/domain/repository/users_map_repository.dart';

/// Implementación del repositorio del mapa de usuarios (capa Data).
class UsersMapRepositoryImpl implements UsersMapRepository {
  final UsersMapDatasource _datasource;

  UsersMapRepositoryImpl({required UsersMapDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<AppException, List<UserLocationEntity>>> getUsersInRadius({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
  }) async {
    final result = await _datasource.getUsersInRadius(
      centerLat: centerLat,
      centerLng: centerLng,
      radiusKm: radiusKm,
    );
    return result.map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
