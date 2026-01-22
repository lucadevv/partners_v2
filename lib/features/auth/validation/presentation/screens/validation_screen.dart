import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_header_widget.dart';
import 'package:partners/features/auth/validation/presentation/notifier/validation_form_notifier.dart';
import 'package:partners/features/auth/validation/presentation/widgets/validation_step_widget.dart';
import 'package:partners/features/auth/validation/presentation/widgets/validation_loading_dots.dart';
import 'package:partners/features/auth/otp/presentation/widgets/otp_bottom_sheet.dart';
import 'package:partners/features/auth/validation/presentation/widgets/validation_input_bottom_sheet.dart';

@RoutePage()
class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  late ValidationFormNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ValidationFormNotifier();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  void _handleStepTap(ValidationStep step) {
    // Aquí se manejaría la navegación a los bottom sheets correspondientes
    // Por ahora, simplemente completamos el step para demostración
    switch (step) {
      case ValidationStep.email:
        // Navegar a bottom sheet de email
        _showEmailBottomSheet();
        break;
      case ValidationStep.whatsapp:
        // Navegar a bottom sheet de whatsapp
        _showWhatsAppBottomSheet();
        break;
      case ValidationStep.password:
        // Navegar a bottom sheet de password
        _showPasswordBottomSheet();
        break;
      case ValidationStep.document:
        // Navegar a pantalla de escaneo de documento
        _showDocumentScan();
        break;
    }
  }

  void _showEmailBottomSheet() async {
    // Paso 1: Capturar email
    final email = await ValidationInputBottomSheet.show(
      context: context,
      title: 'Validando su email',
      label: 'Email',
      placeholder: 'Ingrese su correo electrónico',
      keyboardType: TextInputType.emailAddress,
      backgroundWidget: _buildStepsView(),
    );

    if (email == null || email.isEmpty) return;

    // Paso 2: Validar con OTP
    final code = await OtpBottomSheet.show(
      context: context,
      title: 'Validando su email',
      backgroundWidget: _buildStepsView(),
    );

    if (code != null && code.length == 5) {
      // TODO: Validar código OTP con el cubit
      // Por ahora, simplemente completamos el step
      _notifier.completeCurrentStep();
    }
  }

  void _showWhatsAppBottomSheet() async {
    // Paso 1: Capturar número de WhatsApp
    final whatsapp = await ValidationInputBottomSheet.show(
      context: context,
      title: 'Validando su celular con WhatsApp',
      label: 'Celular vinculado a WhatsApp',
      placeholder: 'Ingrese su número de celular',
      keyboardType: TextInputType.phone,
      backgroundWidget: _buildStepsView(),
    );

    if (whatsapp == null || whatsapp.isEmpty) return;

    // Paso 2: Validar con OTP
    final code = await OtpBottomSheet.show(
      context: context,
      title: 'Validando su WhatsApp',
      backgroundWidget: _buildStepsView(),
    );

    if (code != null && code.length == 5) {
      // TODO: Validar código OTP con el cubit
      _notifier.completeCurrentStep();
    }
  }

  void _showPasswordBottomSheet() async {
    // Capturar password (sin OTP)
    final password = await ValidationInputBottomSheet.show(
      context: context,
      title: 'Creando su contraseña segura',
      label: 'Contraseña',
      placeholder: 'Ingrese su contraseña',
      obscureText: true,
      backgroundWidget: _buildStepsView(),
    );

    if (password != null && password.isNotEmpty) {
      // TODO: Guardar password con el cubit
      _notifier.completeCurrentStep();
    }
  }

  void _showDocumentScan() async {
    // Navigate to Document Scan screen
    // await context.router.push(DocumentScanRoute());
    // For now, simulate completion
    Future.delayed(Duration(milliseconds: 500), () {
      _notifier.completeCurrentStep();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterHeaderWidget(
        onBackPressed: () {
          if (_notifier.currentStep != ValidationStep.email) {
            _notifier.goToPreviousStep();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      body: ListenableBuilder(
        listenable: _notifier,
        builder: (context, _) {
          if (_notifier.isCompleting) {
            return _buildCompletingView();
          }

          return _buildStepsView();
        },
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
          ValidationStepWidget(
            text: _notifier.getStepText(
              ValidationStep.email,
              _notifier.stepStatuses[ValidationStep.email]!,
            ),
            status: _notifier.stepStatuses[ValidationStep.email]!,
            onTap: () => _handleStepTap(ValidationStep.email),
          ),
          16.spaceh,
          ValidationStepWidget(
            text: _notifier.getStepText(
              ValidationStep.whatsapp,
              _notifier.stepStatuses[ValidationStep.whatsapp]!,
            ),
            status: _notifier.stepStatuses[ValidationStep.whatsapp]!,
            onTap: () => _handleStepTap(ValidationStep.whatsapp),
          ),
          16.spaceh,
          ValidationStepWidget(
            text: _notifier.getStepText(
              ValidationStep.password,
              _notifier.stepStatuses[ValidationStep.password]!,
            ),
            status: _notifier.stepStatuses[ValidationStep.password]!,
            onTap: () => _handleStepTap(ValidationStep.password),
          ),
          16.spaceh,
          ValidationStepWidget(
            text: _notifier.getStepText(
              ValidationStep.document,
              _notifier.stepStatuses[ValidationStep.document]!,
            ),
            status: _notifier.stepStatuses[ValidationStep.document]!,
            onTap: () => _handleStepTap(ValidationStep.document),
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
          ValidationStepWidget(
            text: _notifier.getStepText(
              ValidationStep.email,
              StepStatus.completed,
            ),
            status: StepStatus.completed,
          ),
          16.spaceh,
          ValidationStepWidget(
            text: _notifier.getStepText(
              ValidationStep.whatsapp,
              StepStatus.completed,
            ),
            status: StepStatus.completed,
          ),
          16.spaceh,
          ValidationStepWidget(
            text: _notifier.getStepText(
              ValidationStep.password,
              StepStatus.completed,
            ),
            status: StepStatus.completed,
          ),
          16.spaceh,
          ValidationStepWidget(
            text: _notifier.getStepText(
              ValidationStep.document,
              StepStatus.completed,
            ),
            status: StepStatus.completed,
          ),
          Spacer(),
          ValidationLoadingDots(),
          60.spaceh,
        ],
      ),
    );
  }
}
