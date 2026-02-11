import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/branches/domain/use_case/get_branches_usecase.dart';
import 'package:partners/features/branches/presentation/cubit/branches_state.dart';

/// Cubit to manage Branches screen state
/// Follows Single Responsibility Principle (SRP)
class BranchesCubit extends Cubit<BranchesState> with BaseCubitMixin {
  final GetBranchesUsecase _getBranchesUsecase;

  BranchesCubit({
    required GetBranchesUsecase getBranchesUsecase,
  })  : _getBranchesUsecase = getBranchesUsecase,
        super(const BranchesState());

  /// Load branches data
  Future<void> loadBranches() async {
    emit(state.copyWith(status: BranchesStatus.loading));

    final result = await _getBranchesUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: BranchesStatus.failure,
          errorMessage: getErrorMessage(failure),
        ));
      },
      (branches) {
        emit(state.copyWith(
          status: BranchesStatus.success,
          branches: branches,
        ));
      },
    );
  }
}
