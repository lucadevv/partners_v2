import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:auto_route/auto_route.dart' as auto_route;
import 'package:partners/features/auth/register/domain/entities/tipo_comercio.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';
import 'package:partners/features/auth/register/domain/entities/register_entity.dart';
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
import 'package:partners/core/utils/validations/ruc_validator.dart';

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

    // Configurar callback para validación automática del documento principal
    _formNotifier.onDocumentValidated = (numero, tipoDocumento, tipoComercio) {
      if (tipoComercio != null) {
        // El número ya viene extraído del RUC completo
        // Para RUC 10 y 15, usar DNI por defecto
        // Para RUC 20, no se requiere tipo de documento para el RUC del negocio
        final tipoDoc =
            (tipoComercio == TipoComercio.ruc10 ||
                tipoComercio == TipoComercio.ruc15)
            ? (tipoDocumento ?? TipoDocumento.dni)
            : null;
        final entity = RegisterEntity(
          tipoComercio: tipoComercio,
          tipoDocumento: tipoDoc,
          numeroDocumento: numero, // Este ya es el documento extraído del RUC
        );
        context.read<RegisterCubit>().validateComerce(entity: entity);
      }
    };

    // Configurar callback para validación automática del documento del representante
    _formNotifier.onRepresentanteDocumentValidated = (numero, tipoDocumento) {
      if (tipoDocumento != null && _selectedRuc == TipoRuc.ruc20) {
        final entity = RegisterEntity(
          tipoComercio: _mapRucToTipoComercio(_selectedRuc!),
          tipoDocumento: _formNotifier.tipoDocumento,
          numeroDocumento: _formNotifier.numeroDocumentoController.text.trim(),
          tipoDocumentoRepresentante: tipoDocumento,
          numeroDocumentoRepresentante: numero,
        );
        context.read<RegisterCubit>().validateComerce(entity: entity);
      }
    };
  }

  @override
  void dispose() {
    _formNotifier.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final registerState = context.read<RegisterCubit>().state;

    // Si el estado es success y el formulario está completo, navegar directamente
    if (registerState.status == RegisterStatus.success &&
        _formNotifier.isFormComplete()) {
      // Navegar a ValidationScreen
      if (!mounted) return;
      context.router.push(const ValidationRoute());
      return;
    }

    // Si no está en success, validar el formulario primero
    if (!_formNotifier.validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    // Construir la entidad y validar
    final rucCompleto = _formNotifier.numeroDocumentoController.text.trim();
    final tipoComercio = _formNotifier.tipoComercio;

    // Extraer el documento del RUC completo
    String? numeroDocumento;
    if (tipoComercio != null) {
      numeroDocumento = RucValidator.extractDocumento(
        rucCompleto,
        tipoComercio,
      );
    }

    final entity = RegisterEntity(
      tipoComercio: tipoComercio,
      // Para RUC 10 y 15, usar DNI por defecto
      // Para RUC 20, no se requiere tipo de documento para el RUC del negocio
      tipoDocumento:
          _selectedRuc == TipoRuc.ruc10 || _selectedRuc == TipoRuc.ruc15
          ? TipoDocumento.dni
          : null,
      numeroDocumento: numeroDocumento,
      // Campos adicionales para RUC 20
      tipoDocumentoRepresentante: _selectedRuc == TipoRuc.ruc20
          ? _formNotifier.tipoDocumentoRepresentante
          : null,
      numeroDocumentoRepresentante: _selectedRuc == TipoRuc.ruc20
          ? _formNotifier.numeroDocumentoRepresentanteController.text.trim()
          : null,
    );

    // Validar el comercio
    context.read<RegisterCubit>().validateComerce(entity: entity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterHeaderWidget(),
      body: BlocListener<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) {
          // Solo escuchar cuando el estado cambia a success
          return current.status == RegisterStatus.success &&
              previous.status != RegisterStatus.success;
        },
        listener: (context, state) {
          if (state.responseEntity != null) {
            // Para RUC 20: habilitar razón social y nombres del representante
            if (_selectedRuc == TipoRuc.ruc20) {
              if (state.responseEntity!.razonSocial != null &&
                  state.responseEntity!.razonSocial!.isNotEmpty) {
                _formNotifier.enableRazonSocial(
                  state.responseEntity!.razonSocial ?? '',
                );
              }
              // Si hay nombres y apellidos, es del representante
              if (state.responseEntity!.nombres != null &&
                  state.responseEntity!.nombres!.isNotEmpty) {
                _formNotifier.enableNombresApellidos(
                  state.responseEntity!.nombres ?? '',
                  state.responseEntity!.apellidos ?? '',
                );
              }
            } else {
              // Para RUC 10 y 15: habilitar nombres y apellidos
              _formNotifier.enableNombresApellidos(
                state.responseEntity!.nombres ?? '',
                state.responseEntity!.apellidos ?? '',
              );
            }
          }
        },
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
                                  // Para RUC 10 y 15, establecer DNI por defecto
                                  if (tipo == TipoRuc.ruc10 ||
                                      tipo == TipoRuc.ruc15) {
                                    _formNotifier.setTipoDocumento(
                                      TipoDocumento.dni,
                                    );
                                  } else {
                                    _formNotifier.setTipoDocumento(null);
                                  }
                                },
                              ),
                              // Campo de RUC del negocio
                              RegisterFieldWidget(
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
                                suffixIcon:
                                    _formNotifier.numeroDocumentoError != null
                                    ? Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 20,
                                      )
                                    : null,
                              ),
                              // Mostrar error si existe
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

                              // Campos condicionales según tipo de RUC
                              if (_selectedRuc == TipoRuc.ruc10 ||
                                  _selectedRuc == TipoRuc.ruc15) ...[
                                // RUC 10 y 15: Nombres del registrante
                                RegisterFieldWidget(
                                  label: 'Nombres del registrante',
                                  placeholder:
                                      'Su nombre completo aparecerá aquí',
                                  value: _formNotifier.nombresController.text,
                                  enabled: false,
                                ),
                              ] else if (_selectedRuc == TipoRuc.ruc20) ...[
                                // RUC 20: Razón social
                                RegisterFieldWidget(
                                  label: 'Nombre de la empresa',
                                  placeholder: 'Su razón social aparecerá aquí',
                                  value:
                                      _formNotifier.razonSocialController.text,
                                  enabled: false,
                                ),
                                // RUC 20: Tipo de documento del representante
                                TipoDocumentoSelectorWidget(
                                  selectedTipo:
                                      _formNotifier.tipoDocumentoRepresentante,
                                  onTipoSelected: (tipo) {
                                    _formNotifier.setTipoDocumentoRepresentante(
                                      tipo,
                                    );
                                  },
                                ),
                                // RUC 20: Nro. de documento del representante
                                RegisterFieldWidget(
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
                                  suffixIcon:
                                      _formNotifier
                                              .numeroDocumentoRepresentanteError !=
                                          null
                                      ? Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 20,
                                        )
                                      : null,
                                ),
                                // Mostrar error si existe
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
                                // RUC 20: Nombres del registrante
                                RegisterFieldWidget(
                                  label: 'Nombres del registrante',
                                  placeholder:
                                      'Su nombre completo aparecerá aquí',
                                  value: _formNotifier.nombresController.text,
                                  enabled: false,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // El botón se actualiza cuando cambian los campos (gracias al ListenableBuilder)
                  // y cuando cambia el estado del cubit (gracias al BlocBuilder)
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      // Habilitar botón solo si:
                      // 1. El formulario está completo
                      // 2. El estado es success (ya se validó y trajo los datos)
                      // 3. No está cargando
                      final isFormComplete = _formNotifier.isFormComplete();
                      final isSuccess = state.status == RegisterStatus.success;
                      final isLoading = state.status == RegisterStatus.loading;

                      return ContinueButtonWidget(
                        onPressed: (isFormComplete && isSuccess && !isLoading)
                            ? _handleContinue
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
