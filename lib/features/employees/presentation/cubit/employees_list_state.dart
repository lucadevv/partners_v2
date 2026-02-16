import 'package:equatable/equatable.dart';
import 'package:partners/features/branches/domain/entities/paginated_result.dart';
import 'package:partners/features/employees/domain/entities/branch_option_entity.dart';
import 'package:partners/features/employees/domain/entities/employee_entity.dart';

enum EmployeesListStatus {
  initial,
  loading,
  loadingMore,
  success,
  failure,
}

class EmployeesListState extends Equatable {
  final EmployeesListStatus status;
  final List<EmployeeEntity> employees;
  final PaginationMeta? meta;
  final List<BranchOptionEntity> branchOptions;
  final String? selectedBranchId;
  final String? errorMessage;

  const EmployeesListState({
    this.status = EmployeesListStatus.initial,
    this.employees = const [],
    this.meta,
    this.branchOptions = const [],
    this.selectedBranchId,
    this.errorMessage,
  });

  bool get hasNextPage => meta?.hasNextPage ?? false;
  int get nextPage => meta?.nextPage ?? 1;

  /// [selectedBranchIdOrUndefined] usa sentinela para poder asignar null (ej. "Todas").
  static const _undefinedBranch = _UndefinedBranch();

  EmployeesListState copyWith({
    EmployeesListStatus? status,
    List<EmployeeEntity>? employees,
    PaginationMeta? meta,
    List<BranchOptionEntity>? branchOptions,
    Object? selectedBranchIdOrUndefined,
    String? errorMessage,
  }) {
    return EmployeesListState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      meta: meta ?? this.meta,
      branchOptions: branchOptions ?? this.branchOptions,
      selectedBranchId: identical(selectedBranchIdOrUndefined, _undefinedBranch)
          ? selectedBranchId
          : selectedBranchIdOrUndefined as String?,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, employees, meta, branchOptions, selectedBranchId, errorMessage];
}

class _UndefinedBranch {
  const _UndefinedBranch();
}
