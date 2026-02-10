import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/pagar/domain/entities/pago_entity.dart';
import 'package:partners/features/pagar/domain/repository/pagar_repository.dart';

class ProcesarPagoUsecase {
  final PagarRepository _repository;

  ProcesarPagoUsecase({required PagarRepository repository})
      : _repository = repository;

  Future<Either<AppException, PagoEntity>> call(PagoEntity pago) async {
    if (pago.monto <= 0) {
      return const Left(ValidationException('El monto debe ser mayor a 0'));
    }
    return await _repository.procesarPago(pago);
  }
}
