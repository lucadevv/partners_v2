import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/promos/data/models/scope_user_model.dart';

/// Datasource de usuarios en radio de alcance (capa Data).
abstract class ScopeUsersDatasource {
  Future<Either<AppException, List<ScopeUserModel>>> getUsersInRadius({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
  });
}
