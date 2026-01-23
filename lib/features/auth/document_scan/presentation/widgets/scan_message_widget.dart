import 'package:flutter/material.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document_scan_cubit.dart';

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
      case DocumentScanStatus.initializingCamera:
        message = isCameraReady
            ? 'Coloca tu documento de \nidentidad dentro del marco'
            : 'Inicializando cámara...';
        break;
      case DocumentScanStatus.cameraReady:
        message = 'Coloca tu documento de \nidentidad dentro del marco';
        break;
      case DocumentScanStatus.capturing:
        message = 'Capturando imagen...';
        break;
      case DocumentScanStatus.processing:
        message = 'Procesando documento...\nPor favor espere.';
        break;
      case DocumentScanStatus.captured:
        if (state.ocrData != null) {
          message =
              'Documento detectado:\n${state.ocrData!.tipoDocumento.name.toUpperCase()} ${state.ocrData!.numeroDocumento}';
        } else {
          message = 'Imagen capturada';
        }
        break;
      case DocumentScanStatus.validating:
        message = 'Validando:\nNo mueva, por favor.';
        break;
      case DocumentScanStatus.validated:
        message = '¡Perfecto!\nSu documento ha sido validado';
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
