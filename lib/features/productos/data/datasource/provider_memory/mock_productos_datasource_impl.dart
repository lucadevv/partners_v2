import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/productos/data/datasource/productos_datasource.dart';
import 'package:partners/features/productos/data/models/categoria_model.dart';
import 'package:partners/features/productos/data/models/producto_model.dart';

/// Implementación mock del datasource de productos
/// Sigue el patrón de data mock para desarrollo y testing
class MockProductosDatasourceImpl implements ProductosDatasource {
  // Mock data de productos
  final List<ProductoModel> _mockProductos = [
    const ProductoModel(
      id: '1',
      nombre: 'Café Espresso',
      descripcion: 'Café espresso intenso y aromático',
      precio: 8.50,
      imagenUrl: 'https://via.placeholder.com/300',
      categoria: 'bebidas',
      disponible: true,
      stock: 50,
      precioDescuento: 7.00,
      porcentajeDescuento: 17.6,
    ),
    const ProductoModel(
      id: '2',
      nombre: 'Cappuccino',
      descripcion: 'Cappuccino cremoso con leche espumada',
      precio: 10.00,
      imagenUrl: 'https://via.placeholder.com/300',
      categoria: 'bebidas',
      disponible: true,
      stock: 30,
    ),
    const ProductoModel(
      id: '3',
      nombre: 'Latte',
      descripcion: 'Latte suave con leche vaporizada',
      precio: 11.50,
      imagenUrl: 'https://via.placeholder.com/300',
      categoria: 'bebidas',
      disponible: true,
      stock: 25,
    ),
    const ProductoModel(
      id: '4',
      nombre: 'Croissant',
      descripcion: 'Croissant artesanal recién horneado',
      precio: 6.00,
      imagenUrl: 'https://via.placeholder.com/300',
      categoria: 'panaderia',
      disponible: true,
      stock: 40,
      precioDescuento: 4.50,
      porcentajeDescuento: 25.0,
    ),
    const ProductoModel(
      id: '5',
      nombre: 'Sandwich Club',
      descripcion: 'Sandwich con pollo, tocino y vegetales',
      precio: 15.00,
      imagenUrl: 'https://via.placeholder.com/300',
      categoria: 'comida',
      disponible: true,
      stock: 20,
    ),
    const ProductoModel(
      id: '6',
      nombre: 'Ensalada César',
      descripcion: 'Ensalada fresca con pollo y aderezo césar',
      precio: 12.00,
      imagenUrl: 'https://via.placeholder.com/300',
      categoria: 'comida',
      disponible: true,
      stock: 15,
    ),
    const ProductoModel(
      id: '7',
      nombre: 'Torta de Chocolate',
      descripcion: 'Torta de chocolate decadente',
      precio: 9.50,
      imagenUrl: 'https://via.placeholder.com/300',
      categoria: 'postres',
      disponible: true,
      stock: 10,
    ),
    const ProductoModel(
      id: '8',
      nombre: 'Muffin de Arándanos',
      descripcion: 'Muffin esponjoso con arándanos frescos',
      precio: 5.50,
      imagenUrl: 'https://via.placeholder.com/300',
      categoria: 'panaderia',
      disponible: true,
      stock: 35,
    ),
    const ProductoModel(
      id: '9',
      nombre: 'Té Verde',
      descripcion: 'Té verde orgánico refrescante',
      precio: 7.00,
      imagenUrl: 'https://via.placeholder.com/300',
      categoria: 'bebidas',
      disponible: true,
      stock: 45,
    ),
    const ProductoModel(
      id: '10',
      nombre: 'Smoothie de Frutas',
      descripcion: 'Smoothie natural con frutas frescas',
      precio: 9.00,
      imagenUrl: 'https://via.placeholder.com/300',
      categoria: 'bebidas',
      disponible: true,
      stock: 20,
    ),
  ];

  // Mock data de categorías
  final List<CategoriaModel> _mockCategorias = const [
    CategoriaModel(
      id: 'bebidas',
      nombre: 'Bebidas',
      icono: 'local_drink',
      cantidadProductos: 5,
    ),
    CategoriaModel(
      id: 'comida',
      nombre: 'Comida',
      icono: 'restaurant',
      cantidadProductos: 2,
    ),
    CategoriaModel(
      id: 'panaderia',
      nombre: 'Panadería',
      icono: 'bakery_dining',
      cantidadProductos: 2,
    ),
    CategoriaModel(
      id: 'postres',
      nombre: 'Postres',
      icono: 'cake',
      cantidadProductos: 1,
    ),
  ];

  @override
  Future<Either<AppException, List<ProductoModel>>> getProductos() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(_mockProductos);
  }

  @override
  Future<Either<AppException, List<ProductoModel>>> getProductosPorCategoria(
    String categoriaId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final productos = _mockProductos
        .where((p) => p.categoria == categoriaId)
        .toList();
    
    if (productos.isEmpty) {
      return Left(
        NotFoundException('No se encontraron productos en esta categoría'),
      );
    }
    
    return Right(productos);
  }

  @override
  Future<Either<AppException, List<ProductoModel>>> buscarProductos(
    String query,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final queryLower = query.toLowerCase();
    final productos = _mockProductos
        .where((p) =>
            p.nombre.toLowerCase().contains(queryLower) ||
            p.descripcion.toLowerCase().contains(queryLower))
        .toList();
    
    if (productos.isEmpty) {
      return Left(
        NotFoundException('No se encontraron productos con "$query"'),
      );
    }
    
    return Right(productos);
  }

  @override
  Future<Either<AppException, ProductoModel>> getProductoPorId(
    String id,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      final producto = _mockProductos.firstWhere((p) => p.id == id);
      return Right(producto);
    } catch (e) {
      return Left(NotFoundException('Producto no encontrado'));
    }
  }

  @override
  Future<Either<AppException, List<CategoriaModel>>> getCategorias() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(_mockCategorias);
  }

  @override
  Future<Either<AppException, List<ProductoModel>>> getProductosDestacados() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Productos destacados son los que tienen descuento o los primeros 3
    final destacados = _mockProductos
        .where((p) => p.tieneDescuento)
        .take(3)
        .toList();
    
    if (destacados.length < 3) {
      destacados.addAll(
        _mockProductos
            .where((p) => !p.tieneDescuento)
            .take(3 - destacados.length)
            .toList(),
      );
    }
    
    return Right(destacados);
  }
}
