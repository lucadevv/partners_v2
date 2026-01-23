import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';

@RoutePage()
class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051858),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: const Color(0xFF10B981),
                ),
              ),
              40.spaceh,
              // Title
              Text(
                '¡Registro Exitoso!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              16.spaceh,
              // Subtitle
              Text(
                'Tu cuenta ha sido creada exitosamente.\nYa puedes comenzar a disfrutar de todos nuestros beneficios.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              60.spaceh,
              // Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to dashboard or login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66CFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18),
                  minimumSize: Size(double.infinity, 56),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12,
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      color: const Color(0xFF051858),
                      size: 20,
                    ),
                    Text(
                      'Ir al inicio',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF051858),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
