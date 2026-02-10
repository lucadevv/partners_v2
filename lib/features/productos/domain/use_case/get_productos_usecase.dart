import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/productos/domain/entities/producto_entity.dart';
import 'package:partners/features/productos/domain/repository/productos_repository.dart';

/// Use Case para obtener todos los productos
/// Sigue el principio de Single Responsibility (SRP)
class GetProductosUsecase {
  final ProductosRepository _repository;

  GetProductosUsecase({required ProductosRepository repository})
    : _repository = repository;

  Future<Either<AppException, List<ProductoEntity>>> call() async {
    return await _repository.getProductos();
  }
}
