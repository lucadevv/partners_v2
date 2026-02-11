import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:partners/core/services/ocr/ocr_engine.dart';

class RealtimeOcrService {
  Timer? _timer;
  bool _isAnalyzing = false;
  CameraController? _cameraController;
  void Function(String text, String imagePath)? _onTextDetectedCallback;

  RealtimeOcrService();

  void start({
    required CameraController cameraController,
    required void Function(String text, String imagePath) onTextDetected,
    Duration interval = const Duration(seconds: 2),
  }) {
    stop();

    _cameraController = cameraController;
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
  }

  bool _shouldStopAnalysis() {
    if (_cameraController == null) return true;

    try {
      final isInitialized = _cameraController!.value.isInitialized;
      final _ = _cameraController!.value;
      return !isInitialized;
    } catch (e) {
      return true;
    }
  }

  Future<void> _analyzeFrame() async {
    if (_isAnalyzing) return;

    if (_shouldStopAnalysis()) {
      stop();
      return;
    }

    try {
      _isAnalyzing = true;

      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        stop();
        return;
      }

      final image = await _cameraController!.takePicture();
      final imagePath = image.path;

      final engine = OcrEngine();
      final rawText = await engine.extractText(imagePath);

      if (rawText.isNotEmpty) {
        _onTextDetectedCallback?.call(rawText, imagePath);
      } else {
        File(imagePath).delete().catchError((e) => File(imagePath));
      }
    } on CameraException catch (e) {
      if (e.code == 'Disposed CameraController' ||
          e.description?.contains('disposed') == true) {
        stop();
      }
    } catch (e) {
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
