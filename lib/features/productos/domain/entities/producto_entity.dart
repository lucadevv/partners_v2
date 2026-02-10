import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa un producto
class ProductoEntity extends Equatable {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagenUrl;
  final String categoria;
  final bool disponible;
  final int stock;
  final double? precioDescuento;
  final double? porcentajeDescuento;

  const ProductoEntity({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagenUrl,
    required this.categoria,
    required this.disponible,
    required this.stock,
    this.precioDescuento,
    this.porcentajeDescuento,
  });

  bool get tieneDescuento =>
      precioDescuento != null && porcentajeDescuento != null;
  double get precioFinal => precioDescuento ?? precio;

  @override
  List<Object?> get props => [
    id,
    nombre,
    descripcion,
    precio,
    imagenUrl,
    categoria,
    disponible,
    stock,
    precioDescuento,
    porcentajeDescuento,
  ];
}
