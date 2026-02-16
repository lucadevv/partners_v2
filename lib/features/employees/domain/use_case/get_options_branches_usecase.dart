import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/employees/domain/entities/branch_option_entity.dart';
import 'package:partners/features/employees/domain/repository/employees_repository.dart';

/// Caso de uso: opciones de sucursales para selector (GET /options/branches).
class GetOptionsBranchesUsecase {
  GetOptionsBranchesUsecase({required EmployeesRepository repository})
      : _repository = repository;

  final EmployeesRepository _repository;

  Future<Either<AppException, List<BranchOptionEntity>>> call() {
    return _repository.getOptionsBranches();
  }
}
