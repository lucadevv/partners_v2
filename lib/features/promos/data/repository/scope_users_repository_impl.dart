import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/promos/data/datasource/scope_users_datasource.dart';
import 'package:partners/features/promos/domain/entities/scope_user_entity.dart';
import 'package:partners/features/promos/domain/repository/scope_users_repository.dart';

/// Implementación del repositorio de usuarios en radio.
class ScopeUsersRepositoryImpl implements ScopeUsersRepository {
  final ScopeUsersDatasource _datasource;

  ScopeUsersRepositoryImpl({required ScopeUsersDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<AppException, List<ScopeUserEntity>>> getUsersInRadius({
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
