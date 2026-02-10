import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/productos/domain/entities/categoria_entity.dart';
import 'package:partners/features/productos/domain/repository/productos_repository.dart';

/// Use Case para obtener todas las categorías
/// Sigue el principio de Single Responsibility (SRP)
class GetCategoriasUsecase {
  final ProductosRepository _repository;

  GetCategoriasUsecase({required ProductosRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<CategoriaEntity>>> call() async {
    return await _repository.getCategorias();
  }
}
