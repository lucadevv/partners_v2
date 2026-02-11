import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/para_ti/data/datasource/para_ti_datasource.dart';
import 'package:partners/features/para_ti/data/mappers/recomendacion_mapper.dart';
import 'package:partners/features/para_ti/domain/entities/recomendacion_entity.dart';
import 'package:partners/features/para_ti/domain/repository/para_ti_repository.dart';

/// Repository implementation for Para Ti feature (Data Layer)
/// Follows Dependency Inversion Principle (DIP)
class ParaTiRepositoryImpl implements ParaTiRepository {
  final ParaTiDatasource _datasource;

  ParaTiRepositoryImpl({required ParaTiDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<AppException, List<RecomendacionEntity>>> getRecomendaciones() async {
    final result = await _datasource.getRecomendaciones();
    return result.map(
      (models) => RecomendacionMapper.modelsToEntities(models),
    );
  }
}
