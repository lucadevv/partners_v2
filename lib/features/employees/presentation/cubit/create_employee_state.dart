import 'package:equatable/equatable.dart';
import 'package:partners/features/employees/domain/entities/branch_option_entity.dart';
import 'package:partners/features/employees/domain/entities/role_option_entity.dart';

enum CreateEmployeeStatus { initial, loading, success, failure }

class CreateEmployeeState extends Equatable {
  final CreateEmployeeStatus status;
  final String? successMessage;
  final String? errorMessage;
  final List<BranchOptionEntity> branchOptions;
  final List<RoleOptionEntity> roleOptions;
  final bool optionsLoading;

  const CreateEmployeeState({
    this.status = CreateEmployeeStatus.initial,
    this.successMessage,
    this.errorMessage,
    this.branchOptions = const [],
    this.roleOptions = const [],
    this.optionsLoading = false,
  });

  CreateEmployeeState copyWith({
    CreateEmployeeStatus? status,
    String? successMessage,
    String? errorMessage,
    List<BranchOptionEntity>? branchOptions,
    List<RoleOptionEntity>? roleOptions,
    bool? optionsLoading,
  }) {
    return CreateEmployeeState(
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      branchOptions: branchOptions ?? this.branchOptions,
      roleOptions: roleOptions ?? this.roleOptions,
      optionsLoading: optionsLoading ?? this.optionsLoading,
    );
  }

  @override
  List<Object?> get props =>
      [status, successMessage, errorMessage, branchOptions, roleOptions, optionsLoading];
}
