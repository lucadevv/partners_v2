import 'package:flutter/material.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document/document_scan_cubit.dart';

class ScanMessageWidget extends StatelessWidget {
  final DocumentScanState state;
  final bool isCameraReady;

  const ScanMessageWidget({
    super.key,
    required this.state,
    required this.isCameraReady,
  });

  @override
  Widget build(BuildContext context) {
    String message;

    switch (state.status) {
      case DocumentScanStatus.initial:
        message = isCameraReady
            ? 'Coloca tu documento de identidad dentro del marco'
            : 'Inicializando cámara...';
        break;
      case DocumentScanStatus.cameraReady:
        // Si hay texto detectado pero aún no está completo, mostrar que está leyendo
        if (state.realtimeText != null && state.realtimeText!.isNotEmpty) {
          message = 'Leyendo información del documento...';
        } else {
          message = 'Coloca tu documento de identidad dentro del marco';
        }
        break;
      case DocumentScanStatus.processing:
        message = 'Procesando documento...\nPor favor espere.';
        break;
      case DocumentScanStatus.captured:
        if (state.ocrResult != null) {
          final result = state.ocrResult!;
          message =
              'Documento Detectado:\n${result.document.type.name.toUpperCase()} ${result.document.number.toUpperCase()}';
        } else {
          message = 'Imagen capturada';
        }
        break;
      case DocumentScanStatus.failure:
        message =
            state.errorMessage ??
            'Error al procesar documento.\nIntenta nuevamente.';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.3,
        ),
      ),
    );
  }
}
