import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_field_widget.dart';
import 'package:partners/features/auth/validation/presentation/cubit/whatsapp/whatsapp_validation_cubit.dart';
import 'package:partners/features/auth/validation/presentation/notifier/whatsapp_from_notifier.dart';

class WhatsappValidationWidget extends StatefulWidget {
  const WhatsappValidationWidget({super.key});

  @override
  State<WhatsappValidationWidget> createState() =>
      _WhatsappValidationWidgetState();
}

class _WhatsappValidationWidgetState extends State<WhatsappValidationWidget> {
  late WhatsappFromNotifier _whatsappFromNotifier;

  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _whatsappFromNotifier = WhatsappFromNotifier(
      cubit: BlocProvider.of<WhatsappValidationCubit>(context),
    );

    _focusNodes.addAll(
      List.generate(_whatsappFromNotifier.otpLength, (index) => FocusNode()),
    );
  }

  @override
  void dispose() {
    _whatsappFromNotifier.dispose();
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
      listenable: _whatsappFromNotifier,
      builder: (context, child) {
        return BlocBuilder<WhatsappValidationCubit, WhatsappValidationState>(
          builder: (context, cubitState) {
            // Verificar si está en loading
            final isLoading =
                cubitState.status == WhatsappValidationStatus.loading ||
                cubitState.verifyStatus == WhatsappValidationStatus.loading;

            return BlocListener<
              WhatsappValidationCubit,
              WhatsappValidationState
            >(
              listener: (context, state) {
                if (state.status == WhatsappValidationStatus.success) {
                  _whatsappFromNotifier.goToNextStep();
                }
              },
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      if (_whatsappFromNotifier.currentStep ==
                          WhatsappSteps.verification) ...[
                        if (cubitState.debugOtp != null)
                          Text(
                            'Ingresa el código que verificación',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        Text(
                          'OTP de prueba: ${cubitState.debugOtp}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...List.generate(_whatsappFromNotifier.otpLength, (
                              index,
                            ) {
                              return SizedBox(
                                width: 50,
                                height: 50,
                                child: TextField(
                                  controller: _whatsappFromNotifier
                                      .otpControllers[index],
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
                      if (_whatsappFromNotifier.currentStep ==
                          WhatsappSteps.phone) ...[
                        ...List.generate(
                          _whatsappFromNotifier.whatsappFactory.length,
                          (index) {
                            final field =
                                _whatsappFromNotifier.whatsappFactory[index];
                            return RegisterFieldWidget(
                              label: field.label,
                              placeholder: field.placeholder,
                              controller: _whatsappFromNotifier.phoneController,
                              keyboardType: field.keyboardType,
                              maxLength: field.maxLength,
                              errorText: _whatsappFromNotifier.phoneError,
                              enabled: !isLoading,
                              onChanged: (value) {
                                _whatsappFromNotifier.setPhone(value);
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
                      onPressed:
                          _whatsappFromNotifier.isFormComplete && !isLoading
                          ? () {
                              if (_whatsappFromNotifier.currentStep ==
                                  WhatsappSteps.phone) {
                                context
                                    .read<WhatsappValidationCubit>()
                                    .sendWhatsappValidation(
                                      _whatsappFromNotifier.phone ?? '',
                                    );
                              } else if (_whatsappFromNotifier.currentStep ==
                                  WhatsappSteps.verification) {
                                context
                                    .read<WhatsappValidationCubit>()
                                    .verifyWhatsappOtp(
                                      _whatsappFromNotifier.otpControllers
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

  Widget _sufixLoadgingRuc(WhatsappValidationState state) {
    if (state.status == WhatsappValidationStatus.loading) {
      return CircularProgressIndicator(strokeWidth: 2);
    }
    return SizedBox.shrink();
  }
}
