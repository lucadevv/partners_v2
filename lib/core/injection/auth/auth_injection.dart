import 'package:get_it/get_it.dart';

import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/features/auth/login/data/datasource/login_datasource.dart';
import 'package:partners/features/auth/login/data/datasource/provider_memory/mock_login_datasource_impl.dart';
import 'package:partners/features/auth/login/data/repository/login_repository_impl.dart';
import 'package:partners/features/auth/login/domain/repository/login_repository.dart';
import 'package:partners/features/auth/login/domain/use_case/login_usecase.dart';
import 'package:partners/features/auth/register/data/datasource/ntw/ntw_register_datasource_impl.dart';
import 'package:partners/features/auth/register/data/datasource/register_datasource.dart';
import 'package:partners/features/auth/register/data/repository/register_repository_impl.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';
import 'package:partners/features/auth/register/domain/use_case/send_document_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/send_ruc_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/start_register_usecase.dart';
import 'package:partners/main.dart';

class AuthInjection {
  final GetIt _getIt;

  AuthInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    // Register
    if (!_getIt.isRegistered<RegisterDatasource>()) {
      _getIt.registerLazySingleton<RegisterDatasource>(
        () => NtwRegisterDatasourceImpl(services: getIt<ApiServices>()),
      );
    }

    if (!_getIt.isRegistered<RegisterRepository>()) {
      _getIt.registerLazySingleton<RegisterRepository>(
        () => RegisterRepositoryImpl(datasource: getIt<RegisterDatasource>()),
      );
    }

    if (!_getIt.isRegistered<SendDocumentUsecase>()) {
      _getIt.registerLazySingleton<SendDocumentUsecase>(
        () => SendDocumentUsecase(repository: getIt<RegisterRepository>()),
      );
    }

    if (!_getIt.isRegistered<SendRucUsecase>()) {
      _getIt.registerLazySingleton<SendRucUsecase>(
        () => SendRucUsecase(repository: getIt<RegisterRepository>()),
      );
    }
    if (!_getIt.isRegistered<StartRegisterUsecase>()) {
      _getIt.registerLazySingleton<StartRegisterUsecase>(
        () => StartRegisterUsecase(repository: getIt<RegisterRepository>()),
      );
    }

    // Login Injection
    if (!_getIt.isRegistered<LoginDatasource>()) {
      _getIt.registerLazySingleton<LoginDatasource>(
        () => MockLoginDatasourceImpl(),
      );
    }

    if (!_getIt.isRegistered<LoginRepository>()) {
      _getIt.registerLazySingleton<LoginRepository>(
        () => LoginRepositoryImpl(datasource: _getIt<LoginDatasource>()),
      );
    }

    if (!_getIt.isRegistered<LoginUsecase>()) {
      _getIt.registerLazySingleton<LoginUsecase>(
        () => LoginUsecase(repository: _getIt<LoginRepository>()),
      );
    }
  }
}
