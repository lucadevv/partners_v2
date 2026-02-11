import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/promos/domain/entities/promo_entity.dart';
import 'package:partners/features/promos/domain/repository/promos_repository.dart';

/// Caso de uso para obtener la lista de promociones.
/// Sigue el principio de responsabilidad única (SRP).
class GetPromosUsecase {
  final PromosRepository _repository;

  GetPromosUsecase({required PromosRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<PromoEntity>>> call() async {
    return _repository.getPromos();
  }
}
