import 'package:equatable/equatable.dart';

/// Categoría (dominio). Solo id y name según API /options/categories.
class CategoryEntity extends Equatable {
  final String id;
  final String name;

  const CategoryEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
