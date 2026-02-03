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
    bool isError = false;

    switch (state.status) {
      case DocumentScanStatus.initial:
        message = isCameraReady
            ? 'Coloca tu documento de identidad dentro del marco'
            : 'Inicializando cámara...';
        break;
      case DocumentScanStatus.cameraReady:
        // Si hay texto detectado pero aún no está completo, mostrar que está validando
        if (state.realtimeText != null && state.realtimeText!.isNotEmpty) {
          message = 'Validando:\nNo mueva, por favor.';
        } else {
          message = 'Coloca tu documento de identidad dentro del marco';
        }
        break;
      case DocumentScanStatus.processing:
        message = 'Validando:\nNo mueva, por favor.';
        break;
      case DocumentScanStatus.captured:
        if (state.ocrResult != null &&
            state.uploadStatus == UploadIdentityStatus.success) {
          message = '¡Perfecto!\nSu documento ha sido validado';
        } else if (state.ocrResult != null) {
          final result = state.ocrResult!;
          message =
              'Documento Detectado:\n${result.document.type.name.toUpperCase()} ${result.document.number.toUpperCase()}';
        } else {
          message = 'Imagen capturada';
        }
        break;
      case DocumentScanStatus.failure:
        // Solo mostrar mensaje de error si hay errorMessage
        if (state.errorMessage != null) {
          message = state.errorMessage!;
          isError = true;
        } else {
          message = 'Coloca tu documento de identidad dentro del marco';
        }
        break;
    }

    // Si es error, no mostrar el mensaje aquí (se mostrará sobre el icono de error)
    if (isError) {
      return const SizedBox.shrink();
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
