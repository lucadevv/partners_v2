import 'package:get_it/get_it.dart';
import 'package:partners/core/services/network/api_services.dart';
import 'package:partners/features/auth/validation/data/datasource/ntw_validation_datsource_impl.dart';
import 'package:partners/features/auth/validation/data/datasource/validation_datasource.dart';
import 'package:partners/features/auth/validation/data/repository/validation_repository_impl.dart';
import 'package:partners/features/auth/validation/domain/repository/validation_repository.dart';
import 'package:partners/features/auth/validation/domain/use_case/get_validation_steps_usecase.dart';
import 'package:partners/features/auth/validation/domain/use_case/resend_email_code_usecase.dart';
import 'package:partners/features/auth/validation/domain/use_case/send_email_validation_usecase.dart';
import 'package:partners/features/auth/validation/domain/use_case/send_whatsapp_validation_usecase.dart';
import 'package:partners/features/auth/validation/domain/use_case/verify_whatsapp_otp_usecase.dart';
import 'package:partners/main.dart';

class ValidationInjeciton {
  final GetIt _getIt;

  ValidationInjeciton({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    // Datasources
    if (!_getIt.isRegistered<ValidationDatasource>()) {
      _getIt.registerLazySingleton<ValidationDatasource>(
        () => NtwValidationDatsourceImpl(services: getIt<ApiServices>()),
      );
    }
    //Repositories
    if (!_getIt.isRegistered<ValidationRepository>()) {
      _getIt.registerLazySingleton<ValidationRepository>(
        () =>
            ValidationRepositoryImpl(datasource: getIt<ValidationDatasource>()),
      );
    }
    //Usecases
    if (!_getIt.isRegistered<GetValidationStepsUsecase>()) {
      _getIt.registerLazySingleton<GetValidationStepsUsecase>(
        () => GetValidationStepsUsecase(
          repository: _getIt<ValidationRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<SendEmailValidationUsecase>()) {
      _getIt.registerLazySingleton<SendEmailValidationUsecase>(
        () => SendEmailValidationUsecase(
          repository: _getIt<ValidationRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<ResendEmailCodeUsecase>()) {
      _getIt.registerLazySingleton<ResendEmailCodeUsecase>(
        () =>
            ResendEmailCodeUsecase(repository: _getIt<ValidationRepository>()),
      );
    }
    //---
    if (!_getIt.isRegistered<SendWhatsappValidationUsecase>()) {
      _getIt.registerLazySingleton<SendWhatsappValidationUsecase>(
        () => SendWhatsappValidationUsecase(
          repository: _getIt<ValidationRepository>(),
        ),
      );
    }
    if (!_getIt.isRegistered<VerifyWhatsappOtpUsecase>()) {
      _getIt.registerLazySingleton<VerifyWhatsappOtpUsecase>(
        () => VerifyWhatsappOtpUsecase(
          repository: _getIt<ValidationRepository>(),
        ),
      );
    }
  }
}
