import 'package:get_it/get_it.dart';
import 'package:partners/features/transactions/data/datasource/provider_memory/mock_transactions_datasource_impl.dart';
import 'package:partners/features/transactions/data/datasource/transactions_datasource.dart';
import 'package:partners/features/transactions/data/repository/transactions_repository_impl.dart';
import 'package:partners/features/transactions/domain/repository/transactions_repository.dart';
import 'package:partners/features/transactions/domain/use_case/get_transactions_usecase.dart';
import 'package:partners/features/transactions/presentation/cubit/transactions_cubit.dart';

class TransactionsInjection {
  final GetIt _getIt;

  TransactionsInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    if (!_getIt.isRegistered<TransactionsDatasource>()) {
      _getIt.registerLazySingleton<TransactionsDatasource>(
        () => MockTransactionsDatasourceImpl(),
      );
    }

    if (!_getIt.isRegistered<TransactionsRepository>()) {
      _getIt.registerLazySingleton<TransactionsRepository>(
        () => TransactionsRepositoryImpl(
          datasource: _getIt<TransactionsDatasource>(),
        ),
      );
    }

    if (!_getIt.isRegistered<GetTransactionsUsecase>()) {
      _getIt.registerLazySingleton<GetTransactionsUsecase>(
        () => GetTransactionsUsecase(
          repository: _getIt<TransactionsRepository>(),
        ),
      );
    }

    if (!_getIt.isRegistered<TransactionsCubit>()) {
      _getIt.registerFactory<TransactionsCubit>(
        () => TransactionsCubit(
          getTransactionsUsecase: _getIt<GetTransactionsUsecase>(),
        ),
      );
    }
  }
}
