import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/users/data/datasource/users_map_datasource.dart';
import 'package:partners/features/users/data/models/user_location_model.dart';

/// Mock: devuelve usuarios con lat/lng dentro del radio para el mapa de Users.
class MockUsersMapDatasourceImpl implements UsersMapDatasource {
  static const int _count = 14;
  final math.Random _rnd = math.Random(123);

  @override
  Future<Either<AppException, List<UserLocationModel>>> getUsersInRadius({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
  }) async {
    final double latRad = centerLat * math.pi / 180;
    final double dLat = radiusKm / 111.0;
    final double dLng = radiusKm / (111.0 * math.cos(latRad));
    final list = <UserLocationModel>[];
    for (var i = 0; i < _count; i++) {
      final angle = _rnd.nextDouble() * 2 * math.pi;
      final r = _rnd.nextDouble() * 0.88;
      list.add(UserLocationModel(
        latitude: centerLat + dLat * r * math.cos(angle),
        longitude: centerLng + dLng * r * math.sin(angle),
      ));
    }
    return Right(list);
  }
}
