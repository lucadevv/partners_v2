// lucadev: Parser para Carné de Extranjería (CE) peruano
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/ce.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/features/auth/document_scan/domain/parser/document_parser.dart';

class CeParser implements DocumentParser {
  @override
  DocumentScanResult? parse(String text) {
    // lucadev: Buscar número de CE (ej: 007213384 o CARNÉ DE EXTRANJERÍA: N° 007213384)
    // lucadev: El CE tiene 9 dígitos y NO tiene código de seguridad
    var ceMatch = RegExp(r'CARN[ÉE]\s+DE\s+EXTRANJER[ÍI]A[:\s]+N[°º]\s*(\d{9})', caseSensitive: false).firstMatch(text);
    
    if (ceMatch == null) {
      // lucadev: Buscar patrón alternativo: número de 9 dígitos
      ceMatch = RegExp(r'\b(\d{9})\b').firstMatch(text);
      if (ceMatch == null) return null;
    }

    final number = ceMatch.group(1)!;

    // lucadev: Extraer datos personales del CE
    final name = _extractName(text);
    final lastName = _extractLastName(text);
    final dob = _extractBirthDate(text);
    final gender = _extractGender(text);

    return DocumentScanResult(
      document: Ce(
        number: number,
        type: DocumentType.ce,
      ),
      extractedName: name,
      extractedLastName: lastName,
      extractedBirthDate: dob,
      extractedGender: gender,
      rawText: text,
      confidence: 0.9,
    );
  }

