import 'package:equatable/equatable.dart';

/// Subcategoría de una categoría (dominio).
class SubcategoryEntity extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final String? image;

  const SubcategoryEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id, categoryId, name, image];
}
