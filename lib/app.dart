import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/routes/app_routes.dart';
import 'package:partners/core/theme/app_theme.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
import 'package:partners/features/auth/register/domain/use_case/validate_commerce_usecase.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/main.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final registerCubit = RegisterCubit(
      validateCommerceUsecase: getIt<ValidateCommerceUsecase>(),
    );

    final orquestorAuthCubit = OrquestorAuthCubit(registerCubit: registerCubit);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: registerCubit),
        BlocProvider.value(value: orquestorAuthCubit),
      ],
      child: MaterialApp.router(
        title: 'Partners',
        theme: AppTheme.ligth(),
        routerConfig: getIt<AppRouter>().config(),
      ),
    );
  }
}
