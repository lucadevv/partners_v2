import 'package:partners/features/branches/data/models/category_model.dart';

/// Respuesta paginada del endpoint GET /options/categories (data, links, meta).
/// Incluye data (lista de categorías), meta (paginación) y opcionalmente links.
class CategoryResponseModel {
  final List<CategoryModel> data;
  final CategoryPaginationMeta meta;

  const CategoryResponseModel({
    required this.data,
    required this.meta,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>?;
    final data = dataList != null
        ? dataList
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <CategoryModel>[];
    final metaJson = json['meta'] as Map<String, dynamic>?;
    final meta = metaJson != null
        ? CategoryPaginationMeta.fromJson(metaJson)
        : CategoryPaginationMeta(currentPage: 1, lastPage: 1, perPage: 15, total: 0);
    return CategoryResponseModel(data: data, meta: meta);
  }
}

class CategoryPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const CategoryPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory CategoryPaginationMeta.fromJson(Map<String, dynamic> json) {
    return CategoryPaginationMeta(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 15,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}
