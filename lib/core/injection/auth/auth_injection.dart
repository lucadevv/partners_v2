import 'package:get_it/get_it.dart';
import 'package:partners/features/auth/register/data/datasource/provider_memory/mock_register_datasource_impl.dart';
import 'package:partners/features/auth/register/data/datasource/register_datasource.dart';
import 'package:partners/features/auth/register/data/repository/register_repository_impl.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';
import 'package:partners/features/auth/register/domain/use_case/validate_commerce_usecase.dart';

class AuthInjection {
  final GetIt _getIt;

  AuthInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    if (!_getIt.isRegistered<RegisterDatasource>()) {
      _getIt.registerLazySingleton<RegisterDatasource>(
        () => MockRegisterDatasourceImpl(),
      );
    }

    if (!_getIt.isRegistered<RegisterRepository>()) {
      _getIt.registerLazySingleton<RegisterRepository>(
        () => RegisterRepositoryImpl(
          registerDatasource: _getIt<RegisterDatasource>(),
        ),
      );
    }
    if (!_getIt.isRegistered<ValidateCommerceUsecase>()) {
      _getIt.registerLazySingleton<ValidateCommerceUsecase>(
        () => ValidateCommerceUsecase(repository: _getIt<RegisterRepository>()),
      );
    }
  }
}
