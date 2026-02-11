import 'package:equatable/equatable.dart';
import 'package:partners/features/branches/domain/entities/branch_entity.dart';

/// Estados del BranchesCubit
enum BranchesStatus {
  initial,
  loading,
  success,
  failure,
}

/// Estado del BranchesCubit
class BranchesState extends Equatable {
  final BranchesStatus status;
  final List<BranchEntity> branches;
  final String? errorMessage;

  const BranchesState({
    this.status = BranchesStatus.initial,
    this.branches = const [],
    this.errorMessage,
  });

  BranchesState copyWith({
    BranchesStatus? status,
    List<BranchEntity>? branches,
    String? errorMessage,
  }) {
    return BranchesState(
      status: status ?? this.status,
      branches: branches ?? this.branches,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, branches, errorMessage];
}
