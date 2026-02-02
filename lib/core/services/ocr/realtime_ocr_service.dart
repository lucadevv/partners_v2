import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:partners/core/services/ocr/ocr_engine.dart';

class RealtimeOcrService {
  Timer? _timer;
  bool _isAnalyzing = false;
  CameraController? _cameraController;

  // 1. CAMBIO AQUÍ: Declaramos la variable privada para guardar el callback
  // No la ponemos en el constructor porque la definimos en el DataSource.
  void Function(String text, String imagePath)? _onTextDetectedCallback;

  // 2. Constructor vacío o con dependencias fijas, pero SIN el callback
  RealtimeOcrService();

  /// Inicia el análisis
  void start({
    required CameraController cameraController,
    // 3. El callback entra como parámetro aquí
    required void Function(String text, String imagePath) onTextDetected,
    Duration interval = const Duration(seconds: 2),
  }) {
    debugPrint('🔄 Iniciando análisis...');
    stop();

    _cameraController = cameraController;

    // 4. Guardamos el callback en nuestra variable privada
    _onTextDetectedCallback = onTextDetected;

    _timer = Timer.periodic(interval, (timer) {
      if (_shouldStopAnalysis()) {
        timer.cancel();
        return;
      }
      _analyzeFrame();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _isAnalyzing = false;
    // No limpiamos _cameraController aquí porque puede ser usado por otros
    // Solo lo limpiamos en dispose()
  }

  bool _shouldStopAnalysis() {
    if (_cameraController == null) return true;
    
    // Verificar si el controller está inicializado y no está desechado
    try {
      final isInitialized = _cameraController!.value.isInitialized;
      // Intentar acceder a una propiedad para verificar si está desechado
      // Si está desechado, esto lanzará una excepción
      final _ = _cameraController!.value;
      return !isInitialized;
    } catch (e) {
      // Si hay una excepción, el controller está desechado
      debugPrint('⚠️ CameraController disposed, stopping analysis');
      return true;
    }
  }

  Future<void> _analyzeFrame() async {
    if (_isAnalyzing) return;

    // Verificar antes de procesar
    if (_shouldStopAnalysis()) {
      stop();
      return;
    }

    try {
      _isAnalyzing = true;

      // Verificar nuevamente antes de tomar la foto
      if (_cameraController == null || !_cameraController!.value.isInitialized) {
        stop();
        return;
      }

      final image = await _cameraController!.takePicture();
      final imagePath = image.path;

      debugPrint('📸 Imagen capturada: $imagePath');

      // Procesamiento LIGERO
      final engine = OcrEngine();
      final rawText = await engine.extractText(imagePath);

      // El texto ya viene en mayúsculas del OcrEngine
      debugPrint('🔍 Texto extraído (${rawText.length} caracteres): ${rawText.isEmpty ? "(vacío)" : rawText.substring(0, rawText.length > 100 ? 100 : rawText.length)}...');
      
      // Mostrar texto completo si es corto, o primeros 200 caracteres si es largo
      if (rawText.isNotEmpty) {
        if (rawText.length <= 200) {
          debugPrint('📋 TEXTO COMPLETO DETECTADO:\n$rawText\n');
        } else {
          debugPrint('📋 TEXTO DETECTADO (primeros 200 caracteres):\n${rawText.substring(0, 200)}...\n');
          debugPrint('📋 ... (${rawText.length - 200} caracteres más)');
        }
      }

      // 5. Usamos la variable privada guardada (usamos ? por si es null)
      if (rawText.isNotEmpty) {
        debugPrint('✅ Texto detectado, llamando callback');
        _onTextDetectedCallback?.call(rawText, imagePath);
      } else {
        debugPrint('⚠️ No se detectó texto, eliminando imagen temporal');
        // Si no hay texto, limpiamos el archivo temporal para no llenar memoria
        File(
          imagePath,
          // ignore: invalid_return_type_for_catch_error
        ).delete().catchError((e) => debugPrint('Error borrando temp: $e'));
      }
    } on CameraException catch (e) {
      // Manejar específicamente errores de cámara
      if (e.code == 'Disposed CameraController' || 
          e.description?.contains('disposed') == true) {
        debugPrint('⚠️ CameraController disposed, stopping realtime OCR');
        stop();
      } else {
        debugPrint('⚠️ Camera error: ${e.code} - ${e.description}');
      }
    } catch (e) {
      debugPrint('⚠️ Error frame: $e');
      // Si hay un error inesperado, verificar si debemos detener
      if (_shouldStopAnalysis()) {
        stop();
      }
    } finally {
      _isAnalyzing = false;
    }
  }

  void dispose() {
    stop();
    _cameraController = null;
  }
}
