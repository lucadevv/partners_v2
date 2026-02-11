import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/users/data/models/user_location_model.dart';

/// Datasource de usuarios con ubicación para el mapa (capa Data).
abstract class UsersMapDatasource {
  Future<Either<AppException, List<UserLocationModel>>> getUsersInRadius({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
  });
}
