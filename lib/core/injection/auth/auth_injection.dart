import 'package:get_it/get_it.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/managers/auth/auth_manager_impl.dart';
import 'package:partners/core/managers/auth/storage/token_manager.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/features/auth/document_scan/data/datasource/document_scan_datasource.dart';
import 'package:partners/features/auth/document_scan/data/datasource/provider_memory/mock_document_scan_datasource_impl.dart';
import 'package:partners/features/auth/document_scan/data/repository/document_scan_repository_impl.dart';
import 'package:partners/features/auth/document_scan/domain/repository/document_scan_repository.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/process_document_ocr_usecase.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/validate_document_usecase.dart';
import 'package:partners/features/auth/login/data/datasource/login_datasource.dart';
import 'package:partners/features/auth/login/data/datasource/provider_memory/mock_login_datasource_impl.dart';
import 'package:partners/features/auth/login/data/repository/login_repository_impl.dart';
import 'package:partners/features/auth/login/domain/repository/login_repository.dart';
import 'package:partners/features/auth/login/domain/use_case/login_usecase.dart';
import 'package:partners/features/auth/register/data/datasource/ntw/ntw_register_datasource_impl.dart';
import 'package:partners/features/auth/register/data/datasource/register_datasource.dart';
import 'package:partners/features/auth/register/data/repository/register_repository_impl.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';
import 'package:partners/features/auth/register/domain/use_case/validate_commerce_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/validate_document_register_usecase.dart'
    hide ValidateDocumentUsecase;
import 'package:partners/main.dart';

class AuthInjection {
  final GetIt _getIt;

  AuthInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    // Auth Managers
    if (!_getIt.isRegistered<TokenManager>()) {
      _getIt.registerLazySingleton<TokenManager>(() => TokenManager());
    }

    if (!_getIt.isRegistered<AuthManager>()) {
      _getIt.registerLazySingleton<AuthManager>(
        () => AuthManagerImpl(_getIt<TokenManager>()),
      );
    }

    // Register
    if (!_getIt.isRegistered<RegisterDatasource>()) {
      _getIt.registerLazySingleton<RegisterDatasource>(
        () => NtwRegisterDatasourceImpl(services: getIt<ApiServices>()),
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

    if (!_getIt.isRegistered<ValidateRegisterDocumentRegisterUsecase>()) {
      _getIt.registerLazySingleton<ValidateRegisterDocumentRegisterUsecase>(
        () => ValidateRegisterDocumentRegisterUsecase(
          repository: _getIt<RegisterRepository>(),
        ),
      );
    }

    // Document Scan Injection
    if (!_getIt.isRegistered<DocumentScanDatasource>()) {
      _getIt.registerLazySingleton<DocumentScanDatasource>(
        () => MockDocumentScanDatasourceImpl(),
      );
    }

    if (!_getIt.isRegistered<DocumentScanRepository>()) {
      _getIt.registerLazySingleton<DocumentScanRepository>(
        () => DocumentScanRepositoryImpl(
          datasource: _getIt<DocumentScanDatasource>(),
        ),
      );
    }

    if (!_getIt.isRegistered<ProcessDocumentOcrUsecase>()) {
      _getIt.registerLazySingleton<ProcessDocumentOcrUsecase>(
        () => ProcessDocumentOcrUsecase(),
      );
    }

    if (!_getIt.isRegistered<ValidateDocumentUsecase>()) {
      _getIt.registerLazySingleton<ValidateDocumentUsecase>(
        () => ValidateDocumentUsecase(
          repository: _getIt<DocumentScanRepository>(),
        ),
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
