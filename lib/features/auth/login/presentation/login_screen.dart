import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/utils/widgets/custom_text_field_widget.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
import 'package:partners/features/auth/login/presentation/login_screen_keys.dart';
import 'package:partners/features/auth/login/presentation/login_screen_strings.dart';
import 'package:partners/features/auth/login/presentation/cubit/login_cubit.dart'
    show LoginStatus;

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reiniciar estado de login al entrar a la pantalla
    // context.read<OrquestorAuthCubit>().resetLoginState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LoginScreenStrings.emptyFieldsSnackBar)),
      );
      return;
    }

    if (!_emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LoginScreenStrings.invalidEmailFormat)),
      );
      return;
    }

    context.read<OrquestorAuthCubit>().login(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrquestorAuthCubit, OrquestorAuthState>(
      listenWhen: (previous, current) =>
          previous.loginState != current.loginState ||
          previous.effect != current.effect,
      listener: (context, state) {
        if (state.loginState.status == LoginStatus.failure &&
            state.loginState.errorMessage != null &&
            state.loginState.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.loginState.errorMessage!)),
          );
          return;
        }
        if (state.effect is NavigationLoginSuccessEffect) {
          context.read<OrquestorAuthCubit>().reset();
          context.router.replaceAll([
            const DashboardRoute(children: [HomeRoute()]),
          ]);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset:
            false, // Evitar que el Scaffold se ajuste cuando aparece el teclado
        body: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                right: -400,
                bottom: -140,
                child: Transform.scale(
                  scale: 1.1,
                  child: Image.asset(
                    'assets/png/person.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: AlignmentGeometry.topCenter,
                    colors: [
                      context.appColor.primary.withValues(alpha: 0.84),
                      Colors.transparent,
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
                child: SizedBox.expand(),
              ),
              Positioned(
                bottom: 30,
                right: 0,
                left: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: -8,
                        children: [
                          Text(
                            LoginScreenStrings.welcomeTitle,
                            style: TextStyle(
                              color: context.appColor.onPrimary,
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            LoginScreenStrings.appName,
                            style: TextStyle(
                              color: context.appColor.onPrimary,
                              fontSize: 30,
                              fontFamily: 'FREDOKA',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SvgPicture.asset('assets/svg/logo.svg'),
                        ],
                      ),
                      Text(
                        LoginScreenStrings.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.appColor.onPrimary,
                          fontSize: 23,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.appColor.onSecondary.withValues(
                            alpha: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 20,
                            children: [
                              CustomTextFieldWidget(
                                key: const Key(LoginScreenKeys.emailField),
                                label: LoginScreenStrings.emailLabel,
                                hintText: LoginScreenStrings.emailHint,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                              ),
                              CustomTextFieldWidget(
                                key: const Key(LoginScreenKeys.passwordField),
                                label: LoginScreenStrings.passwordLabel,
                                hintText: LoginScreenStrings.passwordHint,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                controller: _passwordController,
                              ),
                              BlocBuilder<
                                OrquestorAuthCubit,
                                OrquestorAuthState
                              >(
                                builder: (context, state) {
                                  final isLoading =
                                      state.loginState.status ==
                                      LoginStatus.loading;
                                  return ElevatedButton(
                                    key: const Key(
                                      LoginScreenKeys.continueButton,
                                    ),
                                    onPressed: isLoading ? null : _handleLogin,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            runAlignment: WrapAlignment.center,
                                            alignment: WrapAlignment.center,
                                            runSpacing: 8,
                                            spacing: 8,
                                            children: [
                                              Icon(
                                                Icons.arrow_right_alt_outlined,
                                              ),
                                              Text(
                                                LoginScreenStrings
                                                    .continueButton,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                  );
                                },
                              ),
                              Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                alignment: WrapAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/svg/locked.svg'),
                                  Text(LoginScreenStrings.forgotPassword),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: -10,
                        children: [
                          Icon(
                            Icons.person_2_outlined,
                            color: context.appColor.onPrimary,
                          ),
                          Text(
                            LoginScreenStrings.noAccount,
                            style: TextStyle(
                              color: context.appColor.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            key: const Key(LoginScreenKeys.registerLink),
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 4),
                              ),
                            ),
                            onPressed: () {
                              context.router.push(const RegisterRoute());
                            },
                            child: Text(
                              LoginScreenStrings.registerFree,
                              style: TextStyle(
                                color: context.appColor.onPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
