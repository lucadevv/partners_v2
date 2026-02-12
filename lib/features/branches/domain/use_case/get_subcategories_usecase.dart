import 'package:dartz/dartz.dart';

import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/paginated_result.dart';
import 'package:partners/features/branches/domain/entities/subcategory_entity.dart';
import 'package:partners/features/branches/domain/repository/branches_repository.dart';

/// Caso de uso: obtener subcategorías paginadas de una categoría (bottom sheet con infinite scroll).
class GetSubcategoriesUsecase {
  final BranchesRepository _repository;

  GetSubcategoriesUsecase({required BranchesRepository repository})
      : _repository = repository;

  Future<Either<AppException, PaginatedResult<SubcategoryEntity>>> call(
    String categoryId,
    int page, {
    String? keyword,
  }) =>
      _repository.getSubcategories(categoryId, page, keyword: keyword);
}
