import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';

@RoutePage()
class DocumentScanScreen extends StatelessWidget {
  const DocumentScanScreen({super.key});

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
                  // Icon
                  Container(
                    width: 200,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF66CFFF), width: 2),
                    ),
                    child: Icon(
                      Icons.credit_card,
                      size: 80,
                      color: const Color(0xFF66CFFF),
                    ),
                  ),
                  32.spaceh,
                  // Text
                  Text(
                    'Coloca tu documento de \nidentidad dentro del marco',
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

            // Scan Area with corners
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 36),
              width: 340,
              height: 220,
              child: Stack(
                children: [
                  // Border
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF66CFFF), width: 3),
                    ),
                  ),
                  // Top-left corner
                  Positioned(
                    left: -2,
                    top: -2,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF66CFFF), width: 4),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16)),
                      ),
                    ),
                  ),
                  // Top-right corner
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF66CFFF), width: 4),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(16)),
                      ),
                    ),
                  ),
                  // Bottom-left corner
                  Positioned(
                    left: -2,
                    bottom: -2,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF66CFFF), width: 4),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
                      ),
                    ),
                  ),
                  // Bottom-right corner
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF66CFFF), width: 4),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            100.spaceh,

            // Capture Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to validation screen
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
                    Icon(Icons.camera_alt, color: const Color(0xFF051858), size: 20),
                    Text(
                      'Capturar',
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
