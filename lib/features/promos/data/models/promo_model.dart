import 'package:partners/features/promos/domain/entities/promo_entity.dart';

/// Modelo de datos para Promo (capa Data).
class PromoModel extends PromoEntity {
  const PromoModel({
    required super.id,
    required super.title,
    super.imageUrl,
    super.type,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'type': type,
    };
  }

  PromoEntity toEntity() {
    return PromoEntity(
      id: id,
      title: title,
      imageUrl: imageUrl,
      type: type,
    );
  }
}
