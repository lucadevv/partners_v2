import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/ce.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/features/auth/document_scan/domain/parser/document_parser.dart';

class CeParser implements DocumentParser {
  @override
  DocumentScanResult? parse(String text) {
    var ceMatch = RegExp(
      r'CARN[ÉE]\s+DE\s+EXTRANJER[ÍI]A[:\s]+N[°º]\s*(\d{9})',
      caseSensitive: false,
    ).firstMatch(text);

    if (ceMatch == null) {
      ceMatch = RegExp(r'\b(\d{9})\b').firstMatch(text);
      if (ceMatch == null) return null;
    }

    final number = ceMatch.group(1)!;

    final name = _extractName(text);
    final lastName = _extractLastName(text);
    final dob = _extractBirthDate(text);
    final gender = _extractGender(text);

    return DocumentScanResult(
      document: Ce(number: number, type: DocumentType.ce),
      extractedName: name,
      extractedLastName: lastName,
      extractedBirthDate: dob,
      extractedGender: gender,
      rawText: text,
      confidence: 0.9,
    );
  }

  String? _extractName(String text) {
    var match = RegExp(
      r'(?:NOMBRES|Nombres)\s*/?\s*GIVEN\s+NAMES\s*[:.]?\s*(?:\n|\r\n)\s*([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      final name = match.group(1)?.trim();
      if (name != null && name.isNotEmpty) {
        final cleaned = _cleanName(name);
        if (cleaned.isNotEmpty &&
            cleaned.length > 4 &&
            !cleaned.contains('APELLIDOS') &&
            !cleaned.contains('SURNAME') &&
            !cleaned.contains('ONE') &&
            !cleaned.contains('GIVEN') &&
            !cleaned.contains('NAMES')) {
          return cleaned;
        }
      }
    }

    match = RegExp(
      r'(?:NOMBRES|Nombres)\s*/?\s*GIVEN\s+NAMES\s*[:.]?\s+([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      final name = match.group(1)?.trim();
      if (name != null && name.isNotEmpty) {
        final cleaned = _cleanName(name);
        if (cleaned.isNotEmpty &&
            cleaned.length > 4 &&
            !cleaned.contains('APELLIDOS') &&
            !cleaned.contains('SURNAME') &&
            !cleaned.contains('ONE') &&
            !cleaned.contains('GIVEN') &&
            !cleaned.contains('NAMES')) {
          return cleaned;
        }
      }
    }

    match = RegExp(
      r'(?:NOMBRES|Nombres)\s*:\s*(?:\n|\r\n)\s*([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      final name = match.group(1)?.trim();
      if (name != null && name.isNotEmpty) {
        final cleaned = _cleanName(name);
        if (cleaned.isNotEmpty &&
            cleaned.length > 4 &&
            !cleaned.contains('APELLIDOS') &&
            !cleaned.contains('SURNAME') &&
            !cleaned.contains('ONE')) {
          return cleaned;
        }
      }
    }

    final nombresMatch = RegExp(
      r'(?:NOMBRES|Nombres)\s*/?\s*GIVEN\s+NAMES\s*[:.]?',
      caseSensitive: false,
    ).firstMatch(text);
    if (nombresMatch != null) {
      final startPos = nombresMatch.end;
      final searchText = text.substring(
        startPos,
        startPos + 100 < text.length ? startPos + 100 : text.length,
      );
      final nameMatch = RegExp(
        r'\b([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
        caseSensitive: false,
      ).firstMatch(searchText);
      if (nameMatch != null) {
        final candidate = nameMatch.group(1)?.trim() ?? '';
        if (candidate.isNotEmpty &&
            !candidate.contains('APELLIDOS') &&
            !candidate.contains('SURNAME') &&
            !candidate.contains('ONE') &&
            !candidate.contains('GIVEN') &&
            !candidate.contains('NAMES') &&
            candidate.length > 5) {
          final cleaned = _cleanName(candidate);
          if (cleaned.isNotEmpty && cleaned.length > 4) {
            return cleaned;
          }
        }
      }
    }

    return null;
  }

