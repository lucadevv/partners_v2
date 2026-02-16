import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/paginated_result.dart';
import 'package:partners/features/employees/domain/entities/branch_option_entity.dart';
import 'package:partners/features/employees/domain/entities/create_employee_params.dart';
import 'package:partners/features/employees/domain/entities/employee_entity.dart';
import 'package:partners/features/employees/domain/entities/role_option_entity.dart';
import 'package:partners/features/employees/domain/entities/update_employee_params.dart';

/// Repositorio del feature employees.
abstract class EmployeesRepository {
  /// Lista paginada (GET /employees-branch?page=).
  Future<Either<AppException, PaginatedResult<EmployeeEntity>>> getEmployeesBranch(
    int page,
  );

  /// Detalle de un empleado (GET /employees-branch/{id}).
  Future<Either<AppException, EmployeeEntity>> getEmployeeById(String id);

  /// Opciones de sucursales (GET /options/branches).
  Future<Either<AppException, List<BranchOptionEntity>>> getOptionsBranches();

  /// Opciones de roles (GET /options/roles).
  Future<Either<AppException, List<RoleOptionEntity>>> getOptionsRoles();

  /// Crear empleado (POST /employees-branch multipart).
  Future<Either<AppException, String>> createEmployee(CreateEmployeeParams params);

  /// Actualizar empleado (PUT /employees-branch/{id} multipart).
  Future<Either<AppException, String>> updateEmployee(
    String id,
    UpdateEmployeeParams params,
  );

  /// Eliminar empleado (DELETE /employees-branch/{id}).
  Future<Either<AppException, String>> deleteEmployee(String id);
}
