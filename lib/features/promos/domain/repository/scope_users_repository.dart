import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/promos/domain/entities/scope_user_entity.dart';

/// Repositorio de usuarios en el radio de alcance (capa Domain).
abstract class ScopeUsersRepository {
  Future<Either<AppException, List<ScopeUserEntity>>> getUsersInRadius({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
  });
}
