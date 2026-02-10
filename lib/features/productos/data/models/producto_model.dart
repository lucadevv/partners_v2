import 'package:partners/features/productos/domain/entities/producto_entity.dart';

/// Modelo de datos para Producto (Data Layer)
class ProductoModel extends ProductoEntity {
  const ProductoModel({
    required super.id,
    required super.nombre,
    required super.descripcion,
    required super.precio,
    required super.imagenUrl,
    required super.categoria,
    required super.disponible,
    required super.stock,
    super.precioDescuento,
    super.porcentajeDescuento,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: (json['precio'] as num).toDouble(),
      imagenUrl: json['imagenUrl'] as String,
      categoria: json['categoria'] as String,
      disponible: json['disponible'] as bool? ?? true,
      stock: json['stock'] as int? ?? 0,
      precioDescuento: json['precioDescuento'] != null
          ? (json['precioDescuento'] as num).toDouble()
          : null,
      porcentajeDescuento: json['porcentajeDescuento'] != null
          ? (json['porcentajeDescuento'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'imagenUrl': imagenUrl,
      'categoria': categoria,
      'disponible': disponible,
      'stock': stock,
      'precioDescuento': precioDescuento,
      'porcentajeDescuento': porcentajeDescuento,
    };
  }

  ProductoEntity toEntity() {
    return ProductoEntity(
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      precio: precio,
      imagenUrl: imagenUrl,
      categoria: categoria,
      disponible: disponible,
      stock: stock,
      precioDescuento: precioDescuento,
      porcentajeDescuento: porcentajeDescuento,
    );
  }
}
