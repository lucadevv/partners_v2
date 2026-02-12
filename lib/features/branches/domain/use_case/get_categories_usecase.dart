import 'package:dartz/dartz.dart';

import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/category_entity.dart';
import 'package:partners/features/branches/domain/entities/paginated_result.dart';
import 'package:partners/features/branches/domain/repository/branches_repository.dart';

/// Caso de uso: obtener categorías paginadas (bottom sheet con infinite scroll).
/// Usa [BranchesRepository] del mismo feature.
class GetCategoriesUsecase {
  final BranchesRepository _repository;

  GetCategoriesUsecase({required BranchesRepository repository})
      : _repository = repository;

  Future<Either<AppException, PaginatedResult<CategoryEntity>>> call(
    int page, {
    String? keyword,
  }) =>
      _repository.getCategories(page, keyword: keyword);
}
