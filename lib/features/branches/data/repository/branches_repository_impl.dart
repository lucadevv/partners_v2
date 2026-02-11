import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/data/datasource/branches_datasource.dart';
import 'package:partners/features/branches/data/mappers/branch_mapper.dart';
import 'package:partners/features/branches/domain/entities/branch_entity.dart';
import 'package:partners/features/branches/domain/repository/branches_repository.dart';

/// Repository implementation for Branches feature (Data Layer)
/// Follows Dependency Inversion Principle (DIP)
class BranchesRepositoryImpl implements BranchesRepository {
  final BranchesDatasource _datasource;

  BranchesRepositoryImpl({required BranchesDatasource datasource})
      : _datasource = datasource;

  @override
  Future<Either<AppException, List<BranchEntity>>> getBranches() async {
    final result = await _datasource.getBranches();
    return result.map(
      (models) => BranchMapper.modelsToEntities(models),
    );
  }
}
