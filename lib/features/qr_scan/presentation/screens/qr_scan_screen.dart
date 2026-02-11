import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _torchOn = false;
  bool _permissionGranted = false;
  bool _permissionChecked = false;

  static const double _frameWidth = 332;
  static const double _frameHeight = 366;
  static const double _frameRadius = 30;
  static const double _borderStrokeWidth = 5;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    setState(() {
      _permissionChecked = true;
      _permissionGranted = status.isGranted;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;
    // TODO: usar código según flujo (emitir puntos / canjear)
    context.router.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_permissionChecked && _permissionGranted) ...[
            MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
            ),
            _ScanOverlay(
              frameWidth: _frameWidth,
              frameHeight: _frameHeight,
              frameRadius: _frameRadius,
              borderColor: context.appColor.secondary.withValues(alpha: 0.9),
              borderStrokeWidth: _borderStrokeWidth,
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: context.appColor.onPrimary,
                  size: 47,
                ),
                onPressed: () => context.router.pop(),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Enfoque el código QR dentro del recuadro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.appColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: _FlashlightButton(
                isOn: _torchOn,
                onTap: () async {
                  await _controller.toggleTorch();
                  if (!mounted) return;
                  setState(() => _torchOn = !_torchOn);
                },
              ),
            ),
          ] else if (_permissionChecked && !_permissionGranted)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 64,
                      color: context.appColor.onSurface,
                    ),
                    16.spaceh,
                    Text(
                      'Se necesita permiso de cámara para escanear el código QR.',
                      style: TextStyle(
                        color: context.appColor.onSurface,
                        fontSize: 18,
                        fontFamily: 'Figtree',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    24.spaceh,
                    ElevatedButton(
                      onPressed: () => openAppSettings(),
                      child: const Text('Abrir configuración'),
                    ),
                    16.spaceh,
                    TextButton(
                      onPressed: () => context.router.pop(),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(color: context.appColor.primary),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  final double frameWidth;
  final double frameHeight;
  final double frameRadius;
  final Color borderColor;
  final double borderStrokeWidth;

  const _ScanOverlay({
    required this.frameWidth,
    required this.frameHeight,
    required this.frameRadius,
    required this.borderColor,
    required this.borderStrokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final left = (w - frameWidth) / 2;
        final top = (h - frameHeight) / 2 - 40;
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, frameWidth, frameHeight),
          Radius.circular(frameRadius),
        );
        return CustomPaint(
          size: Size(w, h),
          painter: _ScanOverlayPainter(
            cutoutRect: rect,
            overlayColor: Colors.black.withValues(alpha: 0.5),
            borderColor: borderColor,
            borderStrokeWidth: borderStrokeWidth,
          ),
        );
      },
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  final RRect cutoutRect;
  final Color overlayColor;
  final Color borderColor;
  final double borderStrokeWidth;

  _ScanOverlayPainter({
    required this.cutoutRect,
    required this.overlayColor,
    required this.borderColor,
    required this.borderStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final overlay = Paint()..color = overlayColor;
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRRect(cutoutRect);
    final pathWithHole = Path.combine(PathOperation.difference, path, cutoutPath);
    canvas.drawPath(pathWithHole, overlay);

    final border = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderStrokeWidth;
    canvas.drawRRect(cutoutRect, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FlashlightButton extends StatelessWidget {
  final bool isOn;
  final VoidCallback onTap;

  const _FlashlightButton({required this.isOn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isOn
                ? context.appColor.secondary
                : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: context.appColor.secondary,
              width: 2,
            ),
          ),
          child: SizedBox(
            width: 141,
            height: 141,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flashlight_on,
                  color: isOn
                      ? context.appColor.onPrimary
                      : context.appColor.primary,
                  size: 30,
                ),
                8.spaceh,
                Text(
                  isOn ? 'Encendido' : 'Activar',
                  style: TextStyle(
                    color: isOn
                        ? context.appColor.onPrimary
                        : context.appColor.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
