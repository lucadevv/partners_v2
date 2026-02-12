import 'package:partners/features/branches/domain/entities/category_entity.dart';

/// DTO de categoría: solo id y name (API /options/categories).
class CategoryModel {
  final String id;
  final String name;

  const CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  CategoryEntity toEntity() => CategoryEntity(id: id, name: name);
}
