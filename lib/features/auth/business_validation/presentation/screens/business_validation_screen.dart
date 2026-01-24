import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';
import 'package:partners/core/managers/auth/storage/token_manager.dart';
import 'package:partners/core/routes/app_routes.gr.dart';
import 'package:partners/features/auth/business_validation/presentation/notifier/business_validation_form_notifier.dart';
import 'package:partners/features/auth/business_validation/presentation/widgets/business_validation_step_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_header_widget.dart';
import 'package:partners/features/auth/otp/presentation/widgets/otp_bottom_sheet.dart';
import 'package:partners/features/auth/validation/presentation/widgets/validation_input_bottom_sheet.dart';
import 'package:partners/features/auth/validation/presentation/widgets/validation_loading_dots.dart';
import 'package:partners/main.dart';

@RoutePage()
class BusinessValidationScreen extends StatefulWidget {
  const BusinessValidationScreen({super.key});

  @override
  State<BusinessValidationScreen> createState() =>
      _BusinessValidationScreenState();
}

class _BusinessValidationScreenState extends State<BusinessValidationScreen> {
  late BusinessValidationFormNotifier _notifier;
  final TokenManager _tokenManager = getIt<TokenManager>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _notifier = BusinessValidationFormNotifier();
    _notifier.addListener(_handleValidationChange);
  }

  @override
  void dispose() {
    _notifier.removeListener(_handleValidationChange);
    _notifier.dispose();
    super.dispose();
  }

  void _handleValidationChange() {
    // Cuando todos los pasos estén completos y esté en estado "completing"
    if (_notifier.allStepsCompleted && _notifier.isCompleting) {
      // Esperar un poco para mostrar la animación de completado
      Future.delayed(const Duration(seconds: 2), () async {
        if (!mounted) return;

        // Actualizar el flag isCompleteData
        await _tokenManager.setIsCompleteData(true);

        // Navegar al dashboard (el guard ya no redirigirá a validación)
        if (mounted) {
          context.router.replaceAll([const DashboardRoute()]);
        }
      });
    }
  }

  void _handleStepTap(BusinessValidationStep step) {
    // Solo permitir interactuar con el paso activo
    if (_notifier.currentStep != step) {
      return;
    }

    switch (step) {
      case BusinessValidationStep.email:
        _showEmailBottomSheet();
        break;
      case BusinessValidationStep.whatsapp:
        _showWhatsAppBottomSheet();
        break;
      case BusinessValidationStep.business:
        // El step de negocio se completa al subir el archivo desde el bottom sheet
        // No necesita acción aquí, el bottom sheet ya está visible
        break;
      case BusinessValidationStep.identity:
        _showDocumentScan();
        break;
      case BusinessValidationStep.password:
        _showPasswordBottomSheet();
        break;
    }
  }

  void _showEmailBottomSheet() async {
    if (!mounted) return;

    // Paso 1: Capturar email
    final email = await ValidationInputBottomSheet.show(
      context: context,
      title: 'Validando su email',
      label: 'Email',
      placeholder: 'Ingrese su correo electrónico',
      keyboardType: TextInputType.emailAddress,
      backgroundWidget: _buildStepsView(),
      isEmail: true,
    );

    if (!mounted || email == null || email.isEmpty) return;

    // Paso 2: Validar con OTP
    final code = await OtpBottomSheet.show(
      context: context,
      title: 'Validando su email',
      backgroundWidget: _buildStepsView(),
    );

    if (!mounted) return;

    if (code != null && code.length == 5) {
      // TODO: Validar código OTP con el cubit
      _notifier.completeCurrentStep();
    }
  }

  void _showWhatsAppBottomSheet() async {
    if (!mounted) return;

    // Paso 1: Capturar número de WhatsApp
    final whatsapp = await ValidationInputBottomSheet.show(
      context: context,
      title: 'Validando su celular con WhatsApp',
      label: 'Celular vinculado a WhatsApp',
      placeholder: 'Ingrese su número de celular (9 dígitos)',
      keyboardType: TextInputType.phone,
      backgroundWidget: _buildStepsView(),
      isPhone: true,
    );

    if (!mounted || whatsapp == null || whatsapp.isEmpty) return;

    // Paso 2: Validar con OTP
    final code = await OtpBottomSheet.show(
      context: context,
      title: 'Validando su WhatsApp',
      backgroundWidget: _buildStepsView(),
    );

    if (!mounted) return;

    if (code != null && code.length == 5) {
      // TODO: Validar código OTP con el cubit
      _notifier.completeCurrentStep();
    }
  }

  void _showPasswordBottomSheet() async {
    if (!mounted) return;

    // Capturar password (sin OTP)
    final password = await ValidationInputBottomSheet.show(
      context: context,
      title: 'Creando su contraseña segura',
      label: 'Contraseña',
      placeholder: 'Ingrese su contraseña',
      obscureText: true,
      backgroundWidget: _buildStepsView(),
    );

    if (!mounted) return;

    if (password != null && password.isNotEmpty) {
      // TODO: Guardar password con el cubit
      _notifier.completeCurrentStep();
    }
  }

  void _showDocumentScan() async {
    // Navegar a la pantalla de escaneo de documento
    final result = await context.router.push(const DocumentScanRoute());

    // Solo completar el step si el documento fue validado exitosamente
    if (result == true) {
      _notifier.completeCurrentStep();
    }
  }

  Future<void> _pickAndUploadFile() async {
    try {
      setState(() => _isLoading = true);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSizeInBytes = await file.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        // Validar tamaño máximo 5MB
        if (fileSizeInMB > 5) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El archivo debe ser menor a 5MB'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
          return;
        }

        setState(() {
          _isLoading = false;
        });

        // Aquí se enviaría el archivo al backend si es necesario
        // Completar el step de negocio
        _notifier.completeCurrentStep();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar archivo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterHeaderWidget(
        onBackPressed: () {
          if (_notifier.currentStep != BusinessValidationStep.email) {
            _notifier.goToPreviousStep();
          } else {
            context.router.maybePop();
          }
        },
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _notifier,
          builder: (context, _) {
            if (_notifier.isCompleting) {
              return _buildCompletingView();
            }

            return Stack(
              children: [
                _buildStepsView(),

                // Mostrar bottom sheet solo cuando el paso de negocio está activo
                if (_notifier.currentStep == BusinessValidationStep.business)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildBottomSheet(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 58, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título
          Text(
            'Validando su negocio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF051858),
              fontFamily: 'Gilroy',
              letterSpacing: -0.54,
              height: 1.21,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 42),

          // Instrucción
          Text(
            'Tiene que subir la FICHA RUC que se descarga gratis en al SUNAT',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontFamily: 'Figtree',
              height: 1.83,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 52),

          // Botón Subir ficha RUC PDF
          _buildUploadButton(),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _pickAndUploadFile,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF66cfff),
        disabledBackgroundColor: const Color(0xFFD1D5DB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF051858)),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: const Color(0xFF051858),
                  size: 21,
                ),
                const SizedBox(width: 20),
                Text(
                  'Subir ficha RUC PDF',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF051858),
                    fontFamily: 'Figtree',
                    height: 1.22,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStepsView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          24.spaceh,
          Text(
            'Validemos tu cuenta en pocos pasos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF051858),
            ),
          ),
          34.spaceh,
          ListenableBuilder(
            listenable: _notifier,
            builder: (context, _) {
              return Column(
                children: [
                  BusinessValidationStepWidget(
                    text: _notifier.getStepText(
                      BusinessValidationStep.email,
                      _notifier.stepStatuses[BusinessValidationStep.email]!,
                    ),
                    status:
                        _notifier.stepStatuses[BusinessValidationStep.email]!,
                    onTap: () => _handleStepTap(BusinessValidationStep.email),
                  ),
                  16.spaceh,
                  BusinessValidationStepWidget(
                    text: _notifier.getStepText(
                      BusinessValidationStep.whatsapp,
                      _notifier.stepStatuses[BusinessValidationStep.whatsapp]!,
                    ),
                    status: _notifier
                        .stepStatuses[BusinessValidationStep.whatsapp]!,
                    onTap: () =>
                        _handleStepTap(BusinessValidationStep.whatsapp),
                  ),
                  16.spaceh,
                  BusinessValidationStepWidget(
                    text: _notifier.getStepText(
                      BusinessValidationStep.business,
                      _notifier.stepStatuses[BusinessValidationStep.business]!,
                    ),
                    status: _notifier
                        .stepStatuses[BusinessValidationStep.business]!,
                    onTap: () =>
                        _handleStepTap(BusinessValidationStep.business),
                  ),
                  16.spaceh,
                  BusinessValidationStepWidget(
                    text: _notifier.getStepText(
                      BusinessValidationStep.identity,
                      _notifier.stepStatuses[BusinessValidationStep.identity]!,
                    ),
                    status: _notifier
                        .stepStatuses[BusinessValidationStep.identity]!,
                    onTap: () =>
                        _handleStepTap(BusinessValidationStep.identity),
                  ),
                  16.spaceh,
                  BusinessValidationStepWidget(
                    text: _notifier.getStepText(
                      BusinessValidationStep.password,
                      _notifier.stepStatuses[BusinessValidationStep.password]!,
                    ),
                    status: _notifier
                        .stepStatuses[BusinessValidationStep.password]!,
                    onTap: () =>
                        _handleStepTap(BusinessValidationStep.password),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCompletingView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          24.spaceh,
          Text(
            'Validemos tu cuenta en pocos pasos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF051858),
            ),
          ),
          34.spaceh,
          BusinessValidationStepWidget(
            text: _notifier.getStepText(
              BusinessValidationStep.email,
              BusinessStepStatus.completed,
            ),
            status: BusinessStepStatus.completed,
          ),
          16.spaceh,
          BusinessValidationStepWidget(
            text: _notifier.getStepText(
              BusinessValidationStep.whatsapp,
              BusinessStepStatus.completed,
            ),
            status: BusinessStepStatus.completed,
          ),
          16.spaceh,
          BusinessValidationStepWidget(
            text: _notifier.getStepText(
              BusinessValidationStep.business,
              BusinessStepStatus.completed,
            ),
            status: BusinessStepStatus.completed,
          ),
          16.spaceh,
          BusinessValidationStepWidget(
            text: _notifier.getStepText(
              BusinessValidationStep.identity,
              BusinessStepStatus.completed,
            ),
            status: BusinessStepStatus.completed,
          ),
          16.spaceh,
          BusinessValidationStepWidget(
            text: _notifier.getStepText(
              BusinessValidationStep.password,
              BusinessStepStatus.completed,
            ),
            status: BusinessStepStatus.completed,
          ),
          Spacer(),
          ValidationLoadingDots(),
          60.spaceh,
        ],
      ),
    );
  }
}
