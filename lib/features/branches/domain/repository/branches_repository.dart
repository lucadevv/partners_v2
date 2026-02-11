import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/branch_entity.dart';

/// Repository interface for Branches feature (Domain Layer)
/// Follows Dependency Inversion Principle (DIP)
abstract class BranchesRepository {
  Future<Either<AppException, List<BranchEntity>>> getBranches();
}
