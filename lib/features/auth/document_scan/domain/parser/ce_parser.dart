import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/ce.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/features/auth/document_scan/domain/parser/document_parser.dart';

/// Parser genérico para Carné de Extranjería (CE).
/// Funciona con cualquier titular; usa la estructura estándar del documento:
/// CARNÉ DE EXTRANJERÍA, Apellidos/Surname, Nombres/Given names,
/// Fecha Nacimiento, Sexo, Caducidad/Date of Expiry.
class CeParser implements DocumentParser {
  static final RegExp _numberRegex = RegExp(
    r'CARN[ÉE]\s+DE\s+EXTRANJER[ÍI]A[:\s]*N[°º]?\s*(\d{9})',
    caseSensitive: false,
  );

  static final RegExp _numberFallback = RegExp(r'\b(\d{9})\b');

  /// Patrón para 2 palabras en mayúsculas (apellidos o nombres de cualquier titular).
  /// Mínimo 3 caracteres por palabra para soportar nombres cortos (ej. LEE, KIM).
  static final RegExp _namePairRegex = RegExp(
    r'\b([A-ZÁÉÍÓÚÑ]{3,25})\s+([A-ZÁÉÍÓÚÑ]{3,25})\b',
  );

  // Sexo / Sex: ## ES (OCR con ruido; buscar M o F en ventana tras SEX)
  static final RegExp _genderRegex = RegExp(
    r'(?:SEXO|SEX)[^\n]{0,35}([MF])\b',
    caseSensitive: false,
  );

  static const Map<String, String> _months = {
    'ENE': '01',
    'JAN': '01',
    'FEB': '02',
    'MAR': '03',
    'ABR': '04',
    'APR': '04',
    'MAY': '05',
    'JUN': '06',
    'JUL': '07',
    'AGO': '08',
    'AUG': '08',
    'SEP': '09',
    'OCT': '10',
    'NOV': '11',
    'DIC': '12',
    'DEC': '12',
  };

  @override
  DocumentScanResult? parse(String text) {
    final cleanText = text.replaceAll(RegExp(r'lucadev\d+\s*'), '');

    // Filtrar basura como en DNI: rechazar frames ilegibles antes de parsear.
    if (!_isValidOcrText(cleanText)) return null;

    final ceMatch =
        _numberRegex.firstMatch(cleanText) ??
        _numberFallback.firstMatch(cleanText);
    if (ceMatch == null) return null;

    final number = ceMatch.group(1)!;

    final lastName = _extractLastName(cleanText);
    final name = _extractName(cleanText, lastName);
    final dob = _extractBirthDate(cleanText);
    final expiry = _extractExpiryDate(cleanText);
    final gender = _extractGender(cleanText);

    return DocumentScanResult(
      document: Ce(number: number, type: DocumentType.ce, expiryDate: expiry),
      extractedName: name,
      extractedLastName: lastName,
      extractedBirthDate: dob,
      extractedGender: gender,
      extractedExpiryDate: expiry,
      rawText: cleanText,
      confidence: 0.9,
    );
  }

  /// Rechaza frames de OCR ilegibles antes de parsear (patrón DNI).
  bool _isValidOcrText(String text) {
    if (text.length < 40) return false;
    final letterCount = RegExp(r'[A-ZÁÉÍÓÚÑa-záéíóúñ]').allMatches(text).length;
    if (letterCount < 15) return false;
    final digitCount = RegExp(r'\d').allMatches(text).length;
    if (digitCount < 9) return false; // CE requiere 9 dígitos
    return true;
  }

