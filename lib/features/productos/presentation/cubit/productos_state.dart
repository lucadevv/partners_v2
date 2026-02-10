import 'package:equatable/equatable.dart';
import 'package:partners/features/productos/domain/entities/categoria_entity.dart';
import 'package:partners/features/productos/domain/entities/producto_entity.dart';

/// Estado del cubit de productos
class ProductosState extends Equatable {
  final ProductosStatus status;
  final List<ProductoEntity> productos;
  final List<CategoriaEntity> categorias;
  final List<ProductoEntity> productosDestacados;
  final String? categoriaSeleccionada;
  final String queryBusqueda;
  final String? errorMessage;

  const ProductosState({
    this.status = ProductosStatus.initial,
    this.productos = const [],
    this.categorias = const [],
    this.productosDestacados = const [],
    this.categoriaSeleccionada,
    this.queryBusqueda = '',
    this.errorMessage,
  });

  ProductosState copyWith({
    ProductosStatus? status,
    List<ProductoEntity>? productos,
    List<CategoriaEntity>? categorias,
    List<ProductoEntity>? productosDestacados,
    String? categoriaSeleccionada,
    String? queryBusqueda,
    String? errorMessage,
  }) {
    return ProductosState(
      status: status ?? this.status,
      productos: productos ?? this.productos,
      categorias: categorias ?? this.categorias,
      productosDestacados: productosDestacados ?? this.productosDestacados,
      categoriaSeleccionada:
          categoriaSeleccionada ?? this.categoriaSeleccionada,
      queryBusqueda: queryBusqueda ?? this.queryBusqueda,
      errorMessage: errorMessage,
    );
  }

  List<ProductoEntity> get productosFiltrados {
    if (categoriaSeleccionada != null) {
      return productos
          .where((p) => p.categoria == categoriaSeleccionada)
          .toList();
    }
    if (queryBusqueda.isNotEmpty) {
      final queryLower = queryBusqueda.toLowerCase();
      return productos
          .where(
            (p) =>
                p.nombre.toLowerCase().contains(queryLower) ||
                p.descripcion.toLowerCase().contains(queryLower),
          )
          .toList();
    }
    return productos;
  }

  @override
  List<Object?> get props => [
    status,
    productos,
    categorias,
    productosDestacados,
    categoriaSeleccionada,
    queryBusqueda,
    errorMessage,
  ];
}

enum ProductosStatus { initial, loading, success, failure }
