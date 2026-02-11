import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/promos/domain/entities/scope_user_entity.dart';
import 'package:partners/features/promos/domain/repository/scope_users_repository.dart';

/// Caso de uso para obtener usuarios dentro del radio de alcance.
class GetScopeUsersUsecase {
  final ScopeUsersRepository _repository;

  GetScopeUsersUsecase({required ScopeUsersRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<ScopeUserEntity>>> call({
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
