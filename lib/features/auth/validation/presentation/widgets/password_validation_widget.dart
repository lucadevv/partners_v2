import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_field_widget.dart';
import 'package:partners/features/auth/validation/presentation/cubit/password/password_validation_cubit.dart';
import 'package:partners/features/auth/validation/presentation/notifier/password_from_notifier.dart';

class PasswordValidationWidget extends StatefulWidget {
  const PasswordValidationWidget({super.key});

  @override
  State<PasswordValidationWidget> createState() =>
      _PasswordValidationWidgetState();
}

class _PasswordValidationWidgetState extends State<PasswordValidationWidget> {
  late PasswordFromNotifier _passwordFromNotifier;

  @override
  void initState() {
    super.initState();
    _passwordFromNotifier = PasswordFromNotifier(
      cubit: BlocProvider.of<PasswordValidationCubit>(context),
    );
  }

  @override
  void dispose() {
    _passwordFromNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _passwordFromNotifier,
      builder: (context, child) {
        final router = context.router;
        return BlocConsumer<PasswordValidationCubit, PasswordValidationState>(
          listener: (context, state) {
            if (state.status == PasswordValidationStatus.success) {
              router.pop(true);
              router.replaceAll([DashboardRoute()]);
            } else if (state.status == PasswordValidationStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Error al completar la contraseña',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, cubitState) {
            final isLoading =
                cubitState.status == PasswordValidationStatus.loading;

            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  children: [
                    if (_passwordFromNotifier.currentStep ==
                        PasswordSteps.createPassword) ...[
                      ...List.generate(
                        _passwordFromNotifier.passwordFactory.length,
                        (index) {
                          final field =
                              _passwordFromNotifier.passwordFactory[index];
                          return RegisterFieldWidget(
                            label: field.label,
                            placeholder: field.placeholder,
                            controller:
                                _passwordFromNotifier.passwordController,
                            keyboardType: field.keyboardType,
                            maxLength: field.maxLength,
                            errorText: _passwordFromNotifier.passwordError,
                            enabled: !isLoading,
                            obscureText: true,
                            onChanged: (value) {
                              _passwordFromNotifier.setPassword(value);
                            },
                          );
                        },
                      ),
                    ],
                    if (_passwordFromNotifier.currentStep ==
                        PasswordSteps.confirmPassword) ...[
                      ...List.generate(
                        _passwordFromNotifier.passwordFactory.length,
                        (index) {
                          final field =
                              _passwordFromNotifier.passwordFactory[index];
                          return RegisterFieldWidget(
                            label: field.label,
                            placeholder: field.placeholder,
                            controller: index == 0
                                ? _passwordFromNotifier.passwordController
                                : _passwordFromNotifier
                                      .passwordConfirmationController,
                            keyboardType: field.keyboardType,
                            maxLength: field.maxLength,
                            errorText: index == 0
                                ? _passwordFromNotifier.passwordError
                                : _passwordFromNotifier
                                      .passwordConfirmationError,
                            enabled: !isLoading,
                            obscureText: true,
                            onChanged: (value) {
                              if (index == 0) {
                                _passwordFromNotifier.setPassword(value);
                              } else {
                                _passwordFromNotifier.setPasswordConfirmation(
                                  value,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
                Positioned(
                  bottom: 30,
                  right: 0,
                  left: 0,
                  child: ElevatedButton(
                    onPressed:
                        _passwordFromNotifier.isFormComplete && !isLoading
                        ? () {
                            if (_passwordFromNotifier.currentStep ==
                                PasswordSteps.createPassword) {
                              _passwordFromNotifier.goToNextStep();
                            } else if (_passwordFromNotifier.currentStep ==
                                PasswordSteps.confirmPassword) {
                              context
                                  .read<PasswordValidationCubit>()
                                  .completePassword(
                                    password:
                                        _passwordFromNotifier.password ?? '',
                                    passwordConfirmation:
                                        _passwordFromNotifier
                                            .passwordConfirmation ??
                                        '',
                                  );
                            }
                          }
                        : null,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 12,
                            children: const [
                              Icon(Icons.arrow_forward, size: 20),
                              Text(
                                "Continuar",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
