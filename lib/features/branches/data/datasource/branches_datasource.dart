import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/data/models/branch_model.dart';

/// Datasource interface for Branches (Data Layer)
abstract class BranchesDatasource {
  Future<Either<AppException, List<BranchModel>>> getBranches();
}
