import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/data/datasource/branches_datasource.dart';
import 'package:partners/features/branches/data/models/branch_model.dart';
import 'package:partners/features/branches/data/models/category_response_model.dart';
import 'package:partners/features/branches/data/models/subcategory_response_model.dart';
import 'package:partners/features/branches/domain/entities/create_branch_params.dart';

/// Mock implementation of Branches datasource
/// Follows mock data pattern for development and testing
class MockBranchesDatasourceImpl implements BranchesDatasource {
  // Mock data for Branches
  // Datos movidos desde branches_screen.dart para seguir Clean Architecture
  final List<BranchModel> _mockBranches = const [
    BranchModel(
      id: '1',
      name: 'Sucursal Starbucks\nC. Lima',
      address: 'Centro Comercial, Av. Javier Prado Este 500, San Isidro.',
      phone: '123456789',
      schedule: 'Lunes a Sábado:\n9:00AM a 9PM',
      workers: 8,
      imageUrl: null,
    ),
    BranchModel(
      id: '2',
      name: 'Sucursal Starbucks\nC. Lima',
      address: 'Centro Comercial, Av. Javier Prado Este 500, San Isidro.',
      phone: '123456789',
      schedule: 'Lunes a Sábado:\n9:00AM a 9PM',
      workers: 8,
      imageUrl: null,
    ),
    BranchModel(
      id: '3',
      name: 'Sucursal Starbucks\nC. Lima',
      address: 'Centro Comercial, Av. Javier Prado Este 500, San Isidro.',
      phone: '123456789',
      schedule: 'Lunes a Sábado:\n9:00AM a 9PM',
      workers: 8,
      imageUrl: null,
    ),
    BranchModel(
      id: '4',
      name: 'Sucursal Starbucks\nC. Lima',
      address: 'Centro Comercial, Av. Javier Prado Este 500, San Isidro.',
      phone: '123456789',
      schedule: 'Lunes a Sábado:\n9:00AM a 9PM',
      workers: 8,
      imageUrl: null,
    ),
  ];

  @override
  Future<Either<AppException, List<BranchModel>>> getBranches() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(_mockBranches);
  }

  @override
  Future<Either<AppException, CategoryResponseModel>> getCategories(
    int page, {
    String? keyword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Right(
      CategoryResponseModel(
        data: [],
        meta: CategoryPaginationMeta(
          currentPage: 1,
          lastPage: 1,
          perPage: 15,
          total: 0,
        ),
      ),
    );
  }

  @override
  Future<Either<AppException, SubcategoryResponseModel>> getSubcategories(
    String categoryId,
    int page, {
    String? keyword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Right(
      SubcategoryResponseModel(
        data: [],
        meta: SubcategoryPaginationMeta(
          currentPage: 1,
          lastPage: 1,
          perPage: 15,
          total: 0,
        ),
      ),
    );
  }

  @override
  Future<Either<AppException, String>> createBranch(
    CreateBranchParams params,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Right('Sucursal creada con éxito');
  }
}
