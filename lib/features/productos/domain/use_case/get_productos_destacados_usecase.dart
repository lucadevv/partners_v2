import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/productos/domain/entities/producto_entity.dart';
import 'package:partners/features/productos/domain/repository/productos_repository.dart';

/// Use Case para obtener productos destacados
/// Sigue el principio de Single Responsibility (SRP)
class GetProductosDestacadosUsecase {
  final ProductosRepository _repository;

  GetProductosDestacadosUsecase({required ProductosRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<ProductoEntity>>> call() async {
    return await _repository.getProductosDestacados();
  }
}
