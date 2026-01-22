import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_field_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_header_widget.dart';

@RoutePage()
class BusinessValidationScreen extends StatefulWidget {
  const BusinessValidationScreen({super.key});

  @override
  State<BusinessValidationScreen> createState() => _BusinessValidationScreenState();
}

class _BusinessValidationScreenState extends State<BusinessValidationScreen> {
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _razonSocialController = TextEditingController();

  @override
  void dispose() {
    _rucController.dispose();
    _razonSocialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegisterHeaderWidget(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 120),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24,
                children: [
                  Text(
                    'Validemos su negocio',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF051858),
                    ),
                  ),
                  16.spaceh,
                  RegisterFieldWidget(
                    label: 'RUC del negocio',
                    placeholder: 'Ingrese el RUC',
                    controller: _rucController,
                    keyboardType: TextInputType.number,
                  ),
                  RegisterFieldWidget(
                    label: 'Razón social',
                    placeholder: 'Aparecerá automáticamente',
                    controller: _razonSocialController,
                    enabled: false,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 36,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to success screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66CFFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                padding: EdgeInsets.symmetric(vertical: 18),
                minimumSize: Size(double.infinity, 56),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  Icon(Icons.arrow_forward, color: const Color(0xFF051858), size: 20),
                  Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF051858),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
