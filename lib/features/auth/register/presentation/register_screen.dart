import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_comercio.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/features/auth/register/presentation/notifier/register_form_notifier.dart';
import 'package:partners/features/auth/register/presentation/widgets/continue_button_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/free_banner_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_header_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_title_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/ruc_selector_widget.dart'
    show RucSelectorWidget, TipoRuc;
import 'package:partners/features/auth/register/presentation/widgets/register_field_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/tipo_documento_selector_widget.dart';

TipoComercio _mapRucToTipoComercio(TipoRuc ruc) {
  return switch (ruc) {
    TipoRuc.ruc10 => TipoComercio.ruc10,
    TipoRuc.ruc15 => TipoComercio.ruc15,
    TipoRuc.ruc20 => TipoComercio.ruc20,
  };
}

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterFormNotifier _formNotifier;
  TipoRuc? _selectedRuc;

  @override
  void initState() {
    super.initState();
    _formNotifier = RegisterFormNotifier();
    _formNotifier.initializeDocumentListeners();

    _formNotifier.onValidateCommerce = (entity) {
      context.read<RegisterCubit>().validateComerce(entity: entity);
    };

    _formNotifier.onValidateDocument = (type, number) {
      if (_selectedRuc == TipoRuc.ruc20) {
        context.read<RegisterCubit>().validateDocument(
          type: type,
          number: number,
        );
      }
    };
  }

  @override
  void dispose() {
    _formNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterHeaderWidget(),
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {},
        child: ListenableBuilder(
          listenable: _formNotifier,
          builder: (context, _) {
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
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            spacing: 24,
                            children: [
                              Text(
                                "Complete la información ahora",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF051858),
                                ),
                              ),
                              RucSelectorWidget(
                                selectedTipo: _selectedRuc,
                                onTipoSelected: (tipo) {
                                  setState(() {
                                    _selectedRuc = tipo;
                                  });
                                  _formNotifier.setTipoComercio(
                                    _mapRucToTipoComercio(tipo),
                                  );
                                },
                              ),

                              BlocBuilder<RegisterCubit, RegisterState>(
                                builder: (context, state) {
                                  Widget? suffixIcon;

                                  // Mostrar error si existe
                                  if (_formNotifier.numeroDocumentoError !=
                                      null) {
                                    suffixIcon = Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 20,
                                    );
                                  }
                                  // Mostrar loading cuando se está validando el RUC
                                  else if (state.status ==
                                      RegisterStatus.loading) {
                                    suffixIcon = SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Theme.of(context).primaryColor,
                                            ),
                                      ),
                                    );
                                  }

                                  return RegisterFieldWidget(
                                    label: _selectedRuc == TipoRuc.ruc20
                                        ? 'RUC del negocio'
                                        : 'RUC del negocio',
                                    placeholder: _selectedRuc == TipoRuc.ruc10
                                        ? 'Ingrese el RUC del negocio (11 dígitos)'
                                        : _selectedRuc == TipoRuc.ruc15
                                        ? 'Ingrese el RUC del negocio (12-13 dígitos)'
                                        : 'Ingrese el RUC del negocio (12-13 dígitos)',
                                    controller:
                                        _formNotifier.numeroDocumentoController,
                                    keyboardType: TextInputType.number,
                                    maxLength: _selectedRuc == TipoRuc.ruc10
                                        ? 11
                                        : (_selectedRuc == TipoRuc.ruc15 ||
                                              _selectedRuc == TipoRuc.ruc20)
                                        ? 13
                                        : null,
                                    suffixIcon: suffixIcon,
                                  );
                                },
                              ),

                              if (_formNotifier.numeroDocumentoError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _formNotifier.numeroDocumentoError!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              if (_selectedRuc == TipoRuc.ruc10 ||
                                  _selectedRuc == TipoRuc.ruc15) ...[
                                BlocBuilder<RegisterCubit, RegisterState>(
                                  builder: (context, state) {
                                    final isSuccess =
                                        state.status == RegisterStatus.success;
                                    final hasValue =
                                        _formNotifier
                                            .nombresController
                                            .text
                                            .isNotEmpty ||
                                        _formNotifier
                                            .apellidosController
                                            .text
                                            .isNotEmpty;

                                    return RegisterFieldWidget(
                                      label: 'Nombres del registrante',
                                      placeholder: isSuccess && hasValue
                                          ? null
                                          : 'Su nombre completo aparecerá aquí',
                                      value: isSuccess && hasValue
                                          ? '${_formNotifier.nombresController.text} ${_formNotifier.apellidosController.text}'
                                                .trim()
                                          : '',
                                      enabled: false,
                                    );
                                  },
                                ),
                              ] else if (_selectedRuc == TipoRuc.ruc20) ...[
                                RegisterFieldWidget(
                                  label: 'Nombre de la empresa',
                                  placeholder: 'Su razón social aparecerá aquí',
                                  value:
                                      _formNotifier.razonSocialController.text,
                                  enabled: false,
                                ),

                                TipoDocumentoSelectorWidget(
                                  selectedTipo:
                                      _formNotifier.tipoDocumentoRepresentante,
                                  onTipoSelected: (tipo) {
                                    _formNotifier.setTipoDocumentoRepresentante(
                                      tipo,
                                    );
                                  },
                                ),

                                BlocBuilder<RegisterCubit, RegisterState>(
                                  builder: (context, state) {
                                    Widget? suffixIcon;

                                    // Mostrar error si existe
                                    if (_formNotifier
                                            .numeroDocumentoRepresentanteError !=
                                        null) {
                                      suffixIcon = Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 20,
                                      );
                                    }
                                    // Mostrar loading cuando se está validando el documento
                                    else if (state.documentStatus ==
                                        DocumentStatus.loading) {
                                      suffixIcon = SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor,
                                              ),
                                        ),
                                      );
                                    }

                                    return RegisterFieldWidget(
                                      label: 'Nro. de documento',
                                      placeholder:
                                          _formNotifier
                                                  .tipoDocumentoRepresentante ==
                                              null
                                          ? 'Seleccione tipo de documento primero'
                                          : (_formNotifier
                                                        .tipoDocumentoRepresentante ==
                                                    TipoDocumento.dni
                                                ? 'Ingrese DNI del representante (8 dígitos)'
                                                : 'Ingrese CE del representante (9 dígitos)'),
                                      controller: _formNotifier
                                          .numeroDocumentoRepresentanteController,
                                      keyboardType: TextInputType.number,
                                      maxLength:
                                          _formNotifier
                                                  .tipoDocumentoRepresentante ==
                                              TipoDocumento.dni
                                          ? 8
                                          : (_formNotifier
                                                        .tipoDocumentoRepresentante ==
                                                    TipoDocumento.ce
                                                ? 9
                                                : null),
                                      suffixIcon: suffixIcon,
                                    );
                                  },
                                ),

                                if (_formNotifier
                                        .numeroDocumentoRepresentanteError !=
                                    null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      _formNotifier
                                          .numeroDocumentoRepresentanteError!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),

                                BlocBuilder<RegisterCubit, RegisterState>(
                                  builder: (context, state) {
                                    final isSuccess =
                                        state.documentStatus ==
                                        DocumentStatus.success;
                                    final hasValue =
                                        _formNotifier
                                            .nombresController
                                            .text
                                            .isNotEmpty ||
                                        _formNotifier
                                            .apellidosController
                                            .text
                                            .isNotEmpty;

                                    return RegisterFieldWidget(
                                      label: 'Nombres del registrante',
                                      placeholder: isSuccess && hasValue
                                          ? null
                                          : 'Su nombre completo aparecerá aquí',
                                      value: isSuccess && hasValue
                                          ? '${_formNotifier.nombresController.text} ${_formNotifier.apellidosController.text}'
                                                .trim()
                                          : '',
                                      enabled: false,
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      final isFormComplete = _formNotifier.isFormComplete();
                      final isSuccess = state.status == RegisterStatus.success;
                      final isLoading = state.status == RegisterStatus.loading;

                      return ContinueButtonWidget(
                        onPressed: (isFormComplete && isSuccess && !isLoading)
                            ? () {}
                            : null,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
