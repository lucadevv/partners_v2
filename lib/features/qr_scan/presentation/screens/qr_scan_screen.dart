import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _isFlashlightOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Camera preview placeholder
          Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'Camera Preview',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 47,
                      ),
                      onPressed: () => context.router.pop(),
                    ),
                  ),
                  const Spacer(),
                  // Instructions
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Enfoque el código QR dentro del recuadro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF00114A),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // QR Frame
                  Container(
                    width: 332,
                    height: 366,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Flashlight button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFlashlightOn = !_isFlashlightOn;
                      });
                    },
                    child: Container(
                      width: 141,
                      height: 141,
                      decoration: BoxDecoration(
                        color: _isFlashlightOn
                            ? const Color(0xFF0EA5E9)
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flashlight_on,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isFlashlightOn ? 'Encendido' : 'Activar',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
