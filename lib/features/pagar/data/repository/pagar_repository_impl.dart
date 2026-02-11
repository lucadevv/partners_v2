import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/pagar/data/datasource/pagar_datasource.dart';
import 'package:partners/features/pagar/data/mappers/pago_mapper.dart';
import 'package:partners/features/pagar/domain/entities/pago_entity.dart';
import 'package:partners/features/pagar/domain/repository/pagar_repository.dart';

class PagarRepositoryImpl implements PagarRepository {
  final PagarDatasource _datasource;

  PagarRepositoryImpl({required PagarDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<AppException, List<PagoEntity>>> getHistorialPagos() async {
    final result = await _datasource.getHistorialPagos();
    return result.map(
      (models) => PagoMapper.modelsToEntities(models),
    );
  }

  @override
  Future<Either<AppException, PagoEntity>> procesarPago(PagoEntity pago) async {
    final pagoModel = PagoMapper.entityToModel(pago);
    final result = await _datasource.procesarPago(pagoModel);
    return result.map(
      (model) => PagoMapper.modelToEntity(model),
    );
  }
}
