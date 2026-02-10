import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/home/domain/use_case/get_recent_transactions_usecase.dart';
import 'package:partners/features/home/domain/use_case/get_smart_card_usecase.dart';
import 'package:partners/features/home/domain/use_case/get_smart_tools_usecase.dart';
import 'package:partners/features/home/presentation/cubit/home_state.dart';

/// Cubit to manage Home screen state
/// Follows Single Responsibility Principle (SRP)
class HomeCubit extends Cubit<HomeState> with BaseCubitMixin {
  final GetSmartToolsUsecase _getSmartToolsUsecase;
  final GetSmartCardUsecase _getSmartCardUsecase;
  final GetRecentTransactionsUsecase _getRecentTransactionsUsecase;

  HomeCubit({
    required GetSmartToolsUsecase getSmartToolsUsecase,
    required GetSmartCardUsecase getSmartCardUsecase,
    required GetRecentTransactionsUsecase getRecentTransactionsUsecase,
  })  : _getSmartToolsUsecase = getSmartToolsUsecase,
        _getSmartCardUsecase = getSmartCardUsecase,
        _getRecentTransactionsUsecase = getRecentTransactionsUsecase,
        super(const HomeState());

  /// Load initial data
  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final toolsResult = await _getSmartToolsUsecase();
    final cardResult = await _getSmartCardUsecase();
    final transactionsResult = await _getRecentTransactionsUsecase();

    toolsResult.fold(
      (failure) {
        emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: getErrorMessage(failure),
        ));
      },
      (tools) {
        cardResult.fold(
          (failure) {
            emit(state.copyWith(
              status: HomeStatus.failure,
              errorMessage: getErrorMessage(failure),
            ));
          },
          (card) {
            transactionsResult.fold(
              (failure) {
                emit(state.copyWith(
                  status: HomeStatus.failure,
                  errorMessage: getErrorMessage(failure),
                ));
              },
              (transactions) {
                emit(state.copyWith(
                  status: HomeStatus.success,
                  smartTools: tools,
                  smartCard: card,
                  recentTransactions: transactions,
                ));
              },
            );
          },
        );
      },
    );
  }
}
