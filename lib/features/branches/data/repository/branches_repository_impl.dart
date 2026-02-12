import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/data/datasource/branches_datasource.dart';
import 'package:partners/features/branches/data/mappers/branch_mapper.dart';
import 'package:partners/features/branches/domain/entities/branch_entity.dart';
import 'package:partners/features/branches/domain/entities/category_entity.dart';
import 'package:partners/features/branches/domain/entities/create_branch_params.dart';
import 'package:partners/features/branches/domain/entities/paginated_result.dart';
import 'package:partners/features/branches/domain/entities/subcategory_entity.dart';
import 'package:partners/features/branches/domain/repository/branches_repository.dart';

/// Implementación del repositorio de branches (Data Layer).
/// Llama al datasource y convierte con mapper; no hace fold (lo hace el Cubit/UI).
class BranchesRepositoryImpl implements BranchesRepository {
  final BranchesDatasource _datasource;

  BranchesRepositoryImpl({required BranchesDatasource datasource})
    : _datasource = datasource;

  @override
  Future<Either<AppException, List<BranchEntity>>> getBranches() async {
    final result = await _datasource.getBranches();
    return result.map((models) => BranchMapper.modelsToEntities(models));
  }

  @override
  Future<Either<AppException, PaginatedResult<CategoryEntity>>> getCategories(
    int page, {
    String? keyword,
  }) async {
    final result = await _datasource.getCategories(page, keyword: keyword);
    return result.map((response) {
      final meta = PaginationMeta(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        perPage: response.meta.perPage,
        total: response.meta.total,
      );
      return PaginatedResult<CategoryEntity>(
        data: response.data.map((m) => m.toEntity()).toList(),
        meta: meta,
      );
    });
  }

  @override
  Future<Either<AppException, PaginatedResult<SubcategoryEntity>>>
  getSubcategories(String categoryId, int page, {String? keyword}) async {
    final result = await _datasource.getSubcategories(
      categoryId,
      page,
      keyword: keyword,
    );
    return result.map((response) {
      final meta = PaginationMeta(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        perPage: response.meta.perPage,
        total: response.meta.total,
      );
      return PaginatedResult<SubcategoryEntity>(
        data: response.data.map((m) => m.toEntity(categoryId)).toList(),
        meta: meta,
      );
    });
  }

  @override
  Future<Either<AppException, String>> createBranch(
    CreateBranchParams params,
  ) async {
    return _datasource.createBranch(params);
  }
}
