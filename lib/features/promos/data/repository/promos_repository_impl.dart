import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/promos/data/datasource/promos_datasource.dart';
import 'package:partners/features/promos/data/mappers/promo_mapper.dart';
import 'package:partners/features/promos/domain/entities/promo_entity.dart';
import 'package:partners/features/promos/domain/repository/promos_repository.dart';

/// Implementación del repositorio de promos (capa Data).
/// Sigue el principio de inversión de dependencias (DIP).
class PromosRepositoryImpl implements PromosRepository {
  final PromosDatasource _datasource;

  PromosRepositoryImpl({required PromosDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<AppException, List<PromoEntity>>> getPromos() async {
    final result = await _datasource.getPromos();
    return result.map(
      (models) => PromoMapper.modelsToEntities(models),
    );
  }
}
