import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/employees/data/models/employee_detail_response_model.dart';
import 'package:partners/features/employees/data/models/employees_branch_response_model.dart';
import 'package:partners/features/employees/data/models/options_branches_response_model.dart';
import 'package:partners/features/employees/data/models/options_roles_response_model.dart';
import 'package:partners/features/employees/domain/entities/create_employee_params.dart';
import 'package:partners/features/employees/domain/entities/update_employee_params.dart';

/// Datasource del feature employees.
abstract class EmployeesDatasource {
  Future<Either<AppException, EmployeesBranchResponseModel>> getEmployeesBranch(int page);

  Future<Either<AppException, EmployeeDetailResponseModel>> getEmployeeById(String id);

  Future<Either<AppException, OptionsBranchesResponseModel>> getOptionsBranches();

  Future<Either<AppException, OptionsRolesResponseModel>> getOptionsRoles();

  Future<Either<AppException, String>> createEmployee(CreateEmployeeParams params);

  Future<Either<AppException, String>> updateEmployee(String id, UpdateEmployeeParams params);

  Future<Either<AppException, String>> deleteEmployee(String id);
}