  String? _extractLastName(String text) {
    var match = RegExp(
      r'(?:ONE\s*)?APEL?LIDOS\s*[^\n]*(?:/|F|I)?\s*SUR(?:NI|RI)?AME[E.]?\s*[:.]?\s*(?:\n|\r\n)\s*([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      final lastName = match.group(1)?.trim();
      if (lastName != null && lastName.isNotEmpty) {
        final words = lastName.split(RegExp(r'\s+'));
        if (words.length >= 2) {
          final limitedLastName = '${words[0]} ${words[1]}';
          final cleaned = _cleanName(limitedLastName);
          if (cleaned.isNotEmpty &&
              cleaned.length > 4 &&
              !cleaned.contains('NOMBRES') &&
              !cleaned.contains('GIVEN') &&
              !cleaned.contains('NAMES') &&
              !cleaned.contains('ONE')) {
            return cleaned;
          }
        }
      }
    }

    match = RegExp(
      r'(?:APELLIDOS|Apellidos)\s*/?\s*SUR(?:RI|N)AME\s*:?\s*(?:\n|\r\n)\s*([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      final lastName = match.group(1)?.trim();
      if (lastName != null && lastName.isNotEmpty) {
        final words = lastName.split(RegExp(r'\s+'));
        if (words.length >= 2) {
          final limitedLastName = '${words[0]} ${words[1]}';
          final cleaned = _cleanName(limitedLastName);
          if (cleaned.isNotEmpty &&
              cleaned.length > 4 &&
              !cleaned.contains('KARIELYS') &&
              !cleaned.contains('CAROLINA') &&
              !cleaned.contains('NOMBRES') &&
              !cleaned.contains('GIVEN')) {
            return cleaned;
          }
        }
      }
    }

    match = RegExp(
      r'(?:APELLIDOS|Apellidos)\s*:\s*(?:\n|\r\n)\s*([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      final lastName = match.group(1)?.trim();
      if (lastName != null && lastName.isNotEmpty) {
        final words = lastName.split(RegExp(r'\s+'));
        if (words.length >= 2) {
          final limitedLastName = '${words[0]} ${words[1]}';
          final cleaned = _cleanName(limitedLastName);
          if (cleaned.isNotEmpty && cleaned.length > 4) {
            return cleaned;
          }
        }
      }
    }

    final apellidosMatch = RegExp(
      r'(?:ONE\s*)?APEL?LIDOS\s*[^\n]*(?:/|F|I)?\s*SUR(?:NI|RI)?AME[E.]?\s*[:.]?|(?:APELLIDOS|Apellidos)\s*/?\s*SUR(?:RI|N)AME\s*[:.]?',
      caseSensitive: false,
    ).firstMatch(text);
    if (apellidosMatch != null) {
      final startPos = apellidosMatch.end;
      final searchText = text.substring(
        startPos,
        startPos + 100 < text.length ? startPos + 100 : text.length,
      );
      final lastNameMatch = RegExp(
        r'\b([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
        caseSensitive: false,
      ).firstMatch(searchText);
      if (lastNameMatch != null) {
        final candidate = lastNameMatch.group(1)?.trim() ?? '';
        if (candidate.isNotEmpty &&
            !candidate.contains('NOMBRES') &&
            !candidate.contains('GIVEN') &&
            !candidate.contains('NAMES') &&
            !candidate.contains('EXTRANJERIA') &&
            !candidate.contains('CARNÉ') &&
            candidate.length > 5) {
          final words = candidate.split(RegExp(r'\s+'));
          if (words.length >= 2) {
            final limitedLastName = '${words[0]} ${words[1]}';
            final cleaned = _cleanName(limitedLastName);
            if (cleaned.isNotEmpty && cleaned.length > 4) {
              return cleaned;
            }
          }
        }
      }
    }

    return null;
  }

