import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';

@RoutePage()
class DocumentSuccessScreen extends StatelessWidget {
  const DocumentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051858),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                  14.spacew,
                  Text(
                    'Regresar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Success Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF10B981).withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 80,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  32.spaceh,
                  // Text
                  Text(
                    '¡Perfecto!\nSu documento ha sido validado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            // Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to next screen (Business Validation)
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

            60.spaceh,
          ],
        ),
      ),
    );
  }
}
