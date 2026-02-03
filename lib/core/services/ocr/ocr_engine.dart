import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrEngine {
  final TextRecognizer _recognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  Future<String> extractText(String path) async {
    try {
      final inputImage = InputImage.fromFilePath(path);

      final recognizedText = await _recognizer.processImage(inputImage);

      print('lucadev1 ${recognizedText.text}');
      final text = recognizedText.text;
      return text.toUpperCase();
    } catch (e) {
      return '';
    }
  }

  void dispose() => _recognizer.close();
}
