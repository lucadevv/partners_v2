import 'package:flutter/material.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document_scan_cubit.dart';

class DetectedTextWidget extends StatelessWidget {
  final DocumentScanState state;

  const DetectedTextWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.textoDetectado == null || state.textoDetectado!.isEmpty) {
      return const SizedBox.shrink();
    }

    final texto = state.textoDetectado!;
    final tieneDocumento = state.ocrData != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tieneDocumento
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tieneDocumento
              ? Colors.green.withValues(alpha: 0.5)
              : Colors.orange.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      constraints: const BoxConstraints(
        maxHeight: 250,
        maxWidth: double.infinity,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                tieneDocumento ? Icons.check_circle : Icons.warning,
                color: tieneDocumento ? Colors.green : Colors.orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tieneDocumento
                      ? 'Documento detectado correctamente'
                      : 'Texto detectado (sin documento válido)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${texto.length} chars',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (state.ocrData != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    '${state.ocrData!.tipoDocumento.name.toUpperCase()}: ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    state.ocrData!.numeroDocumento,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          const Text(
            'Texto completo detectado:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: SingleChildScrollView(
              child: SelectableText(
                texto,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
