import 'package:partners/core/services/ocr/ocr_engine.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/features/auth/document_scan/domain/parser/ce_parser.dart';
import 'package:partners/features/auth/document_scan/domain/parser/dni_parser.dart';
import 'package:partners/features/auth/document_scan/domain/parser/document_parser.dart';

class OcrService {
  final OcrEngine _engine = OcrEngine();
  final List<DocumentParser> _parsers = [DniParser(), CeParser()];

  Future<DocumentScanResult> scanComplete(String imagePath) async {
    // 1. Obtener texto
    final text = await _engine.extractText(imagePath);

    // 2. Intentar parsear
    for (final parser in _parsers) {
      final result = parser.parse(text);
      if (result != null) return result; // Retornamos el objeto completo
    }

    throw Exception("No se pudo识别 el documento");
  }
}