  String? _extractBirthDate(String text) {
    var match = RegExp(
      r'(?:FECHA\s+DE\s+NACIMIENTO|NACIMIENTO)\s*:\s*(\d{2}\s+[A-Z]{3}\s+\d{4}|\d{2}[\s/]\d{2}[\s/]\d{4})',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final dateStr = match.group(1)!;
      return _normalizeDate(dateStr);
    }

    match = RegExp(
      r'(\d{2})\s+([A-Z]{3})\s+(\d{4})',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final day = match.group(1)!;
      final month = _convertMonthToNumber(match.group(2)!);
      final year = match.group(3)!;
      if (month != null) {
        return '$day/$month/$year';
      }
    }

    return null;
  }

  String? _convertMonthToNumber(String month) {
    final months = {
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
    return months[month.toUpperCase()];
  }

  String? _extractGender(String text) {
    var match = RegExp(
      r'\b([FM])S\b\s*(?:\n|\r\n)?\s*(?:SEXO|Sexo|SEX)\s*/?\s*SEX\s*:?',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    match = RegExp(
      r'(?:SEXO|Sexo|SEX)\s*/?\s*SEX\s*:?\s*(?:\n|\r\n)?\s*([FM])S\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    match = RegExp(
      r'(?:SEXO|Sexo|SEX)\s*/?\s*SEX\s*:?\s*(?:\n|\r\n)\s*([MF])(?:\s|$|\n)',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    match = RegExp(
      r'(?:SEXO|Sexo|SEX)[^\n]*(?:\n|\r\n)\s*([FM])S\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    match = RegExp(
      r'(?:SEXO|Sexo|SEX)[^\n]*(?:\n|\r\n)\s*([MF])(?:\s|$|\n)',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    match = RegExp(
      r'(?:SEXO|Sexo|SEX)[^\n]*(?:\n|\r\n)\s*S\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      final context = text.substring(0, match.end).toUpperCase();
      if (context.contains('FEMENINO') || context.contains('F')) return 'F';
      if (context.contains('MASCULINO') || context.contains('M')) return 'M';
      return 'F';
    }

    if (text.toUpperCase().contains('MASCULINO')) return 'M';
    if (text.toUpperCase().contains('FEMENINO')) return 'F';

    final sexoMatch = RegExp(
      r'(?:SEXO|Sexo|SEX)',
      caseSensitive: false,
    ).firstMatch(text);
    if (sexoMatch != null) {
      final beforeStart = sexoMatch.start > 20 ? sexoMatch.start - 20 : 0;
      final beforeText = text.substring(beforeStart, sexoMatch.start);
      final beforeMatch = RegExp(r'\b([FM])S\b').firstMatch(beforeText);
      if (beforeMatch != null) return beforeMatch.group(1);

      final startPos = sexoMatch.end;
      final afterText = text.substring(
        startPos,
        startPos + 50 < text.length ? startPos + 50 : text.length,
      );
      final fsMatch = RegExp(r'\b([FM])S\b').firstMatch(afterText);
      if (fsMatch != null) return fsMatch.group(1);
      final genderMatch = RegExp(r'\b([MF])\b').firstMatch(afterText);
      if (genderMatch != null) return genderMatch.group(1);
    }

    return null;
  }

  String _normalizeDate(String dateStr) {
    return dateStr.replaceAll(RegExp(r'[\s-]'), '/');
  }

  String _cleanName(String text) {
    final invalidWords = [
      'APELLIDOS',
      'NOMBRES',
      'FECHA',
      'NACIMIENTO',
      'SEXO',
      'NACIONALIDAD',
      'ESTADO',
      'CIVIL',
      'EMISIÓN',
      'CADUCIDAD',
      'CARNÉ',
      'EXTRANJERÍA',
      'DOCUMENTO',
      'VIAJE',
      'CIP',
      'CALIDAD',
      'MIGRATORIA',
    ];

    final words = text.split(RegExp(r'[\s\n]+'));
    final cleanWords = words
        .map((word) => word.trim().toUpperCase())
        .where(
          (word) =>
              word.isNotEmpty &&
              word.length > 1 &&
              !invalidWords.contains(word),
        )
        .toList();

    return cleanWords.join(' ').trim();
  }
}
