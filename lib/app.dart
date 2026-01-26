import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/routes/app_routes.dart';
import 'package:partners/core/theme/app_theme.dart';
import 'package:partners/core/utils/logger/app_logger.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
import 'package:partners/features/auth/login/domain/use_case/login_usecase.dart';
import 'package:partners/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:partners/features/auth/register/domain/use_case/validate_commerce_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/validate_document_register_usecase.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/main.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() {
    try {
      _appRouter = getIt<AppRouter>();
      _appRouter.config();
    } catch (e, stackTrace) {
      AppLogger.error('Error al inicializar App', e, stackTrace, 'App');
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final routerConfig = _appRouter.config();

      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RegisterCubit(
              validateCommerceUsecase: getIt<ValidateCommerceUsecase>(),
              validateDocumentUsecase:
                  getIt<ValidateRegisterDocumentRegisterUsecase>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                LoginCubit(loginUsecase: getIt<LoginUsecase>()),
          ),
        ],
        child: Builder(
          builder: (context) {
            return BlocProvider(
              create: (context) => OrquestorAuthCubit(
                registerCubit: context.read<RegisterCubit>(),
                loginCubit: context.read<LoginCubit>(),
                authManager: getIt<AuthManager>(),
              ),
              child: MaterialApp.router(
                title: 'Partners',
                theme: AppTheme.ligth(),
                routerConfig: routerConfig,
                debugShowCheckedModeBanner: false,
              ),
            );
          },
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
