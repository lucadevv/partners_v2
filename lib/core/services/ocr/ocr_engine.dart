import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrEngine {
  final TextRecognizer _recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  Future<String> extractText(String path) async {
    try {
      debugPrint('🔍 [OcrEngine] Procesando imagen: $path');
      final inputImage = InputImage.fromFilePath(path);
      final recognizedText = await _recognizer.processImage(inputImage);
      
      final text = recognizedText.text;
      final blocksCount = recognizedText.blocks.length;
      
      debugPrint('📄 [OcrEngine] Texto reconocido: ${text.length} caracteres, ${blocksCount} bloques');
      debugPrint('📄 [OcrEngine] Primeros 100 caracteres: ${text.length > 100 ? text.substring(0, 100) : text}');
      
      // Log detallado de todos los bloques
      if (blocksCount > 0) {
        debugPrint('📄 [OcrEngine] Detalles de bloques:');
        for (int i = 0; i < blocksCount && i < 10; i++) {
          final block = recognizedText.blocks[i];
          debugPrint('📄   Bloque $i: "${block.text}" (${block.lines.length} líneas)');
        }
        if (blocksCount > 10) {
          debugPrint('📄   ... y ${blocksCount - 10} bloques más');
        }
      }
      
      if (text.isEmpty && blocksCount > 0) {
        debugPrint('⚠️ [OcrEngine] Hay bloques pero el texto está vacío. Bloque 0: ${recognizedText.blocks.first.text}');
      }
      
      // Convertir a mayúsculas antes de retornar
      return text.toUpperCase();
    } catch (e, stackTrace) {
      debugPrint('❌ [OcrEngine] Error al procesar imagen: $e');
      debugPrint('❌ [OcrEngine] Stack trace: $stackTrace');
      return '';
    }
  }

  void dispose() => _recognizer.close();
}
