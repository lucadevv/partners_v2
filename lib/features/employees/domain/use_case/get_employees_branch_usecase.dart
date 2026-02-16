import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/paginated_result.dart';
import 'package:partners/features/employees/domain/entities/employee_entity.dart';
import 'package:partners/features/employees/domain/repository/employees_repository.dart';

/// Caso de uso: listar empleados de sucursal (GET /employees-branch?page=).
class GetEmployeesBranchUsecase {
  GetEmployeesBranchUsecase({required EmployeesRepository repository})
      : _repository = repository;

  final EmployeesRepository _repository;

  Future<Either<AppException, PaginatedResult<EmployeeEntity>>> call(int page) {
    return _repository.getEmployeesBranch(page);
  }
}
