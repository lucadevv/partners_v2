import 'package:flutter/material.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document/document_scan_cubit.dart';

class DetectedTextWidget extends StatelessWidget {
  final DocumentScanState state;

  const DetectedTextWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // Caso 1: Documento Capturado y Parseado (Éxito)
    if (state.status == DocumentScanStatus.captured &&
        state.ocrResult != null) {
      final result = state.ocrResult!;
      return _buildSuccessCard(result);
    }

    // Caso 2: Cámara lista con texto en tiempo real (Lectura en vivo)
    if (state.status == DocumentScanStatus.cameraReady &&
        state.realtimeText != null &&
        state.realtimeText!.isNotEmpty) {
      return _buildLivePreviewCard(state.realtimeText!);
    }

    // Caso 3: Procesando con texto en tiempo real (Lectura en vivo)
    if (state.status == DocumentScanStatus.processing &&
        state.realtimeText != null &&
        state.realtimeText!.isNotEmpty) {
      return _buildLivePreviewCard(state.realtimeText!);
    }

    // Caso 4: Error con texto detectado
    if (state.status == DocumentScanStatus.failure &&
        state.realtimeText != null &&
        state.realtimeText!.isNotEmpty) {
      return _buildLivePreviewCard(state.realtimeText!);
    }

    return const SizedBox.shrink();
  }

  Widget _buildSuccessCard(dynamic result) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Documento Detectado Correctamente',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Mostrar todos los campos disponibles
          if (result.extractedName != null && result.extractedName!.isNotEmpty) ...[
            _buildInfoRow('Nombre:', result.extractedName!.toUpperCase()),
            const SizedBox(height: 4),
          ],
          if (result.extractedLastName != null && result.extractedLastName!.isNotEmpty) ...[
            _buildInfoRow('Apellido:', result.extractedLastName!.toUpperCase()),
            const SizedBox(height: 4),
          ],
          if (result.extractedBirthDate != null && result.extractedBirthDate!.isNotEmpty) ...[
            _buildInfoRow('Fecha de Nacimiento:', result.extractedBirthDate!.toUpperCase()),
            const SizedBox(height: 4),
          ],
          if (result.extractedGender != null && result.extractedGender!.isNotEmpty) ...[
            _buildInfoRow('Género:', result.extractedGender!.toUpperCase()),
            const SizedBox(height: 4),
          ],
          _buildInfoRow(
            'Número de Documento:',
            (result.document?.number ?? 'N/A').toUpperCase(),
          ),
          // lucadev: Mostrar código de seguridad solo si es DNI (CE no tiene código de seguridad)
          if (result.document is Dni && (result.document as Dni).securityCode.isNotEmpty) ...[
            const SizedBox(height: 4),
            _buildInfoRow(
              'Código de Seguridad:',
              (result.document as Dni).securityCode.toUpperCase(),
            ),
          ],
          if (result.document?.type != null) ...[
            const SizedBox(height: 4),
            _buildInfoRow(
              'Tipo de Documento:',
              result.document!.type.toString().toUpperCase(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLivePreviewCard(String text) {
    // Convertir texto a mayúsculas
    final textUpperCase = text.toUpperCase();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (state.status == DocumentScanStatus.processing) ...[
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                ),
                const SizedBox(width: 8),
              ] else ...[
                const Icon(Icons.visibility, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                state.status == DocumentScanStatus.processing
                    ? 'Procesando...'
                    : 'Leyendo Texto...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                textUpperCase,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label ',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
