import 'package:partners/features/productos/domain/entities/categoria_entity.dart';

/// Modelo de datos para Categoría (Data Layer)
class CategoriaModel extends CategoriaEntity {
  const CategoriaModel({
    required super.id,
    required super.nombre,
    required super.icono,
    required super.cantidadProductos,
  });

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      icono: json['icono'] as String,
      cantidadProductos: json['cantidadProductos'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'icono': icono,
      'cantidadProductos': cantidadProductos,
    };
  }

  CategoriaEntity toEntity() {
    return CategoriaEntity(
      id: id,
      nombre: nombre,
      icono: icono,
      cantidadProductos: cantidadProductos,
    );
  }
}
