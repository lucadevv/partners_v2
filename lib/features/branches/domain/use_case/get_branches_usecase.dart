import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/branch_entity.dart';
import 'package:partners/features/branches/domain/repository/branches_repository.dart';

/// Use Case to get all branches
/// Follows Single Responsibility Principle (SRP)
class GetBranchesUsecase {
  final BranchesRepository _repository;

  GetBranchesUsecase({required BranchesRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<BranchEntity>>> call() async {
    return await _repository.getBranches();
  }
}
