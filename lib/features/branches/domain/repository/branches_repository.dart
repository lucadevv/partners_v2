import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/branch_detail_entity.dart';
import 'package:partners/features/branches/domain/entities/branch_entity.dart';
import 'package:partners/features/branches/domain/entities/category_entity.dart';
import 'package:partners/features/branches/domain/entities/create_branch_params.dart';
import 'package:partners/features/branches/domain/entities/paginated_result.dart';
import 'package:partners/features/branches/domain/entities/subcategory_entity.dart';

/// Repositorio del feature branches (Domain Layer).
abstract class BranchesRepository {
  Future<Either<AppException, List<BranchEntity>>> getBranches();

  Future<Either<AppException, BranchDetailEntity>> getBranchById(String id);

  Future<Either<AppException, PaginatedResult<CategoryEntity>>> getCategories(
    int page, {
    String? keyword,
  });

  Future<Either<AppException, PaginatedResult<SubcategoryEntity>>> getSubcategories(
    String categoryId,
    int page, {
    String? keyword,
  });

  /// Crea una sucursal. El backend retorna { "message": "..." }; se devuelve ese mensaje.
  Future<Either<AppException, String>> createBranch(CreateBranchParams params);
}
