import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/core/services/database/flags/session_id_storage.dart';
import 'package:partners/core/theme/theme.dart';
import 'package:partners/core/utils/utils.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
import 'package:partners/features/auth/document_scan/domain/domain.dart';
import 'package:partners/features/auth/document_scan/presentation/presentation.dart';
import 'package:partners/features/auth/login/domain/domain.dart';
import 'package:partners/features/auth/login/presentation/presentation.dart';
import 'package:partners/features/auth/register/domain/domain.dart';
import 'package:partners/features/auth/register/presentation/presentation.dart';
import 'package:partners/features/auth/validation/domain/domain.dart';
import 'package:partners/features/auth/validation/presentation/presentation.dart';
import 'package:partners/main.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RegisterCubit(
              sendDocumentUsecase: getIt<SendDocumentUsecase>(),
              sendRucUsecase: getIt<SendRucUsecase>(),
              startRegisterUsecase: getIt<StartRegisterUsecase>(),
              sessionStorage: getIt<SessionIdStorage>(),
            ),
          ),
          BlocProvider(
            create: (context) => ValidationCubit(
              getValidationStepsUsecase: getIt<GetValidationStepsUsecase>(),
            ),
          ),
          BlocProvider(
            create: (context) => EmailValidationCubit(
              sendEmailValidationUsecase: getIt<SendEmailValidationUsecase>(),
              resendEmailCodeUsecase: getIt<ResendEmailCodeUsecase>(),
            ),
          ),

          BlocProvider(
            create: (context) => WhatsappValidationCubit(
              sendWhatsappValidationUsecase:
                  getIt<SendWhatsappValidationUsecase>(),
              verifyWhatsappOtpUsecase: getIt<VerifyWhatsappOtpUsecase>(),
            ),
          ),
          BlocProvider(
            create: (context) => PasswordValidationCubit(
              completePasswordUsecase: getIt<CompletePasswordUsecase>(),
              authManager: getIt<AuthManager>(),
            ),
          ),
          BlocProvider(
            create: (context) => BusinessValidationCubit(
              validateBusinessUsecase: getIt<ValidateBusinessUsecase>(),
            ),
          ),
          BlocProvider(
            create: (context) => DocumentScanCubit(
              ocrUsecase: getIt<OcrUsecase>(),
              watchDocumentRealtTimeUsecase:
                  getIt<WatchDocumentRealtTimeUsecase>(),
              uploadIdentityUsecase: getIt<UploadIdentityUsecase>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                LoginCubit(loginUsecase: getIt<LoginUsecase>()),
          ),
          BlocProvider(
            create: (context) => OrquestorAuthCubit(
              authManager: getIt<AuthManager>(),
              registerCubit: BlocProvider.of<RegisterCubit>(context),
              loginCubit: BlocProvider.of<LoginCubit>(context),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Partners',
          theme: AppTheme.ligth(),
          routerConfig: getIt<AppRouter>().config(
            navigatorObservers: () => [AutoRouteObserver()],
          ),
          debugShowCheckedModeBanner: false,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Error al construir App', e, stackTrace, 'App');
      return MaterialApp(
        title: 'Partners',
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Error al inicializar la aplicación'),
                const SizedBox(height: 8),
                Text('$e', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      );
    }
  }
}
