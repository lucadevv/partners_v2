import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/data/models/branch_detail_model.dart';
import 'package:partners/features/branches/data/models/branch_model.dart';
import 'package:partners/features/branches/data/models/category_response_model.dart';
import 'package:partners/features/branches/data/models/subcategory_response_model.dart';
import 'package:partners/features/branches/domain/entities/create_branch_params.dart';

/// Datasource del feature branches (Data Layer).
abstract class BranchesDatasource {
  Future<Either<AppException, List<BranchModel>>> getBranches();

  Future<Either<AppException, BranchDetailModel>> getBranchById(String id);

  Future<Either<AppException, CategoryResponseModel>> getCategories(
    int page, {
    String? keyword,
  });

  Future<Either<AppException, SubcategoryResponseModel>> getSubcategories(
    String categoryId,
    int page, {
    String? keyword,
  });

  /// Backend retorna { "message": "Sucursal creada con éxito" }.
  Future<Either<AppException, String>> createBranch(CreateBranchParams params);
}
