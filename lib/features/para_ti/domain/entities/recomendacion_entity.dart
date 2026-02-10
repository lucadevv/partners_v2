import 'package:equatable/equatable.dart';

class RecomendacionEntity extends Equatable {
  final String id;
  final String titulo;
  final String descripcion;
  final String imagenUrl;
  final String tipo; // oferta, producto, noticia

  const RecomendacionEntity({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagenUrl,
    required this.tipo,
  });

  @override
  List<Object?> get props => [id, titulo, descripcion, imagenUrl, tipo];
}
