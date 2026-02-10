import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/pagar/domain/entities/pago_entity.dart';
import 'package:partners/features/pagar/domain/repository/pagar_repository.dart';

class GetHistorialPagosUsecase {
  final PagarRepository _repository;

  GetHistorialPagosUsecase({required PagarRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<PagoEntity>>> call() async {
    return await _repository.getHistorialPagos();
  }
}
