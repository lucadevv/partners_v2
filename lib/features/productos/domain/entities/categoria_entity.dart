import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa una categoría de productos
class CategoriaEntity extends Equatable {
  final String id;
  final String nombre;
  final String icono;
  final int cantidadProductos;

  const CategoriaEntity({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.cantidadProductos,
  });

  @override
  List<Object?> get props => [id, nombre, icono, cantidadProductos];
}
