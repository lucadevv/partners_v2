import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/productos/data/datasource/productos_datasource.dart';
import 'package:partners/features/productos/data/mappers/categoria_mapper.dart';
import 'package:partners/features/productos/data/mappers/producto_mapper.dart';
import 'package:partners/features/productos/domain/entities/categoria_entity.dart';
import 'package:partners/features/productos/domain/entities/producto_entity.dart';
import 'package:partners/features/productos/domain/repository/productos_repository.dart';

/// Implementación del repositorio de productos (Data Layer)
/// Sigue el principio de Dependency Inversion (DIP)
class ProductosRepositoryImpl implements ProductosRepository {
  final ProductosDatasource _datasource;

  ProductosRepositoryImpl({required ProductosDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<AppException, List<ProductoEntity>>> getProductos() async {
    final result = await _datasource.getProductos();
    return result.map((models) => ProductoMapper.modelsToEntities(models));
  }

  @override
  Future<Either<AppException, List<ProductoEntity>>> getProductosPorCategoria(
    String categoriaId,
  ) async {
    final result = await _datasource.getProductosPorCategoria(categoriaId);
    return result.map((models) => ProductoMapper.modelsToEntities(models));
  }

  @override
  Future<Either<AppException, List<ProductoEntity>>> buscarProductos(
    String query,
  ) async {
    final result = await _datasource.buscarProductos(query);
    return result.map((models) => ProductoMapper.modelsToEntities(models));
  }

  @override
  Future<Either<AppException, ProductoEntity>> getProductoPorId(
    String id,
  ) async {
    final result = await _datasource.getProductoPorId(id);
    return result.map((model) => ProductoMapper.modelToEntity(model));
  }

  @override
  Future<Either<AppException, List<CategoriaEntity>>> getCategorias() async {
    final result = await _datasource.getCategorias();
    return result.map((models) => CategoriaMapper.modelsToEntities(models));
  }

  @override
  Future<Either<AppException, List<ProductoEntity>>> getProductosDestacados() async {
    final result = await _datasource.getProductosDestacados();
    return result.map((models) => ProductoMapper.modelsToEntities(models));
  }
}
