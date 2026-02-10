import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/productos/data/models/categoria_model.dart';
import 'package:partners/features/productos/data/models/producto_model.dart';

/// Interfaz del datasource de productos (Data Layer)
/// Sigue el principio de Dependency Inversion (DIP)
abstract class ProductosDatasource {
  Future<Either<AppException, List<ProductoModel>>> getProductos();
  Future<Either<AppException, List<ProductoModel>>> getProductosPorCategoria(
    String categoriaId,
  );
  Future<Either<AppException, List<ProductoModel>>> buscarProductos(
    String query,
  );
  Future<Either<AppException, ProductoModel>> getProductoPorId(String id);
  Future<Either<AppException, List<CategoriaModel>>> getCategorias();
  Future<Either<AppException, List<ProductoModel>>> getProductosDestacados();
}
