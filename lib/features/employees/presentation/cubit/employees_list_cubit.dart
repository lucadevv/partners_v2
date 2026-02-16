import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/employees/domain/use_case/get_employees_branch_usecase.dart';
import 'package:partners/features/employees/domain/use_case/get_options_branches_usecase.dart';
import 'package:partners/features/employees/presentation/cubit/employees_list_state.dart';

/// Cubit para la lista de empleados (infinite scroll + opciones de sucursal).
class EmployeesListCubit extends Cubit<EmployeesListState> with BaseCubitMixin {
  EmployeesListCubit({
    required GetEmployeesBranchUsecase getEmployeesBranchUsecase,
    required GetOptionsBranchesUsecase getOptionsBranchesUsecase,
  })  : _getEmployeesBranchUsecase = getEmployeesBranchUsecase,
        _getOptionsBranchesUsecase = getOptionsBranchesUsecase,
        super(const EmployeesListState());

  final GetEmployeesBranchUsecase _getEmployeesBranchUsecase;
  final GetOptionsBranchesUsecase _getOptionsBranchesUsecase;

  /// Carga opciones de sucursales y primera página de empleados.
  Future<void> loadInitial() async {
    emit(state.copyWith(status: EmployeesListStatus.loading, errorMessage: null));

    final optionsResult = await _getOptionsBranchesUsecase();
    optionsResult.fold(
      (failure) {
        emit(state.copyWith(
          status: EmployeesListStatus.failure,
          errorMessage: getErrorMessage(failure),
        ));
        return;
      },
      (options) {
        emit(state.copyWith(branchOptions: options));
      },
    );
    if (state.status == EmployeesListStatus.failure) {
      return;
    }

    final result = await _getEmployeesBranchUsecase(1);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: EmployeesListStatus.failure,
          errorMessage: getErrorMessage(failure),
        ));
      },
      (paginated) {
        emit(state.copyWith(
          status: EmployeesListStatus.success,
          employees: paginated.data,
          meta: paginated.meta,
        ));
      },
    );
  }

  /// Carga siguiente página (infinite scroll).
  Future<void> loadMore() async {
    if (state.status == EmployeesListStatus.loadingMore ||
        state.status == EmployeesListStatus.loading) {
      return;
    }
    if (!state.hasNextPage) {
      return;
    }

    emit(state.copyWith(status: EmployeesListStatus.loadingMore));

    final result = await _getEmployeesBranchUsecase(state.nextPage);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: EmployeesListStatus.success,
          errorMessage: getErrorMessage(failure),
        ));
      },
      (paginated) {
        emit(state.copyWith(
          status: EmployeesListStatus.success,
          employees: [...state.employees, ...paginated.data],
          meta: paginated.meta,
        ));
      },
    );
  }

  void selectBranch(String? branchId) {
    emit(state.copyWith(selectedBranchIdOrUndefined: branchId));
  }
}
