import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/employees/domain/entities/create_employee_params.dart';
import 'package:partners/features/employees/domain/repository/employees_repository.dart';

/// Caso de uso: crear empleado (POST /employees-branch multipart).
class CreateEmployeeUsecase {
  CreateEmployeeUsecase({required EmployeesRepository repository})
      : _repository = repository;

  final EmployeesRepository _repository;

  Future<Either<AppException, String>> call(CreateEmployeeParams params) {
    return _repository.createEmployee(params);
  }
}
