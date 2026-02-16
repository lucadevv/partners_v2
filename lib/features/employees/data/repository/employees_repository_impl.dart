import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/paginated_result.dart';
import 'package:partners/features/employees/data/datasource/employees_datasource.dart';
import 'package:partners/features/employees/domain/entities/branch_option_entity.dart';
import 'package:partners/features/employees/domain/entities/create_employee_params.dart';
import 'package:partners/features/employees/domain/entities/employee_entity.dart';
import 'package:partners/features/employees/domain/entities/role_option_entity.dart';
import 'package:partners/features/employees/domain/entities/update_employee_params.dart';
import 'package:partners/features/employees/domain/repository/employees_repository.dart';

/// Implementación de [EmployeesRepository].
class EmployeesRepositoryImpl implements EmployeesRepository {
  EmployeesRepositoryImpl({required EmployeesDatasource datasource})
      : _datasource = datasource;

  final EmployeesDatasource _datasource;

  @override
  Future<Either<AppException, PaginatedResult<EmployeeEntity>>> getEmployeesBranch(
    int page,
  ) async {
    final result = await _datasource.getEmployeesBranch(page);
    return result.map((response) {
      final meta = PaginationMeta(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        perPage: response.meta.perPage,
        total: response.meta.total,
      );
      return PaginatedResult<EmployeeEntity>(
        data: response.data.map((m) => m.toEntity()).toList(),
        meta: meta,
      );
    });
  }

  @override
  Future<Either<AppException, EmployeeEntity>> getEmployeeById(String id) async {
    final result = await _datasource.getEmployeeById(id);
    return result.map((response) => response.data.toEntity());
  }

  @override
  Future<Either<AppException, List<BranchOptionEntity>>> getOptionsBranches() async {
    final result = await _datasource.getOptionsBranches();
    return result.map((response) =>
        response.data.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Either<AppException, List<RoleOptionEntity>>> getOptionsRoles() async {
    final result = await _datasource.getOptionsRoles();
    return result.map((response) =>
        response.data.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Either<AppException, String>> createEmployee(CreateEmployeeParams params) async {
    return _datasource.createEmployee(params);
  }

  @override
  Future<Either<AppException, String>> updateEmployee(
    String id,
    UpdateEmployeeParams params,
  ) async {
    return _datasource.updateEmployee(id, params);
  }

  @override
  Future<Either<AppException, String>> deleteEmployee(String id) async {
    return _datasource.deleteEmployee(id);
  }
}
