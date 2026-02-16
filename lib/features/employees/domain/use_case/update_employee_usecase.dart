import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/employees/domain/entities/update_employee_params.dart';
import 'package:partners/features/employees/domain/repository/employees_repository.dart';

/// Caso de uso: actualizar empleado (PUT /employees-branch/{id}).
class UpdateEmployeeUsecase {
  UpdateEmployeeUsecase({required EmployeesRepository repository})
      : _repository = repository;

  final EmployeesRepository _repository;

  Future<Either<AppException, String>> call(String id, UpdateEmployeeParams params) {
    return _repository.updateEmployee(id, params);
  }
}
