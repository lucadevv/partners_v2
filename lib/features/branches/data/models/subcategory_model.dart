import 'package:partners/features/branches/domain/entities/subcategory_entity.dart';

/// DTO de subcategoría: id y name (API /options/subcategories/{category_id}).
class SubcategoryModel {
  final String id;
  final String name;

  const SubcategoryModel({
    required this.id,
    required this.name,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  SubcategoryEntity toEntity(String categoryId) => SubcategoryEntity(
        id: id,
        categoryId: categoryId,
        name: name,
        image: null,
      );
}
