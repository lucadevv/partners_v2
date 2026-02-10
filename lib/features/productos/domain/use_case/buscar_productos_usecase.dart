import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/productos/domain/entities/producto_entity.dart';
import 'package:partners/features/productos/domain/repository/productos_repository.dart';

/// Use Case para buscar productos por nombre
/// Sigue el principio de Single Responsibility (SRP)
class BuscarProductosUsecase {
  final ProductosRepository _repository;

  BuscarProductosUsecase({required ProductosRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<ProductoEntity>>> call(String query) async {
    if (query.trim().isEmpty) {
      return const Left(
        ValidationException('La búsqueda no puede estar vacía'),
      );
    }
    return await _repository.buscarProductos(query);
  }
}
