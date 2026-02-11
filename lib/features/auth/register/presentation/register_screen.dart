import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/keyboard_type_converter.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_state.dart';
import 'package:partners/features/auth/register/presentation/notifier/register_form_notifier.dart';
import 'package:partners/features/auth/register/presentation/widgets/continue_button_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/free_banner_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_field_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_header_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_title_widget.dart';
import 'package:partners/features/auth/register/presentation/register_screen_keys.dart';
import 'package:partners/features/auth/register/presentation/register_screen_strings.dart';
import 'package:partners/features/auth/register/presentation/widgets/ruc_selector_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/tipo_documento_selector_widget.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterFormNotifier _formNotifier;
  late RegisterCubit _cubit;
  @override
  void initState() {
    _cubit = context.read<RegisterCubit>();
    _formNotifier = RegisterFormNotifier(cubit: _cubit);
    super.initState();
  }

  @override
  void dispose() {
    _formNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrquestorAuthCubit, OrquestorAuthState>(
      listener: (context, stateOrquesto) {
        if (stateOrquesto.effect is NavigationValidateEffect) {
          context.read<OrquestorAuthCubit>().reset();
          context.router.push(
            ValidationRoute(rucType: _formNotifier.selectedRuc),
          );
        }
        if (stateOrquesto.effect is NavigationBussinesEffect) {
          context.read<OrquestorAuthCubit>().reset();
          context.router.push(
            ValidationRoute(rucType: _formNotifier.selectedRuc),
          );
        }
      },
      child: Scaffold(
        appBar: RegisterHeaderWidget(),
        body: BlocConsumer<RegisterCubit, RegisterStateX>(
          listenWhen: (previous, current) =>
              previous.sendRucStatus != current.sendRucStatus ||
              previous.sendDocStatus != current.sendDocStatus ||
              previous.sendStartStatus != current.sendStartStatus,
          listener: (context, state) {
            if (state.sendRucStatus == RegisterStatus.success) {
              _formNotifier.updateFromRucResponse(state.rucData.socialReason);
            }
            if (state.sendDocStatus == RegisterStatus.success) {
              _formNotifier.updateFromDocResponse(state.docData.getFullName);
            }
            final message = state.errorMessage?.trim();
            final showMessage = message != null && message.isNotEmpty;
            final displayMessage =
                showMessage ? message : RegisterScreenStrings.defaultErrorSnackBar;
            if (state.sendRucStatus == RegisterStatus.failure) {
              _formNotifier.setRucErrorFromBackend(displayMessage);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(displayMessage)),
              );
            }
            if (state.sendDocStatus == RegisterStatus.failure) {
              _formNotifier.setDocErrorFromBackend(displayMessage);
              if (state.sendRucStatus != RegisterStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(displayMessage)),
                );
              }
            }
            if (state.sendStartStatus == RegisterStatus.failure &&
                state.sendRucStatus != RegisterStatus.failure &&
                state.sendDocStatus != RegisterStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(displayMessage)),
              );
            }
          },
          builder: (context, state) {
            return ListenableBuilder(
              listenable: _formNotifier,
              builder: (BuildContext context, Widget? child) {
                return SizedBox.expand(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          spacing: 24,
                          children: [
                            RegisterTitleWidget(),
                            FreeBannerWidget(),
                            8.spaceh,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                spacing: 24,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: RucSelectorWidget(
                                          formNotifier: _formNotifier,
                                          type: RucType.ruc10,
                                          label: 'RUC 10',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: RucSelectorWidget(
                                          formNotifier: _formNotifier,
                                          type: RucType.ruc15,
                                          label: 'RUC 15',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: RucSelectorWidget(
                                          formNotifier: _formNotifier,
                                          type: RucType.ruc20,
                                          label: 'RUC 20',
                                        ),
                                      ),
                                    ],
                                  ),
                                  RegisterFieldWidget(
                                    key: const Key(RegisterScreenKeys.rucField),
                                    label: _formNotifier.rucConfig.label,
                                    placeholder:
                                        _formNotifier.rucConfig.placeholder,
                                    controller: _formNotifier.rucController,
                                    keyboardType: KeyboardTypeConverter.toTextInputType(
                                        _formNotifier.rucConfig.keyboardType),
                                    maxLength:
                                        _formNotifier.rucConfig.maxLength,
                                    errorText: _formNotifier.rucError,
                                    onChanged: (value) {
                                      _formNotifier.validateRuc(value);
                                    },
                                    suffix: _sufixLoadgingRuc(state),
                                  ),
                                  RegisterFieldWidget(
                                    label: _formNotifier.nameConfig.label,
                                    placeholder:
                                        _formNotifier.nameConfig.placeholder,
                                    controller:
                                        _formNotifier.nameSocialRazonController,
                                    keyboardType: KeyboardTypeConverter.toTextInputType(
                                        _formNotifier.nameConfig.keyboardType),
                                    maxLength:
                                        _formNotifier.nameConfig.maxLength,
                                    enabled: _formNotifier.nameConfig.enabled,
                                    readOnly: _formNotifier.nameConfig.readOnly,
                                  ),

                                  if (_formNotifier
                                      .rucConfig
                                      .showTypeDocument) ...[
                                    DocumentTypeSelectorWidget(
                                      selectType: _formNotifier.selectedDocType,
                                      onTypeSelected: (DocumentType p1) {
                                        _formNotifier.changeDocType(p1);
                                      },
                                    ),
                                    RegisterFieldWidget(
                                      key: const Key(RegisterScreenKeys.docField),
                                      label: _formNotifier.repConfig.label,
                                      placeholder:
                                          _formNotifier.repConfig.placeholder,
                                      controller:
                                          _formNotifier.docRepController,
                                      keyboardType: KeyboardTypeConverter.toTextInputType(
                                          _formNotifier.repConfig.keyboardType),
                                      maxLength:
                                          _formNotifier.repConfig.maxLength,
                                      errorText: _formNotifier.docError,
                                      suffix: _sufixLoadgingDoc(state),
                                      onChanged: (value) {
                                        _formNotifier.validateRepDoc(value);
                                      },
                                    ),
                                    RegisterFieldWidget(
                                      label: _formNotifier.repNameConfig.label,
                                      placeholder: _formNotifier
                                          .repNameConfig
                                          .placeholder,
                                      controller:
                                          _formNotifier.nameRepContoller,
                                      keyboardType: KeyboardTypeConverter.toTextInputType(
                                          _formNotifier.repNameConfig.keyboardType),
                                      maxLength:
                                          _formNotifier.repNameConfig.maxLength,
                                      enabled:
                                          _formNotifier.repNameConfig.enabled,
                                      readOnly:
                                          _formNotifier.repNameConfig.readOnly,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 36,
                        left: 24,
                        right: 24,
                        child: ContinueButtonWidget(
                          key: const Key(RegisterScreenKeys.continueButton),
                          onPressed: _formNotifier.isFormComplete
                              ? () async {
                                  await context
                                      .read<OrquestorAuthCubit>()
                                      .navigationStartValidationPage(
                                        _formNotifier.selectedRuc,
                                      );
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _sufixLoadgingRuc(RegisterStateX state) {
    if (state.sendRucStatus == RegisterStatus.loading) {
      return CircularProgressIndicator(strokeWidth: 2);
    }
    return SizedBox.shrink();
  }

  Widget _sufixLoadgingDoc(RegisterStateX state) {
    if (state.sendDocStatus == RegisterStatus.loading) {
      return CircularProgressIndicator(strokeWidth: 2);
    }
    return SizedBox.shrink();
  }
}
