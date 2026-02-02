// --- PARSERS ---

import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';

abstract class DocumentParser {
  DocumentScanResult? parse(String text);
}
