import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/productos/domain/entities/categoria_entity.dart';
import 'package:partners/features/productos/domain/entities/producto_entity.dart';

/// Interfaz del repositorio de productos (Domain Layer)
/// Sigue el principio de Dependency Inversion (DIP)
abstract class ProductosRepository {
  /// Obtiene todos los productos
  Future<Either<AppException, List<ProductoEntity>>> getProductos();

  /// Obtiene productos por categoría
  Future<Either<AppException, List<ProductoEntity>>> getProductosPorCategoria(
    String categoriaId,
  );

  /// Busca productos por nombre
  Future<Either<AppException, List<ProductoEntity>>> buscarProductos(
    String query,
  );

  /// Obtiene un producto por ID
  Future<Either<AppException, ProductoEntity>> getProductoPorId(String id);

  /// Obtiene todas las categorías
  Future<Either<AppException, List<CategoriaEntity>>> getCategorias();

  /// Obtiene productos destacados
  Future<Either<AppException, List<ProductoEntity>>> getProductosDestacados();
}
