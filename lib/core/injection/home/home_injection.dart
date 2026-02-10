import 'package:get_it/get_it.dart';
import 'package:partners/features/home/data/datasource/home_datasource.dart';
import 'package:partners/features/home/data/datasource/provider_memory/mock_home_datasource_impl.dart';
import 'package:partners/features/home/data/repository/home_repository_impl.dart';
import 'package:partners/features/home/domain/repository/home_repository.dart';
import 'package:partners/features/home/domain/use_case/get_recent_transactions_usecase.dart';
import 'package:partners/features/home/domain/use_case/get_smart_card_usecase.dart';
import 'package:partners/features/home/domain/use_case/get_smart_tools_usecase.dart';
import 'package:partners/features/home/presentation/cubit/home_cubit.dart';

class HomeInjection {
  final GetIt _getIt;

  HomeInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    // Datasource
    if (!_getIt.isRegistered<HomeDatasource>()) {
      _getIt.registerLazySingleton<HomeDatasource>(
        () => MockHomeDatasourceImpl(),
      );
    }

    // Repository
    if (!_getIt.isRegistered<HomeRepository>()) {
      _getIt.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(
          datasource: _getIt<HomeDatasource>(),
        ),
      );
    }

    // Use Cases
    if (!_getIt.isRegistered<GetSmartToolsUsecase>()) {
      _getIt.registerLazySingleton<GetSmartToolsUsecase>(
        () => GetSmartToolsUsecase(
          repository: _getIt<HomeRepository>(),
        ),
      );
    }

    if (!_getIt.isRegistered<GetSmartCardUsecase>()) {
      _getIt.registerLazySingleton<GetSmartCardUsecase>(
        () => GetSmartCardUsecase(
          repository: _getIt<HomeRepository>(),
        ),
      );
    }

    if (!_getIt.isRegistered<GetRecentTransactionsUsecase>()) {
      _getIt.registerLazySingleton<GetRecentTransactionsUsecase>(
        () => GetRecentTransactionsUsecase(
          repository: _getIt<HomeRepository>(),
        ),
      );
    }

    // Cubit
    if (!_getIt.isRegistered<HomeCubit>()) {
      _getIt.registerFactory<HomeCubit>(
        () => HomeCubit(
          getSmartToolsUsecase: _getIt<GetSmartToolsUsecase>(),
          getSmartCardUsecase: _getIt<GetSmartCardUsecase>(),
          getRecentTransactionsUsecase: _getIt<GetRecentTransactionsUsecase>(),
        ),
      );
    }
  }
}
