import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/pagar/domain/entities/pago_entity.dart';

abstract class PagarRepository {
  Future<Either<AppException, List<PagoEntity>>> getHistorialPagos();
  Future<Either<AppException, PagoEntity>> procesarPago(PagoEntity pago);
}
