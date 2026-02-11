import 'package:get_it/get_it.dart';
import 'package:partners/features/promos/data/datasource/promos_datasource.dart';
import 'package:partners/features/promos/data/datasource/provider_memory/mock_promos_datasource_impl.dart';
import 'package:partners/features/promos/data/datasource/scope_users_datasource.dart';
import 'package:partners/features/promos/data/datasource/provider_memory/mock_scope_users_datasource_impl.dart';
import 'package:partners/features/promos/data/repository/promos_repository_impl.dart';
import 'package:partners/features/promos/data/repository/scope_users_repository_impl.dart';
import 'package:partners/features/promos/domain/repository/promos_repository.dart';
import 'package:partners/features/promos/domain/repository/scope_users_repository.dart';
import 'package:partners/features/promos/domain/use_case/get_promos_usecase.dart';
import 'package:partners/features/promos/domain/use_case/get_scope_users_usecase.dart';
import 'package:partners/features/promos/presentation/cubit/promos_cubit.dart';

class PromosInjection {
  final GetIt _getIt;

  PromosInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    if (!_getIt.isRegistered<PromosDatasource>()) {
      _getIt.registerLazySingleton<PromosDatasource>(
        () => MockPromosDatasourceImpl(),
      );
    }

    if (!_getIt.isRegistered<PromosRepository>()) {
      _getIt.registerLazySingleton<PromosRepository>(
        () => PromosRepositoryImpl(
          datasource: _getIt<PromosDatasource>(),
        ),
      );
    }

    if (!_getIt.isRegistered<GetPromosUsecase>()) {
      _getIt.registerLazySingleton<GetPromosUsecase>(
        () => GetPromosUsecase(
          repository: _getIt<PromosRepository>(),
        ),
      );
    }

    if (!_getIt.isRegistered<ScopeUsersDatasource>()) {
      _getIt.registerLazySingleton<ScopeUsersDatasource>(
        () => MockScopeUsersDatasourceImpl(),
      );
    }

    if (!_getIt.isRegistered<ScopeUsersRepository>()) {
      _getIt.registerLazySingleton<ScopeUsersRepository>(
        () => ScopeUsersRepositoryImpl(
          datasource: _getIt<ScopeUsersDatasource>(),
        ),
      );
    }

    if (!_getIt.isRegistered<GetScopeUsersUsecase>()) {
      _getIt.registerLazySingleton<GetScopeUsersUsecase>(
        () => GetScopeUsersUsecase(
          repository: _getIt<ScopeUsersRepository>(),
        ),
      );
    }

    if (!_getIt.isRegistered<PromosCubit>()) {
      _getIt.registerFactory<PromosCubit>(
        () => PromosCubit(
          getPromosUsecase: _getIt<GetPromosUsecase>(),
        ),
      );
    }
  }
}
