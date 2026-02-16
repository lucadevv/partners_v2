import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/employees/domain/repository/employees_repository.dart';

/// Caso de uso: eliminar empleado (DELETE /employees-branch/{id}).
class DeleteEmployeeUsecase {
  DeleteEmployeeUsecase({required EmployeesRepository repository})
      : _repository = repository;

  final EmployeesRepository _repository;

  Future<Either<AppException, String>> call(String id) {
    return _repository.deleteEmployee(id);
  }
}
