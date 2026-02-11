import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa una promoción.
class PromoEntity extends Equatable {
  final String id;
  final String title;
  final String? imageUrl;
  final String? type;

  const PromoEntity({
    required this.id,
    required this.title,
    this.imageUrl,
    this.type,
  });

  @override
  List<Object?> get props => [id, title, imageUrl, type];
}
