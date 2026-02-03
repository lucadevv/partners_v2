import 'package:flutter/material.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document/document_scan_cubit.dart';

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
          // Esquinas decorativas (Siempre visibles)
          ..._buildCornerIndicators(),

          if (state.status == DocumentScanStatus.failure &&
              state.errorMessage != null)
            _buildErrorIndicatorWithMessage(state.errorMessage!)
          else if (state.status == DocumentScanStatus.processing ||
              (state.status == DocumentScanStatus.cameraReady &&
                  state.realtimeText != null &&
                  state.realtimeText!.isNotEmpty &&
                  state.ocrResult == null) ||
              state.uploadStatus == UploadIdentityStatus.loading)
            _buildLoadingIndicator()
          else if (state.status == DocumentScanStatus.captured &&
              state.ocrResult != null &&
              state.uploadStatus == UploadIdentityStatus.success)
            _buildSuccessIndicator(),
        ],
      ),
    );
  }

  List<Widget> _buildCornerIndicators() {
    const borderSide = BorderSide(color: Color(0xFF66CFFF), width: 4);

    return [
      // CORRECCIÓN: Se cambió right: null, bottom: null por right: false, bottom: false
      Positioned(
        top: -2,
        left: -2,
        child: _Corner(
          left: true,
          top: true,
          right: false,
          bottom: false,
          borderSide: borderSide,
        ),
      ),
      Positioned(
        top: -2,
        right: -2,
        child: _Corner(
          left: false,
          top: true,
          right: true,
          bottom: false,
          borderSide: borderSide,
        ),
      ),
      Positioned(
        bottom: -2,
        left: -2,
        child: _Corner(
          left: true,
          top: false,
          right: false,
          bottom: true,
          borderSide: borderSide,
        ),
      ),
      Positioned(
        bottom: -2,
        right: -2,
        child: _Corner(
          left: false,
          top: false,
          right: true,
          bottom: true,
          borderSide: borderSide,
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
    return adjustedProgress < 0.5
        ? adjustedProgress * 2
        : 2 - (adjustedProgress * 2);
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

  Widget _buildErrorIndicator() {
    return Container(
      width: 103,
      height: 103,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: const Icon(Icons.error_outline, size: 60, color: Colors.white),
    );
  }

  Widget _buildErrorIndicatorWithMessage(String errorMessage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 103,
          height: 103,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: const Icon(Icons.error_outline, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget auxiliar para las esquinas (mejor que duplicar código)
class _Corner extends StatelessWidget {
  final bool left, top, right, bottom;
  final BorderSide borderSide;

  const _Corner({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        // CORRECCIÓN: Uso de operador ternario explícito para evitar error de tipo
        border: Border(
          top: top ? borderSide : BorderSide.none,
          bottom: bottom ? borderSide : BorderSide.none,
          left: left ? borderSide : BorderSide.none,
          right: right ? borderSide : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(16) : Radius.zero,
          topRight: top && right ? const Radius.circular(16) : Radius.zero,
          bottomLeft: bottom && left ? const Radius.circular(16) : Radius.zero,
          bottomRight: bottom && right
              ? const Radius.circular(16)
              : Radius.zero,
        ),
      ),
    );
  }
}
