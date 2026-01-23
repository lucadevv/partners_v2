import 'dart:io';
import 'package:flutter/material.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document_scan_cubit.dart';

class DocumentFrameWidget extends StatelessWidget {
  final DocumentScanState state;
  final AnimationController loadingController;

  const DocumentFrameWidget({
    super.key,
    required this.state,
    required this.loadingController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 54),
      width: 332,
      height: 535,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Imagen capturada si existe
          if (state.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.file(
                File(state.imagePath!),
                width: 332,
                height: 535,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 332,
                    height: 535,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, size: 50),
                  );
                },
              ),
            ),

          // Esquinas decorativas
          ..._buildCornerIndicators(),

          // Status indicator
          if (state.status == DocumentScanStatus.processing ||
              state.status == DocumentScanStatus.validating)
            _buildLoadingIndicator()
          else if (state.status == DocumentScanStatus.validated)
            _buildSuccessIndicator(),
        ],
      ),
    );
  }

  List<Widget> _buildCornerIndicators() {
    return [
      Positioned(
        top: -2,
        left: -2,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: const Color(0xFF66CFFF), width: 4),
              left: BorderSide(color: const Color(0xFF66CFFF), width: 4),
            ),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16)),
          ),
        ),
      ),
      Positioned(
        top: -2,
        right: -2,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: const Color(0xFF66CFFF), width: 4),
              right: BorderSide(color: const Color(0xFF66CFFF), width: 4),
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: -2,
        left: -2,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: const Color(0xFF66CFFF), width: 4),
              left: BorderSide(color: const Color(0xFF66CFFF), width: 4),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: -2,
        right: -2,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: const Color(0xFF66CFFF), width: 4),
              right: BorderSide(color: const Color(0xFF66CFFF), width: 4),
            ),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: loadingController,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Opacity(
                  opacity: _getLoadingDotOpacity(i),
                  child: Container(
                    width: 49,
                    height: 49,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  double _getLoadingDotOpacity(int index) {
    final progress = loadingController.value;
    final delay = index * 0.15;
    final adjustedProgress = (progress + delay) % 1.0;

    if (adjustedProgress < 0.5) {
      return adjustedProgress * 2;
    } else {
      return 2 - (adjustedProgress * 2);
    }
  }

  Widget _buildSuccessIndicator() {
    return Container(
      width: 103,
      height: 103,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF0A2B7A),
      ),
      child: const Icon(
        Icons.check_circle_outline,
        size: 60,
        color: Colors.white,
      ),
    );
  }
}