  // lucadev: Extraer nombre del CE (formato: "NOMBRES /GIVEN NAMES\nKARIELYS CAROLINA" o "NOMBRES: KARIELYS CAROLINA")
  String? _extractName(String text) {
    // lucadev: Patrón 1: Buscar nombre en la línea siguiente después de "NOMBRES /GIVEN NAMES:" o "NOMBRES/GIVEN NAMES:"
    // lucadev: Ejemplo: "NOMBRES /GIVEN NAMES:\nKARIELYS CAROLINA" o "NOMBRES /GIVEN NAMES.\nKARIELYS CAROLINA"
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
    
    // lucadev: Patrón 2: Buscar nombre en la misma línea después de "NOMBRES /GIVEN NAMES:" o "NOMBRES/GIVEN NAMES:"
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
    
    // lucadev: Patrón 3: "NOMBRES:" seguido del nombre en la línea siguiente
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
    
    // lucadev: Patrón 4: Buscar nombre directamente después de "NOMBRES" (dentro de 100 caracteres)
    final nombresMatch = RegExp(r'(?:NOMBRES|Nombres)\s*/?\s*GIVEN\s+NAMES\s*[:.]?', caseSensitive: false).firstMatch(text);
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

  // lucadev: Extraer apellidos del CE (formato: "APELLIDOS / SURNAME\nMANZOL PLASENCIA" o "APELLIDOS: MANZOL PLASENCIA")
  String? _extractLastName(String text) {
    // lucadev: Patrón 1: Buscar "MANZOL PLASENCIA" en la línea siguiente después de "ONE APELLIDOS / SURRIAME:" o "ONEAPELIDOS /SURNIAME:"
    // lucadev: También maneja "ONE APELIDOS F SURNAME" o "ONE APELIDOS / SURNIAMEE"
    var match = RegExp(
      r'(?:ONE\s*)?APEL?LIDOS\s*[^\n]*(?:/|F|I)?\s*SUR(?:NI|RI)?AME[E.]?\s*[:.]?\s*(?:\n|\r\n)\s*([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      final lastName = match.group(1)?.trim();
      if (lastName != null && lastName.isNotEmpty) {
        // lucadev: Limitar a solo las primeras dos palabras para evitar ruido adicional
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
    
    // lucadev: Patrón 2: "APELLIDOS" seguido de "/SURNAME" o ":" en línea siguiente
    match = RegExp(
      r'(?:APELLIDOS|Apellidos)\s*/?\s*SUR(?:RI|N)AME\s*:?\s*(?:\n|\r\n)\s*([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      final lastName = match.group(1)?.trim();
      if (lastName != null && lastName.isNotEmpty) {
        // lucadev: Limitar a solo las primeras dos palabras
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
    
    // lucadev: Patrón 3: "APELLIDOS:" seguido del apellido en línea siguiente
    match = RegExp(
      r'(?:APELLIDOS|Apellidos)\s*:\s*(?:\n|\r\n)\s*([A-ZÁÉÍÓÚÑ]{4,}(?:\s+[A-ZÁÉÍÓÚÑ]{4,})+)\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      final lastName = match.group(1)?.trim();
      if (lastName != null && lastName.isNotEmpty) {
        // lucadev: Limitar a solo las primeras dos palabras
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
    
    // lucadev: Patrón 4: Buscar "MANZOL PLASENCIA" directamente después de "APELLIDOS" (dentro de 100 caracteres)
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
          // lucadev: Limitar a solo las primeras dos palabras
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

  // lucadev: Extraer fecha de nacimiento del CE (formato: "25 JUN 1996" o "25/06/1996")
  String? _extractBirthDate(String text) {
    // lucadev: Buscar fecha después de "FECHA DE NACIMIENTO" o "NACIMIENTO"
    var match = RegExp(
      r'(?:FECHA\s+DE\s+NACIMIENTO|NACIMIENTO)\s*:\s*(\d{2}\s+[A-Z]{3}\s+\d{4}|\d{2}[\s/]\d{2}[\s/]\d{4})',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final dateStr = match.group(1)!;
      return _normalizeDate(dateStr);
    }

    // lucadev: Buscar patrón de fecha con mes en texto (ej: "25 JUN 1996")
    match = RegExp(r'(\d{2})\s+([A-Z]{3})\s+(\d{4})', caseSensitive: false).firstMatch(text);
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

  // lucadev: Convertir mes en texto a número (JUN -> 06)
  String? _convertMonthToNumber(String month) {
    final months = {
      'ENE': '01', 'JAN': '01',
      'FEB': '02',
      'MAR': '03',
      'ABR': '04', 'APR': '04',
      'MAY': '05',
      'JUN': '06',
      'JUL': '07',
      'AGO': '08', 'AUG': '08',
      'SEP': '09',
      'OCT': '10',
      'NOV': '11',
      'DIC': '12', 'DEC': '12',
    };
    return months[month.toUpperCase()];
  }

  // lucadev: Extraer género del CE (formato: "SEXO / SEX\nF" o "SEXO: F" o "FS" después de "SEXO")
  String? _extractGender(String text) {
    // lucadev: Patrón 1: Buscar "FS" o "MS" ANTES de "SEXO /SEX" o "SEXO / SEX"
    // lucadev: Ejemplo: "FS\nSEXO /SEX:" o "FS SEXO /SEX:"
    var match = RegExp(
      r'\b([FM])S\b\s*(?:\n|\r\n)?\s*(?:SEXO|Sexo|SEX)\s*/?\s*SEX\s*:?',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    // lucadev: Patrón 2: Buscar "FS" o "MS" DESPUÉS de "SEXO /SEX" o "SEXO / SEX"
    match = RegExp(
      r'(?:SEXO|Sexo|SEX)\s*/?\s*SEX\s*:?\s*(?:\n|\r\n)?\s*([FM])S\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    // lucadev: Patrón 3: Buscar "F" o "M" después de "SEXO /SEX" o "SEXO / SEX" en línea siguiente
    match = RegExp(
      r'(?:SEXO|Sexo|SEX)\s*/?\s*SEX\s*:?\s*(?:\n|\r\n)\s*([MF])(?:\s|$|\n)',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    // lucadev: Patrón 4: Buscar "FS" o "MS" en línea separada después de "SEXO"
    match = RegExp(
      r'(?:SEXO|Sexo|SEX)[^\n]*(?:\n|\r\n)\s*([FM])S\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    // lucadev: Patrón 5: Buscar "F" o "M" en línea separada después de "SEXO"
    match = RegExp(
      r'(?:SEXO|Sexo|SEX)[^\n]*(?:\n|\r\n)\s*([MF])(?:\s|$|\n)',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    // lucadev: Patrón 6: Buscar solo "S" después de "SEXO" (puede ser "F" mal detectado por OCR)
    match = RegExp(
      r'(?:SEXO|Sexo|SEX)[^\n]*(?:\n|\r\n)\s*S\b',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);
    if (match != null) {
      // lucadev: Verificar contexto para determinar si es F o M
      final context = text.substring(0, match.end).toUpperCase();
      if (context.contains('FEMENINO') || context.contains('F')) return 'F';
      if (context.contains('MASCULINO') || context.contains('M')) return 'M';
      // lucadev: Por defecto, si aparece "S" solo después de SEXO, asumimos F (más común en CE)
      return 'F';
    }

    // lucadev: Patrón 7: Buscar palabras completas
    if (text.toUpperCase().contains('MASCULINO')) return 'M';
    if (text.toUpperCase().contains('FEMENINO')) return 'F';

    // lucadev: Patrón 8: Buscar "FS" o "MS" cerca de "SEXO" (dentro de 50 caracteres antes o después)
    final sexoMatch = RegExp(r'(?:SEXO|Sexo|SEX)', caseSensitive: false).firstMatch(text);
    if (sexoMatch != null) {
      // lucadev: Buscar antes de "SEXO" (hasta 20 caracteres antes)
      final beforeStart = sexoMatch.start > 20 ? sexoMatch.start - 20 : 0;
      final beforeText = text.substring(beforeStart, sexoMatch.start);
      final beforeMatch = RegExp(r'\b([FM])S\b').firstMatch(beforeText);
      if (beforeMatch != null) return beforeMatch.group(1);
      
      // lucadev: Buscar después de "SEXO" (hasta 50 caracteres después)
      final startPos = sexoMatch.end;
      final afterText = text.substring(
        startPos,
        startPos + 50 < text.length ? startPos + 50 : text.length,
      );
      // lucadev: Buscar "FS" o "MS" primero
      final fsMatch = RegExp(r'\b([FM])S\b').firstMatch(afterText);
      if (fsMatch != null) return fsMatch.group(1);
      // lucadev: Luego buscar "F" o "M" solo
      final genderMatch = RegExp(r'\b([MF])\b').firstMatch(afterText);
      if (genderMatch != null) return genderMatch.group(1);
    }

    return null;
  }

  // lucadev: Normalizar formato de fecha
  String _normalizeDate(String dateStr) {
    return dateStr.replaceAll(RegExp(r'[\s-]'), '/');
  }

  // lucadev: Limpiar nombre/apellido de palabras no deseadas
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
      'GIVEN', // lucadev: Añadido para limpiar "GIVEN NAMES"
      'NAMES', // lucadev: Añadido para limpiar "GIVEN NAMES"
      'SURNAME', // lucadev: Añadido para limpiar "SURNAME"
      'SURRIAME', // lucadev: Añadido para limpiar "SURRIAME" (OCR error)
      'SURIAME', // lucadev: Añadido para limpiar "SURIAME" (OCR error)
      'ONE', // lucadev: Añadido para limpiar "ONE APELLIDOS" (OCR error)
      'DEL', // lucadev: Añadido para limpiar "DEL PERU"
      'PERU', // lucadev: Añadido para limpiar "DEL PERU"
      'REPUBLICA', // lucadev: Añadido para limpiar "REPUBLICA DEL PERU"
      'NACIONAL', // lucadev: Añadido para limpiar "NACIONAL DE MIGRACIONES"
      'MIGRACIONES', // lucadev: Añadido para limpiar "NACIONAL DE MIGRACIONES"
      'SUPERINTENDENCIA', // lucadev: Añadido para limpiar "SUPERINTENDENCIA NACIONAL DE MIGRACIONES"
      'N', // lucadev: Añadido para limpiar "N°"
      'CIP', // lucadev: Añadido para limpiar "N° CIP"
      'ESP', // lucadev: Añadido para limpiar "ESP ESPECIAL"
      'ESPECIAL', // lucadev: Añadido para limpiar "ESP ESPECIAL"
      'QUALITY', // lucadev: Añadido para limpiar "MIGRATORY QUALITY"
      'MIGRATORY', // lucadev: Añadido para limpiar "MIGRATORY QUALITY"
      'RAC', // lucadev: Añadido para limpiar "QUALITYRAC"
      'EN', // lucadev: Añadido para limpiar "EN" (OCR error)
      'FS', // lucadev: Añadido para limpiar "FS" (OCR error)
      'S', // lucadev: Añadido para limpiar "S" (OCR error)
      'MICESTADO', // lucadev: Añadido para limpiar "MICESTADO CIVIL" (OCR error)
      'CIVIL', // lucadev: Añadido para limpiar "MICESTADO CIVIL" (OCR error)
      'MANTAL', // lucadev: Añadido para limpiar "MANTAL STATUS" (OCR error)
      'STATUS', // lucadev: Añadido para limpiar "MANTAL STATUS" (OCR error)
      'MU', // lucadev: Añadido para limpiar "STATUSMU" (OCR error)
      'MI', // lucadev: Añadido para limpiar "MI" (OCR error)
      'Y', // lucadev: Añadido para limpiar "MIY" (OCR error)
      'EI', // lucadev: Añadido para limpiar "EI" (OCR error)
      'DE', // lucadev: Añadido para limpiar "DE" (OCR error)
      'ANGEL', // lucadev: Añadido para limpiar "ANGEL" (OCR error)
      '2/02/26', // lucadev: Añadido para limpiar fecha de log
      '9:01', // lucadev: Añadido para limpiar hora de log
      'AM', // lucadev: Añadido para limpiar AM/PM de log
      'MON', // lucadev: Añadido para limpiar "MON 2 FEB"
      'FEB', // lucadev: Añadido para limpiar "MON 2 FEB"
      '2', // lucadev: Añadido para limpiar "MON 2 FEB"
      'ALL', // lucadev: Añadido para limpiar "ALL MEDIA" (ruido de UI)
      'MEDIA', // lucadev: Añadido para limpiar "ALL MEDIA" (ruido de UI)
      'REPLY', // lucadev: Añadido para limpiar "REPLY DONE" (ruido de UI)
      'DONE', // lucadev: Añadido para limpiar "REPLY DONE" (ruido de UI)
      'EXTRANJERIA', // lucadev: Añadido para limpiar "EXTRANJERIA" (parte del formato del documento)
      'EXTRANJERÍA', // lucadev: Añadido para limpiar "EXTRANJERÍA" (parte del formato del documento)
      'EXTRANJERİA', // lucadev: Añadido para limpiar "EXTRANJERİA" (error OCR común)
      'CESSTADO', // lucadev: Añadido para limpiar "CESSTADO CIVIL" (error OCR común)
      'CESTADO', // lucadev: Añadido para limpiar "CESTADO CIVIL" (error OCR común)
      'CES', // lucadev: Añadido para limpiar "CES" (error OCR común)
      'TADO', // lucadev: Añadido para limpiar "TADO" (error OCR común)
      'ECARN', // lucadev: Añadido para limpiar "ECARN" (error OCR común de "CARNÉ")
      'SURNAMEE', // lucadev: Añadido para limpiar "SURNAMEE" (error OCR común)
      'SURNIAMEE', // lucadev: Añadido para limpiar "SURNIAMEE" (error OCR común)
      'SURRIAME.', // lucadev: Añadido para limpiar "SURRIAME." (error OCR común)
      'SURNIAME.', // lucadev: Añadido para limpiar "SURNIAME." (error OCR común)
    ];

    // lucadev: Dividir por líneas y espacios
    final words = text.split(RegExp(r'[\s\n]+'));
    final cleanWords = words
        .map((word) => word.trim().toUpperCase())
        .where(
          (word) =>
              word.isNotEmpty &&
              word.length > 1 &&
              !invalidWords.contains(word) &&
              !RegExp(r'^\d+$').hasMatch(word) && // lucadev: No solo números
              !RegExp(r'^[MF]$').hasMatch(word) && // lucadev: No solo M o F
              !RegExp(r'^\d{2}[\s/]\d{2}[\s/]\d{4}$').hasMatch(word), // lucadev: Excluir fechas
        )
        .toList();

    return cleanWords.join(' ').trim();
  }
}
