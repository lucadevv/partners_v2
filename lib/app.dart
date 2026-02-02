import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/routes/app_routes.dart';
import 'package:partners/core/theme/app_theme.dart';
import 'package:partners/core/utils/logger/app_logger.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/ocr_usecase.dart';
import 'package:partners/features/auth/document_scan/domain/use_case/watch_document_realt_time_usecase.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document/document_scan_cubit.dart';
import 'package:partners/features/auth/login/domain/use_case/login_usecase.dart';
import 'package:partners/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:partners/features/auth/register/domain/use_case/send_document_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/send_ruc_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/start_register_usecase.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/features/auth/validation/domain/use_case/get_validation_steps_usecase.dart';
import 'package:partners/features/auth/validation/domain/use_case/resend_email_code_usecase.dart';
import 'package:partners/features/auth/validation/domain/use_case/send_email_validation_usecase.dart';
import 'package:partners/features/auth/validation/domain/use_case/send_whatsapp_validation_usecase.dart';
import 'package:partners/features/auth/validation/domain/use_case/verify_whatsapp_otp_usecase.dart';
import 'package:partners/features/auth/validation/presentation/cubit/email/email_validation_cubit.dart';
import 'package:partners/features/auth/validation/presentation/cubit/validation_cubit.dart';
import 'package:partners/features/auth/validation/presentation/cubit/whatsapp/whatsapp_validation_cubit.dart';
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
            create: (context) => DocumentScanCubit(
              ocrUsecase: getIt<OcrUsecase>(),
              watchDocumentRealtTimeUsecase:
                  getIt<WatchDocumentRealtTimeUsecase>(),
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