  /// Extrae apellidos: por línea siguiente al label (como DNI) o por parejas.
  String? _extractLastName(String text) {
    final lines = text.split(RegExp(r'[\n\r]+'));
    final upper = text.toUpperCase();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].toUpperCase();
      if (line.contains('APELLIDOS') ||
          line.contains('APELIDOS') ||
          line.contains('SURNAME') ||
          line.contains('SURAME')) {
        // Línea siguiente = apellidos
        if (i + 1 < lines.length) {
          final nextLine = lines[i + 1].trim();
          final cleaned = _cleanCeName(nextLine);
          if (cleaned.isNotEmpty && cleaned.length >= 5) return cleaned;
        }
        // Fallback: buscar pareja válida en ventana
        final start = text.toUpperCase().indexOf(line);
        if (start >= 0) {
          final sub = text.substring(
            start,
            (start + 120).clamp(0, text.length),
          );
          final pair = _firstValidNamePair(sub);
          if (pair != null) return pair;
        }
        return null;
      }
    }

    // Fallback: buscar por índice
    final apPos = upper.indexOf('APELLIDOS');
    final apelPos = upper.indexOf('APELIDOS');
    final surPos = upper.indexOf('SURNAME');
    final suramePos = upper.indexOf('SURAME');
    final start = _minPositive(apPos, apelPos, surPos, suramePos);
    if (start < 0) return null;

    final searchEnd = (start + 120).clamp(0, text.length);
    final sub = text.substring(start, searchEnd);
    final pair = _firstValidNamePair(sub);
    if (pair != null) return _cleanCeName(pair);
    return null;
  }

  /// Devuelve el índice mínimo entre valores >= 0, o -1 si todos son < 0.
  static int _minPositive(int a, int b, [int c = -1, int d = -1]) {
    final vals = [a, b, c, d].where((x) => x >= 0).toList();
    return vals.isEmpty ? -1 : vals.reduce((x, y) => x < y ? x : y);
  }

  /// Extrae nombres: por línea siguiente al label (como DNI) o por parejas.
  /// No devuelve nunca el mismo valor que [extractedLastName] (evita usar apellidos como nombres).
  String? _extractName(String text, String? extractedLastName) {
    String? rejectIfSameAsLastName(String? candidate) {
      if (candidate == null || candidate.isEmpty) return null;
      if (extractedLastName == null || extractedLastName.isEmpty)
        return candidate;
      if (candidate.trim().toUpperCase() ==
          extractedLastName.trim().toUpperCase())
        return null;
      return candidate;
    }

    final lines = text.split(RegExp(r'[\n\r]+'));

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].toUpperCase();
      if (line.contains('NOMBRES') ||
          (line.contains('GIVEN') &&
              (line.contains('NAME') || line.contains('NAMES')))) {
        if (i + 1 < lines.length) {
          final nextLine = lines[i + 1].trim();
          final cleaned = _cleanCeName(nextLine);
          if (cleaned.isNotEmpty && cleaned.length >= 5)
            return rejectIfSameAsLastName(cleaned);
        }
        final start = text.toUpperCase().indexOf(lines[i]);
        if (start >= 0) {
          final sub = text.substring(
            start,
            (start + 120).clamp(0, text.length),
          );
          final pair = _firstValidNamePair(sub);
          if (pair != null) return rejectIfSameAsLastName(_cleanCeName(pair));
        }
        return null;
      }
    }

    final upper = text.toUpperCase();
    final nomPos = upper.indexOf('NOMBRES');
    final givenPos = upper.indexOf('GIVEN');
    final start = nomPos >= 0 ? nomPos : (givenPos >= 0 ? givenPos : -1);
    if (start < 0) return null;

    final searchEnd = (start + 120).clamp(0, text.length);
    final sub = text.substring(start, searchEnd);
    final pair = _firstValidNamePair(sub);
    if (pair != null) return rejectIfSameAsLastName(_cleanCeName(pair));
    return null;
  }

  /// Limpia nombre/apellido filtrando palabras inválidas (patrón DNI _cleanLastName).
  String _cleanCeName(String text) {
    const invalidWords = [
      'APELLIDOS',
      'NOMBRES',
      'SURNAME',
      'SURAME',
      'GIVEN',
      'NAMES',
      'FECHA',
      'NACIMIENTO',
      'SEXO',
      'CADUCIDAD',
      'EMISIÓN',
      'EMISION',
      'REPÚBLICA',
      'REPUBLICA',
      'PERÚ',
      'PERU',
      'DEL',
      'NACIONAL',
      'MIGRACIONES',
      'ESTADO',
      'CIVIL',
      'DOCUMENTO',
      'VIAJE',
      'EXTRANJERIA',
      'CARNÉ',
      'CARN',
      'CIONES',
      'DATE',
      'ISSUE',
      'EXPIRY',
      'OF',
      'OFT',
      'CATUDITAD',
      'DALE',
      'TAM',
      'PNESP',
      'PNES',
      'REP',
      'SPE',
      'ACIONE',
      'ACI',
      'PER',
      'BLICA',
      'APELIDOS',
      'APELDOS',
      'ONESPER',
      'MIGRACIO',
      'LIDAD',
      'REPUBLI',
      'UMIG',
      'RACICVES',
      'BOC',
      'CIDIR',
      'KPNESP',
      'ESPECIAL',
      'CALIDAD',
      'NACIONALIDAD',
      'AFIO', // fragmento de EXTRANJERÍA
      'GRVEN', // OCR typo de GIVEN
      'EXTRANJERÍA',
    ];

    final words = text.split(RegExp(r'[\s\n]+'));
    final cleanWords = words
        .map((w) => w.trim().toUpperCase())
        .where(
          (w) =>
              w.length >= 2 &&
              w.length <= 25 &&
              !invalidWords.contains(w) &&
              !RegExp(r'\d').hasMatch(w),
        )
        .toList();

    return cleanWords.join(' ').trim();
  }

  /// Busca la primera pareja de palabras que parezca nombre de persona.
  String? _firstValidNamePair(String text) {
    for (final m in _namePairRegex.allMatches(text)) {
      final w1 = m.group(1) ?? '';
      final w2 = m.group(2) ?? '';
      final candidate = '$w1 $w2';
      if (_isValidNamePair(candidate)) return candidate;
    }
    return null;
  }

  bool _isValidNamePair(String s) {
    if (s.length < 7 || s.length > 55) return false;
    final upper = s.toUpperCase();
    if (RegExp(r'\d').hasMatch(s)) return false;
    return !_containsAnyInvalid(upper);
  }

  /// Comprueba si una cadena contiene subcadenas inválidas (labels o ruido de OCR).
  bool _containsAnyInvalid(String upper) {
    // Etiquetas del documento, nacionalidades y fragmentos típicos de OCR con ruido.
    const invalid = [
      'APELLIDOS',
      'NOMBRES',
      'SURNAME',
      'SURAME',
      'SURIAME',
      'GIVEN',
      'NAMES',
      'FECHA',
      'NACIMIENTO',
      'SEXO',
      'CADUCIDAD',
      'EMISIÓN',
      'REPÚBLICA',
      'REPUBLICA',
      'SUPERINTENDENCIA',
      'NACIONAL',
      'MIGRACIONES',
      'CALIDAD',
      'ESPECIAL',
      'NACIONALIDAD',
      'ESTADO',
      'CIVIL', 'DOCUMENTO', 'VIAJE', 'EXTRANJERIA', 'CARNÉ', 'CARN', 'CIONES',
      'MASCULINO', 'FEMENINO', 'ISSUE', 'EXPIRY', 'ESPER', 'RACIO', 'NESPER',
      'VENEZOLANA', 'COLOMBIANA', 'ECUATORIANA', 'CHILENA', 'ARGENTINA',
      'BRASILEÑA', 'BOLIVIANA', 'PARAGUAYA', 'URUGUAYA', 'PERUANA', 'PERÚ',
      // Fragmentos OCR de REPUBLICA, MIGRACIONES, NACIONALIDAD, etc.
      'BLICA', 'APELDOS', 'APELIDOS', 'APELLD', 'TRACIO', 'ONESPER', 'MIGRACIO',
      'LIDAD', 'REPUBLI', 'SPER', 'UMIG', 'RACICVES', 'BOC', 'CIDIR', 'KPNESP',
      'AFIO',
      'EXTRANJER',
      'GRVEN', // basura OCR típica (DE AFIO, NOMBRES/GRVEN NAMES)
    ];
    return invalid.any((x) => upper.contains(x));
  }

  /// Extrae fecha nacimiento: por label (DATE OF BIRTH/NACIMIENTO) o fallback buscando
  /// toda fecha DD MMM YYYY con año 1950-2020 que no sea Emisión/Caducidad.
  String? _extractBirthDate(String text) {
    final upper = text.toUpperCase();

    // 1. Por label (label + fecha en ventana)
    final birthPos = upper.indexOf('DATE OF BIRTH');
    final nacPos = upper.indexOf('FECHA DE NACIMIENTO');
    final nacShort = upper.indexOf('NACIMIENTO');
    final labelPos = birthPos >= 0
        ? birthPos
        : (nacPos >= 0 ? nacPos : (nacShort >= 0 ? nacShort : -1));

    if (labelPos >= 0) {
      final searchEnd = (labelPos + 60).clamp(0, text.length);
      final searchText = text.substring(labelPos, searchEnd);
      final m = RegExp(
        r'(\d{2})\s+([A-Z]{3})\s+(\d{4})',
      ).firstMatch(searchText);
      if (m != null) {
        final month = _months[m.group(2)!.toUpperCase()];
        if (month != null) {
          final year = int.tryParse(m.group(3) ?? '');
          if (year != null && year < 2022) {
            return '${m.group(1)}/$month/${m.group(3)}';
          }
        }
      }
    }

    // 2. Fallback: buscar cualquier DD MMM YYYY con año 1950-2020 que NO esté en
    // sección Emisión/Caducidad (frames fragmentados suelen traer la fecha sin label).
    for (final m in RegExp(
      r'(\d{2})\s+([A-Z]{3})\s+(\d{4})',
    ).allMatches(text)) {
      final month = _months[m.group(2)!.toUpperCase()];
      if (month == null) continue;
      final year = int.tryParse(m.group(3) ?? '');
      if (year == null || year < 1950 || year >= 2022) continue;

      final start = m.start;
      final end = m.end;
      final ctxBefore = text
          .substring(start > 80 ? start - 80 : 0, start)
          .toUpperCase();
      final ctxAfter = text
          .substring(end, (end + 80).clamp(0, text.length))
          .toUpperCase();

      // Descartar si está en Emisión o Caducidad
      if (ctxBefore.contains('CADUCIDAD') ||
          ctxAfter.contains('CADUCIDAD') ||
          ctxBefore.contains('EMISIÓN') ||
          ctxAfter.contains('EMISION') ||
          ctxBefore.contains('EMISION') ||
          ctxAfter.contains('EMISIÓN') ||
          ctxBefore.contains('DATE OF EXPIRY') ||
          ctxAfter.contains('EXPIRY') ||
          ctxBefore.contains('DATE OF ISSUE') ||
          ctxAfter.contains('ISSUE')) {
        continue;
      }

      return '${m.group(1)}/$month/${m.group(3)}';
    }

    return null;
  }

  /// Extrae la fecha del label "Caducidad / Date of Expiry". Tras el label puede haber
  /// 1-2 saltos de línea y luego la fecha (01 MAR 2028). Si hay varias fechas, tomar
  /// la de año mayor (la de abajo = Caducidad; la de arriba = Emisión).
  String? _extractExpiryDate(String text) {
    final upper = text.toUpperCase();

    const labels = ['DATE OF EXPIRY', 'DATE OF EXPRY', 'CADUCIDAD'];
    for (final label in labels) {
      final pos = upper.indexOf(label);
      if (pos < 0) continue;

      // Ventana amplia DESPUÉS del label (saltos de línea + fecha debajo).
      final afterLabel = pos + label.length;
      final sub = text.substring(
        afterLabel,
        (afterLabel + 80).clamp(0, text.length),
      );
      final subUpper = sub.toUpperCase();

      // Debug: fragmento tras "Caducidad/Date of Expiry" (saltos de línea visibles).
      print(
        'lucadev [CE] expiry window after "$label" (${sub.length} chars): '
        '${sub.replaceAll("\n", "\\n").replaceAll("\r", "\\r")}',
      );

      // Descartar si entre label y fechas aparece ISSUE/EMISIÓN.
      if (subUpper.contains('ISSUE') || subUpper.contains('EMISI')) continue;

      // De todas las fechas en la ventana, tomar la de AÑO MAYOR (la de abajo = Caducidad).
      final d = _expiryDateWithMaxYearInSubstring(sub);
      if (d != null) return d;
    }

    return null;
  }

  /// Devuelve la fecha con año mayor en [sub] (DD MMM YYYY). Caducidad suele ser > Emisión.
  String? _expiryDateWithMaxYearInSubstring(String sub) {
    final matches = RegExp(r'(\d{2})\s+([A-Z]{3})\s+(\d{4})').allMatches(sub);
    String? best;
    int bestYear = 0;
    for (final m in matches) {
      final month = _months[m.group(2)!.toUpperCase()];
      if (month == null) continue;
      final year = int.tryParse(m.group(3) ?? '');
      if (year == null || year < 2020) continue;
      final candidate = '${m.group(1)}/$month/${m.group(3)}';
      if (year > bestYear) {
        bestYear = year;
        best = candidate;
      }
    }
    return best;
  }

  /// Comprueba si un valor parece nombre/apellido real (para merge: no sobrescribir con basura).
  static bool looksLikeValidPersonName(String? s) {
    if (s == null || s.isEmpty) return false;
    if (s.length < 7 || s.length > 55) return false;
    if (RegExp(r'\d').hasMatch(s)) return false;
    final upper = s.toUpperCase();
    // Rechazar si empieza con fragmentos típicos (DEL PERU, PER MANZOL, etc.)
    if (upper.startsWith('DEL ') ||
        upper.startsWith('PER ') ||
        upper.startsWith('PERU ')) {
      return false;
    }
    return !_staticContainsInvalid(upper);
  }

  static bool _staticContainsInvalid(String upper) {
    const invalid = [
      'APELLIDOS',
      'NOMBRES',
      'SURNAME',
      'SURAME',
      'SURIAME',
      'APELIDOS',
      'GIVEN',
      'NAMES',
      'REPÚBLICA',
      'REPUBLICA',
      'BLICA',
      'CIONES',
      'ESPER',
      'RACIO',
      'NESPER',
      'ISSUE',
      'EXPIRY',
      'CARN',
      'APELDOS',
      'APELLD',
      'LIDAD',
      'TRACIO',
      'ONESPER',
      'MIGRACIO',
      'REPUBLI',
      'SPER',
      'UMIG',
      'RACICVES',
      'BOC',
      'CIDIR',
      'KPNESP',
      'CADUCIDAD',
      'EMISIÓN',
      'EMISION',
      'PERU',
      'DATE',
      'OFT',
      'CATUDITAD',
      'DALE',
      'TAM',
      'PNESP',
      'PNES',
      'SPE',
      'ACIONE',
      'AFIO',
      'EXTRANJER',
      'GRVEN',
    ];
    return invalid.any((x) => upper.contains(x));
  }

  String? _extractGender(String text) {
    var m = _genderRegex.firstMatch(text);
    if (m != null) return m.group(1);
    final sexPos = text.toUpperCase().indexOf('SEXO');
    if (sexPos < 0) return null;
    final end = (sexPos + 60).clamp(0, text.length);
    final after = text.substring(sexPos, end);
    m = RegExp(r'[#\d\s:]*([MF])\b').firstMatch(after);
    if (m != null) return m.group(1);
    if (RegExp(r'FEMENINO', caseSensitive: false).hasMatch(after)) return 'F';
    if (RegExp(r'MASCULINO', caseSensitive: false).hasMatch(after)) return 'M';
    return null;
  }
}
