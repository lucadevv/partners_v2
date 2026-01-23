import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document_scan_cubit.dart';

/// Servicio para análisis OCR en tiempo real
class RealtimeOcrService {
  Timer? _timer;
  bool _isAnalyzing = false;
  String? _lastAnalyzedText;
  CameraController? _cameraController;
  DocumentScanCubit? _cubit;

  /// Inicia el análisis en tiempo real
  void start({
    required CameraController cameraController,
    required DocumentScanCubit cubit,
    Duration interval = const Duration(seconds: 2),
  }) {
    debugPrint('🔄 Iniciando análisis OCR en tiempo real...');
    stop();

    _cameraController = cameraController;
    _cubit = cubit;

    _timer = Timer.periodic(interval, (timer) {
      if (_shouldStopAnalysis()) {
        timer.cancel();
        return;
      }

      _analyzeFrame();
    });
  }

  /// Detiene el análisis
  void stop() {
    debugPrint('⏹️ Deteniendo análisis OCR en tiempo real...');
    _timer?.cancel();
    _timer = null;
    _isAnalyzing = false;
  }

  bool _shouldStopAnalysis() {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isAnalyzing ||
        _cubit == null) {
      return true;
    }

    final state = _cubit!.state;
    return state.status == DocumentScanStatus.captured ||
        state.status == DocumentScanStatus.validated ||
        state.status == DocumentScanStatus.validating;
  }

  Future<void> _analyzeFrame() async {
    if (_shouldStopAnalysis()) return;

    try {
      _isAnalyzing = true;
      debugPrint('📸 [RealtimeOCR] Analizando frame...');

      final image = await _cameraController!.takePicture();
      final imagePath = image.path;
      debugPrint('📸 [RealtimeOCR] Imagen capturada: $imagePath');

      try {
        final textoDetectado = await _cubit!.getRawTextFromImage(imagePath);
        debugPrint(
          '📸 [RealtimeOCR] OCR completado. Texto: ${textoDetectado?.length ?? 0} caracteres',
        );

        if (textoDetectado != null &&
            textoDetectado.isNotEmpty &&
            textoDetectado != _lastAnalyzedText) {
          _lastAnalyzedText = textoDetectado;
          debugPrint(
            '✅ [RealtimeOCR] Texto nuevo detectado: ${textoDetectado.length} caracteres',
          );
          debugPrint(
            '📄 [RealtimeOCR] Primeros 100 chars: ${textoDetectado.substring(0, textoDetectado.length > 100 ? 100 : textoDetectado.length)}',
          );

          // Actualizar texto en el estado
          _cubit!.updateDetectedText(textoDetectado);

          // Procesar documento si parece válido
          final tieneDocumento = RegExp(
            r'\d{8}|[A-Z0-9]{9,12}',
            caseSensitive: false,
          ).hasMatch(textoDetectado);

          debugPrint(
            '🔍 [RealtimeOCR] Tiene posible documento: $tieneDocumento',
          );
          debugPrint('🔍 [RealtimeOCR] Estado actual: ${_cubit!.state.status}');

          if (textoDetectado.length > 10 &&
              tieneDocumento &&
              _cubit!.state.status == DocumentScanStatus.cameraReady) {
            debugPrint('🔍 [RealtimeOCR] Procesando documento completo...');
            await _cubit!.processDocumentImage(imagePath);
            debugPrint('✅ [RealtimeOCR] Documento procesado');
            return; // No eliminar archivo, el cubit lo maneja
          }
        } else {
          debugPrint('⚠️ [RealtimeOCR] No hay texto nuevo o está vacío');
        }

        // Limpiar archivo si no se procesó
        try {
          await File(imagePath).delete();
          debugPrint('🗑️ [RealtimeOCR] Archivo temporal eliminado');
        } catch (e) {
          debugPrint('⚠️ [RealtimeOCR] Error al eliminar archivo: $e');
        }
      } catch (e, stackTrace) {
        debugPrint('⚠️ [RealtimeOCR] Error en OCR: $e');
        debugPrint('📚 Stack trace: $stackTrace');
        try {
          await File(imagePath).delete();
        } catch (_) {}
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [RealtimeOCR] Error al analizar frame: $e');
      debugPrint('📚 Stack trace: $stackTrace');
    } finally {
      _isAnalyzing = false;
    }
  }

  void dispose() {
    stop();
    _cameraController = null;
    _cubit = null;
  }
}
