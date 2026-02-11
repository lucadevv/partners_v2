import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/promos/data/datasource/scope_users_datasource.dart';
import 'package:partners/features/promos/data/models/scope_user_model.dart';

/// Mock: devuelve usuarios distribuidos dentro del radio (lat/lng) para el mapa.
class MockScopeUsersDatasourceImpl implements ScopeUsersDatasource {
  static const int _count = 12;
  final math.Random _rnd = math.Random(42);

  @override
  Future<Either<AppException, List<ScopeUserModel>>> getUsersInRadius({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
  }) async {
    final double latRad = centerLat * math.pi / 180;
    final double dLat = radiusKm / 111.0;
    final double dLng = radiusKm / (111.0 * math.cos(latRad));
    final list = <ScopeUserModel>[];
    for (var i = 0; i < _count; i++) {
      final angle = _rnd.nextDouble() * 2 * math.pi;
      final r = _rnd.nextDouble() * 0.85;
      list.add(ScopeUserModel(
        latitude: centerLat + dLat * r * math.cos(angle),
        longitude: centerLng + dLng * r * math.sin(angle),
      ));
    }
    return Right(list);
  }
}
