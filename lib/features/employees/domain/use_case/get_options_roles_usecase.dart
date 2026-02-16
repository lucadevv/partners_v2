import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/employees/domain/entities/role_option_entity.dart';
import 'package:partners/features/employees/domain/repository/employees_repository.dart';

/// Caso de uso: opciones de roles (GET /options/roles).
class GetOptionsRolesUsecase {
  GetOptionsRolesUsecase({required EmployeesRepository repository})
      : _repository = repository;

  final EmployeesRepository _repository;

  Future<Either<AppException, List<RoleOptionEntity>>> call() {
    return _repository.getOptionsRoles();
  }
}
