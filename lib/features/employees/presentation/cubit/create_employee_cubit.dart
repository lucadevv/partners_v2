import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/employees/domain/entities/branch_option_entity.dart';
import 'package:partners/features/employees/domain/entities/create_employee_params.dart';
import 'package:partners/features/employees/domain/entities/role_option_entity.dart';
import 'package:partners/features/employees/domain/use_case/create_employee_usecase.dart';
import 'package:partners/features/employees/domain/use_case/get_options_branches_usecase.dart';
import 'package:partners/features/employees/domain/use_case/get_options_roles_usecase.dart';
import 'package:partners/features/employees/presentation/cubit/create_employee_state.dart';

class CreateEmployeeCubit extends Cubit<CreateEmployeeState> with BaseCubitMixin {
  CreateEmployeeCubit({
    required CreateEmployeeUsecase createEmployeeUsecase,
    required GetOptionsBranchesUsecase getOptionsBranchesUsecase,
    required GetOptionsRolesUsecase getOptionsRolesUsecase,
  })  : _createEmployeeUsecase = createEmployeeUsecase,
        _getOptionsBranchesUsecase = getOptionsBranchesUsecase,
        _getOptionsRolesUsecase = getOptionsRolesUsecase,
        super(const CreateEmployeeState());

  final CreateEmployeeUsecase _createEmployeeUsecase;
  final GetOptionsBranchesUsecase _getOptionsBranchesUsecase;
  final GetOptionsRolesUsecase _getOptionsRolesUsecase;

  /// Carga opciones de sucursales y roles (fold solo en Cubit).
  Future<void> loadOptions() async {
    if (state.optionsLoading) return;
    emit(state.copyWith(optionsLoading: true));
    final branchesResult = await _getOptionsBranchesUsecase();
    final rolesResult = await _getOptionsRolesUsecase();
    List<BranchOptionEntity> branches = [];
    List<RoleOptionEntity> roles = [];
    branchesResult.fold((_) {}, (list) => branches = list);
    rolesResult.fold((_) {}, (list) => roles = list);
    emit(state.copyWith(
      optionsLoading: false,
      branchOptions: branches,
      roleOptions: roles,
    ));
  }

  Future<void> createEmployee(CreateEmployeeParams params) async {
    if (state.status == CreateEmployeeStatus.loading) return;
    emit(state.copyWith(status: CreateEmployeeStatus.loading, errorMessage: null));

    final result = await _createEmployeeUsecase(params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: CreateEmployeeStatus.failure,
          errorMessage: getErrorMessage(failure),
        ));
      },
      (message) {
        emit(state.copyWith(
          status: CreateEmployeeStatus.success,
          successMessage: message,
        ));
      },
    );
  }

  void reset() {
    emit(const CreateEmployeeState());
  }
}
