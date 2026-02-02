import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_field_widget.dart';
import 'package:partners/features/auth/validation/presentation/cubit/email/email_validation_cubit.dart';
import 'package:partners/features/auth/validation/presentation/notifier/email_from_notifier.dart';

class EmailValidationWidget extends StatefulWidget {
  const EmailValidationWidget({super.key});

  @override
  State<EmailValidationWidget> createState() => _EmailValidationWidgetState();
}

class _EmailValidationWidgetState extends State<EmailValidationWidget> {
  late EmailFromNotifier _emailFromNotifier;

  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _emailFromNotifier = EmailFromNotifier(
      cubit: BlocProvider.of<EmailValidationCubit>(context),
    );

    _focusNodes.addAll(
      List.generate(_emailFromNotifier.otpLength, (index) => FocusNode()),
    );
  }

  @override
  void dispose() {
    _emailFromNotifier.dispose();
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _emailFromNotifier,
      builder: (context, child) {
        return BlocBuilder<EmailValidationCubit, EmailValidationState>(
          builder: (context, cubitState) {
            // Verificar si está en loading
            final isLoading =
                cubitState.status == EmailValidationStatus.loading ||
                cubitState.resendStatus == EmailValidationStatus.loading;

            return BlocListener<EmailValidationCubit, EmailValidationState>(
              listener: (context, state) {
                if (state.status == EmailValidationStatus.success) {
                  _emailFromNotifier.goToNextStep();
                }
              },
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      if (_emailFromNotifier.currentStep ==
                          EmailSteps.verification) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...List.generate(_emailFromNotifier.otpLength, (
                              index,
                            ) {
                              return SizedBox(
                                width: 50,
                                height: 50,
                                child: TextField(
                                  controller:
                                      _emailFromNotifier.otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  showCursor: false,
                                  enabled: !isLoading,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF051858),
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: '-',
                                    hintStyle: TextStyle(
                                      fontSize: 24,
                                      color: const Color(
                                        0xFF051858,
                                      ).withValues(alpha: 0.3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF0A2B7A),
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF0A2B7A),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF0A2B7A),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (value) =>
                                      _onOtpChanged(value, index),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                      if (_emailFromNotifier.currentStep ==
                          EmailSteps.email) ...[
                        ...List.generate(
                          _emailFromNotifier.emailFactory.length,
                          (index) {
                            final field =
                                _emailFromNotifier.emailFactory[index];
                            return RegisterFieldWidget(
                              label: field.label,
                              placeholder: field.placeholder,
                              controller: _emailFromNotifier.emailController,
                              keyboardType: field.keyboardType,
                              maxLength: field.maxLength,
                              errorText: _emailFromNotifier.emailError,
                              enabled: !isLoading,
                              onChanged: (value) {
                                _emailFromNotifier.setEmail(value);
                              },
                              suffix: _sufixLoadgingRuc(cubitState),
                            );
                          },
                        ),
                      ],
                      SizedBox(height: 100),
                    ],
                  ),
                  // Botón con estado de loading
                  // El botón solo se activa si el formulario está completo Y no está en loading
                  Positioned(
                    bottom: 30,
                    right: 0,
                    left: 0,
                    child: ElevatedButton(
                      onPressed: _emailFromNotifier.isFormComplete && !isLoading
                          ? () {
                              if (_emailFromNotifier.currentStep ==
                                  EmailSteps.email) {
                                context
                                    .read<EmailValidationCubit>()
                                    .sendEmailValidation(
                                      _emailFromNotifier.email ?? '',
                                    );
                              } else if (_emailFromNotifier.currentStep ==
                                  EmailSteps.verification) {
                                context
                                    .read<EmailValidationCubit>()
                                    .resendEmailCode(
                                      _emailFromNotifier.otpControllers
                                          .map((controller) => controller.text)
                                          .join(),
                                    );
                              }
                            }
                          : null,
                      child: isLoading
                          ? SizedBox(
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
                              children: [
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _sufixLoadgingRuc(EmailValidationState state) {
    if (state.status == EmailValidationStatus.loading) {
      return CircularProgressIndicator(strokeWidth: 2);
    }
    return SizedBox.shrink();
  }
}
