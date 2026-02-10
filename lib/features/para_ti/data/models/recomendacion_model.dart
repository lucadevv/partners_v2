import 'package:partners/features/para_ti/domain/entities/recomendacion_entity.dart';

class RecomendacionModel extends RecomendacionEntity {
  const RecomendacionModel({
    required super.id,
    required super.titulo,
    required super.descripcion,
    required super.imagenUrl,
    required super.tipo,
  });

  factory RecomendacionModel.fromJson(Map<String, dynamic> json) {
    return RecomendacionModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      imagenUrl: json['imagenUrl'] as String,
      tipo: json['tipo'] as String,
    );
  }

  RecomendacionEntity toEntity() {
    return RecomendacionEntity(
      id: id,
      titulo: titulo,
      descripcion: descripcion,
      imagenUrl: imagenUrl,
      tipo: tipo,
    );
  }
}
