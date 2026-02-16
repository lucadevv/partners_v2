import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/employees/domain/entities/employee_entity.dart';
import 'package:partners/features/employees/domain/repository/employees_repository.dart';

/// Caso de uso: detalle de empleado (GET /employees-branch/{id}).
class GetEmployeeByIdUsecase {
  GetEmployeeByIdUsecase({required EmployeesRepository repository})
      : _repository = repository;

  final EmployeesRepository _repository;

  Future<Either<AppException, EmployeeEntity>> call(String id) {
    return _repository.getEmployeeById(id);
  }
}
