import 'package:get_it/get_it.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/features/employees/data/datasource/employees_datasource.dart';
import 'package:partners/features/employees/data/datasource/ntw/ntw_employees_datasource_impl.dart';
import 'package:partners/features/employees/data/repository/employees_repository_impl.dart';
import 'package:partners/features/employees/domain/repository/employees_repository.dart';
import 'package:partners/features/employees/domain/use_case/create_employee_usecase.dart';
import 'package:partners/features/employees/domain/use_case/delete_employee_usecase.dart';
import 'package:partners/features/employees/domain/use_case/get_employee_by_id_usecase.dart';
import 'package:partners/features/employees/domain/use_case/get_employees_branch_usecase.dart';
import 'package:partners/features/employees/domain/use_case/get_options_branches_usecase.dart';
import 'package:partners/features/employees/domain/use_case/get_options_roles_usecase.dart';
import 'package:partners/features/employees/domain/use_case/update_employee_usecase.dart';
import 'package:partners/features/employees/presentation/cubit/create_employee_cubit.dart';
import 'package:partners/features/employees/presentation/cubit/employees_list_cubit.dart';

class EmployeesInjection {
  final GetIt _getIt;

  EmployeesInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    if (!_getIt.isRegistered<EmployeesDatasource>()) {
      _getIt.registerLazySingleton<EmployeesDatasource>(
        () => NtwEmployeesDatasourceImpl(services: _getIt<ApiServices>()),
      );
    }
    if (!_getIt.isRegistered<EmployeesRepository>()) {
      _getIt.registerLazySingleton<EmployeesRepository>(
        () => EmployeesRepositoryImpl(
          datasource: _getIt<EmployeesDatasource>(),
        ),
      );
    }
    if (!_getIt.isRegistered<GetEmployeesBranchUsecase>()) {
      _getIt.registerLazySingleton<GetEmployeesBranchUsecase>(
        () => GetEmployeesBranchUsecase(
          repository: _getIt<EmployeesRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<GetOptionsBranchesUsecase>()) {
      _getIt.registerLazySingleton<GetOptionsBranchesUsecase>(
        () => GetOptionsBranchesUsecase(
          repository: _getIt<EmployeesRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<GetOptionsRolesUsecase>()) {
      _getIt.registerLazySingleton<GetOptionsRolesUsecase>(
        () => GetOptionsRolesUsecase(
          repository: _getIt<EmployeesRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<GetEmployeeByIdUsecase>()) {
      _getIt.registerLazySingleton<GetEmployeeByIdUsecase>(
        () => GetEmployeeByIdUsecase(
          repository: _getIt<EmployeesRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<UpdateEmployeeUsecase>()) {
      _getIt.registerLazySingleton<UpdateEmployeeUsecase>(
        () => UpdateEmployeeUsecase(
          repository: _getIt<EmployeesRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<DeleteEmployeeUsecase>()) {
      _getIt.registerLazySingleton<DeleteEmployeeUsecase>(
        () => DeleteEmployeeUsecase(
          repository: _getIt<EmployeesRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<CreateEmployeeUsecase>()) {
      _getIt.registerLazySingleton<CreateEmployeeUsecase>(
        () => CreateEmployeeUsecase(
          repository: _getIt<EmployeesRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<EmployeesListCubit>()) {
      _getIt.registerFactory<EmployeesListCubit>(
        () => EmployeesListCubit(
          getEmployeesBranchUsecase: _getIt<GetEmployeesBranchUsecase>(),
          getOptionsBranchesUsecase: _getIt<GetOptionsBranchesUsecase>(),
        ),
      );
    }
    if (!_getIt.isRegistered<CreateEmployeeCubit>()) {
      _getIt.registerFactory<CreateEmployeeCubit>(
        () => CreateEmployeeCubit(
          createEmployeeUsecase: _getIt<CreateEmployeeUsecase>(),
          getOptionsBranchesUsecase: _getIt<GetOptionsBranchesUsecase>(),
          getOptionsRolesUsecase: _getIt<GetOptionsRolesUsecase>(),
        ),
      );
    }
  }
}
