import 'package:partners/features/branches/data/models/subcategory_model.dart';

/// Respuesta paginada del endpoint GET /options/subcategories/{category_id}.
class SubcategoryResponseModel {
  final List<SubcategoryModel> data;
  final SubcategoryPaginationMeta meta;

  const SubcategoryResponseModel({
    required this.data,
    required this.meta,
  });

  factory SubcategoryResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>?;
    final data = dataList != null
        ? dataList
            .map((e) => SubcategoryModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <SubcategoryModel>[];
    final metaJson = json['meta'] as Map<String, dynamic>?;
    final meta = metaJson != null
        ? SubcategoryPaginationMeta.fromJson(metaJson)
        : const SubcategoryPaginationMeta(
            currentPage: 1,
            lastPage: 1,
            perPage: 15,
            total: 0,
          );
    return SubcategoryResponseModel(data: data, meta: meta);
  }
}

class SubcategoryPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const SubcategoryPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory SubcategoryPaginationMeta.fromJson(Map<String, dynamic> json) {
    return SubcategoryPaginationMeta(
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 15,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}
