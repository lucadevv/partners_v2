import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/pagar/data/models/pago_model.dart';

abstract class PagarDatasource {
  Future<Either<AppException, List<PagoModel>>> getHistorialPagos();
  Future<Either<AppException, PagoModel>> procesarPago(PagoModel pago);
}
