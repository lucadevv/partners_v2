import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_field_widget.dart';
import 'package:partners/features/auth/register/presentation/widgets/register_header_widget.dart';

@RoutePage()
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    'Recuperar contraseña',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF051858),
                    ),
                  ),
                  Text(
                    'Ingrese su correo electrónico y le enviaremos un código para recuperar su contraseña.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  16.spaceh,
                  RegisterFieldWidget(
                    label: 'Correo electrónico',
                    placeholder: 'Ingrese su correo',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
                // Send recovery code
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColor.primary,
                foregroundColor: context.appColor.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                padding: EdgeInsets.symmetric(vertical: 18),
                minimumSize: Size(double.infinity, 56),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  Icon(Icons.arrow_forward, color: context.appColor.onPrimary, size: 20),
                  Text(
                    'Enviar código',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.appColor.onPrimary,
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
