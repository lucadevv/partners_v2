import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/transactions/domain/use_case/get_transactions_usecase.dart';
import 'package:partners/features/transactions/presentation/cubit/transactions_state.dart';

/// Cubit for Transactions screen state
class TransactionsCubit extends Cubit<TransactionsState> with BaseCubitMixin {
  final GetTransactionsUsecase _getTransactionsUsecase;

  TransactionsCubit({required GetTransactionsUsecase getTransactionsUsecase})
    : _getTransactionsUsecase = getTransactionsUsecase,
      super(const TransactionsState());

  Future<void> loadTransactions() async {
    emit(state.copyWith(status: TransactionsStatus.loading));

    final result = await _getTransactionsUsecase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: TransactionsStatus.failure,
            errorMessage: getErrorMessage(failure),
          ),
        );
      },
      (transactions) {
        emit(
          state.copyWith(
            status: TransactionsStatus.success,
            transactions: transactions,
          ),
        );
      },
    );
  }
}
