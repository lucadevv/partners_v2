import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/features/auth/document_scan/domain/parser/document_parser.dart';

class DniParser implements DocumentParser {
  @override
  DocumentScanResult? parse(String text) {
    // lucadev: Buscar número de DNI de 8 dígitos con código de seguridad (ej: 73694046-4)
    // lucadev: El código de seguridad es requerido para DNI
    var dniMatch = RegExp(r'\b(\d{8})-(\d)\b').firstMatch(text);
    String securityCode = '';
    
    if (dniMatch == null) {
      // lucadev: Si no encuentra con guion, intentar buscar solo el número de 8 dígitos
      // lucadev: Pero el código de seguridad es requerido, así que intentamos buscarlo por separado
      dniMatch = RegExp(r'\b(\d{8})\b').firstMatch(text);
      if (dniMatch == null) return null;
      
      // lucadev: Buscar código de seguridad cerca del número DNI (patrón: número-guión-dígito)
      final securityMatch = RegExp(r'(\d{8})[-\s]+(\d)').firstMatch(text);
      if (securityMatch != null && securityMatch.group(1) == dniMatch.group(1)) {
        securityCode = securityMatch.group(2) ?? '';
      }
      
      // lucadev: Si aún no se encuentra, retornar null porque el código de seguridad es requerido
      if (securityCode.isEmpty) return null;
    } else {
      // lucadev: Si encontró con guion, extraer el código de seguridad
      securityCode = dniMatch.group(2) ?? '';
      if (securityCode.isEmpty) return null; // lucadev: Código de seguridad requerido
    }

    final number = dniMatch.group(1)!;

    final name = _extractName(text);
    final lastName = _extractLastName(text);
    final dob = _extractBirthDate(text);
    final gender = _extractGender(text);
    final expiryDate = _extractExpiryDate(text);

    return DocumentScanResult(
      document: Dni(
        number: number,
        type: DocumentType.dni,
        securityCode: securityCode,
        expiryDate: expiryDate,
      ),
      extractedName: name,
      extractedLastName: lastName,
      extractedBirthDate: dob,
      extractedGender: gender,
      rawText: text,
      confidence: 0.9,
    );
  }

  bool isComplete(DocumentScanResult result) {
    if (result.document.number.isEmpty) return false;

    return result.extractedName != null &&
        result.extractedName!.isNotEmpty &&
        result.extractedLastName != null &&
        result.extractedLastName!.isNotEmpty &&
        result.extractedBirthDate != null &&
        result.extractedBirthDate!.isNotEmpty;
  }

  String? _extractName(String text) {
    // lucadev: Buscar nombre - línea inmediatamente anterior a "PRENOMBRES"
    // lucadev: Ejemplo: "LUIS IVAN\nPRENOMBRES" - capturar solo "LUIS IVAN"
    var match = RegExp(
      r'([A-ZÁÉÍÓÚÑ]+(?:\s+[A-ZÁÉÍÓÚÑ]+)*)\s*\n\s*(?:PRENOMBRES|Prenombres)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final name = match.group(1)?.trim();
      if (name != null && name.isNotEmpty) {
        final cleaned = _cleanName(name);
        if (cleaned.isNotEmpty && cleaned.length > 2) {
          return cleaned;
        }
      }
    }

    // lucadev: Patrón alternativo más flexible para el nombre
    match = RegExp(
      r'([A-ZÁÉÍÓÚÑ]+(?:\s+[A-ZÁÉÍÓÚÑ]+)+)\s*(?:\n|\r\n)\s*(?:PRENOMBRES|Prenombres)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final name = match.group(1)?.trim();
      if (name != null && name.isNotEmpty) {
        final cleaned = _cleanName(name);
        if (cleaned.isNotEmpty && cleaned.length > 2) {
          return cleaned;
        }
      }
    }

    // lucadev: Alternativa: buscar "NOMBRES:" seguido del nombre
    match = RegExp(
      r'(?:NOMBRES|Nombres)\s*:\s*([A-ZÁÉÍÓÚÑ\s]+)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final name = match.group(1)?.trim();
      if (name != null && name.isNotEmpty) {
        final cleaned = _cleanName(name);
        if (cleaned.isNotEmpty && cleaned.length > 2) {
          return cleaned;
        }
      }
    }

    return null;
  }

  String? _extractLastName(String text) {
    // lucadev: Buscar primer apellido - línea inmediatamente anterior a "PRIMER APELLIDO"
    // lucadev: Ejemplo: "CARRANZA\nPRIMER APELLIDO" - capturar solo "CARRANZA"
    final primerMatch = RegExp(
      r'^([A-ZÁÉÍÓÚÑ]+)\s*$\n\s*(?:PRIMER|Primer)\s+(?:APELLIDO|Apellido)',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);

    // lucadev: Buscar segundo apellido - línea inmediatamente anterior a "SEGUNDO APELLIDO"
    // lucadev: Ejemplo: "SALDAÑA\nSEGUNDO APELLIDO" - capturar solo "SALDAÑA"
    final segundoMatch = RegExp(
      r'^([A-ZÁÉÍÓÚÑ]+)\s*$\n\s*(?:SEGUNDO|Segundo)\s+(?:APELLIDO|Apellido)',
      caseSensitive: false,
      multiLine: true,
    ).firstMatch(text);

    String? primerApellido;
    String? segundoApellido;

    if (primerMatch != null) {
      final raw = primerMatch.group(1)?.trim();
      if (raw != null && raw.isNotEmpty) {
        // lucadev: Limpiar el apellido de palabras no deseadas
        primerApellido = _cleanLastName(raw);
        if (primerApellido.isEmpty ||
            primerApellido.length < 2 ||
            RegExp(r'^\d+$').hasMatch(primerApellido)) {
          primerApellido = null;
        }
      }
    }

    // lucadev: Si no se encontró con el patrón estricto, intentar uno más flexible
    if (primerApellido == null) {
      final flexibleMatch = RegExp(
        r'([A-ZÁÉÍÓÚÑ]+)\s*(?:\n|\r\n)\s*(?:PRIMER|Primer)\s+(?:APELLIDO|Apellido)',
        caseSensitive: false,
      ).firstMatch(text);
      if (flexibleMatch != null) {
        final raw = flexibleMatch.group(1)?.trim();
        if (raw != null && raw.isNotEmpty) {
          primerApellido = _cleanLastName(raw);
          if (primerApellido.isEmpty ||
              primerApellido.length < 2 ||
              RegExp(r'^\d+$').hasMatch(primerApellido)) {
            primerApellido = null;
          }
        }
      }
    }

    if (segundoMatch != null) {
      final raw = segundoMatch.group(1)?.trim();
      if (raw != null && raw.isNotEmpty) {
        // lucadev: Limpiar el apellido de palabras no deseadas
        segundoApellido = _cleanLastName(raw);
        if (segundoApellido.isEmpty ||
            segundoApellido.length < 2 ||
            RegExp(r'^\d+$').hasMatch(segundoApellido)) {
          segundoApellido = null;
        }
      }
    }

    // lucadev: Si no se encontró con el patrón estricto, intentar uno más flexible
    if (segundoApellido == null) {
      final flexibleMatch = RegExp(
        r'([A-ZÁÉÍÓÚÑ]+)\s*(?:\n|\r\n)\s*(?:SEGUNDO|Segundo)\s+(?:APELLIDO|Apellido)',
        caseSensitive: false,
      ).firstMatch(text);
      if (flexibleMatch != null) {
        final raw = flexibleMatch.group(1)?.trim();
        if (raw != null && raw.isNotEmpty) {
          segundoApellido = _cleanLastName(raw);
          if (segundoApellido.isEmpty ||
              segundoApellido.length < 2 ||
              RegExp(r'^\d+$').hasMatch(segundoApellido)) {
            segundoApellido = null;
          }
        }
      }
    }

    // lucadev: Combinar apellidos en el orden correcto: primer apellido + segundo apellido
    if (primerApellido != null && segundoApellido != null) {
      return '$primerApellido $segundoApellido';
    } else if (primerApellido != null) {
      return primerApellido;
    } else if (segundoApellido != null) {
      return segundoApellido;
    }

    // lucadev: Alternativa: buscar "APELLIDOS:" seguido de los apellidos
    final genericMatch = RegExp(
      r'(?:APELLIDOS|Apellidos)\s*:\s*([A-ZÁÉÍÓÚÑ\s]+)',
      caseSensitive: false,
    ).firstMatch(text);
    if (genericMatch != null) {
      final apellidos = genericMatch.group(1)?.trim();
      if (apellidos != null && apellidos.isNotEmpty) {
        final cleaned = _cleanLastName(apellidos);
        if (cleaned.isNotEmpty && cleaned.length > 2) {
          return cleaned;
        }
      }
    }

    return null;
  }

  // lucadev: Método específico para limpiar apellidos, más estricto que _cleanName
  String _cleanLastName(String text) {
    final invalidWords = [
      'APELLIDO',
      'PRIMER',
      'SEGUNDO',
      'TARJETA',
      'FECHA',
      'ESTADO',
      'SEXO',
      'NACIONALIDAD',
      'DOCUMENTO',
      'REGISTRO',
      'REPÚBLICA',
      'CUI',
      'PER',
      'SOLTERO',
      'NACIMIENTO',
      'EMISIÓN',
      'CADUCIDAD',
      'CIVIL',
      'IDENTIFICACIÓN',
      'NACIONAL',
      'DEL',
      'PERÚ',
      'PERU',
      'NOMBRE',
      'PRENOMBRE',
      'PRENOMBRES',
      'LUIS',
      'IVAN',
      'DOC',
      'IDENTIDAD',
      'DNI',
      'FIRMA',
      'FOTO',
      'SEÑAL',
      'PUB',
      'Y',
      'DE',
      'EL',
      'LA',
      'LOS',
      'LAS',
    ];

    // lucadev: Dividir por espacios y filtrar palabras inválidas
    final words = text.split(RegExp(r'[\s\n]+'));
    final cleanWords = words
        .map((word) => word.trim().toUpperCase())
        .where(
          (word) =>
              word.isNotEmpty &&
              word.length > 1 &&
              !invalidWords.contains(word) &&
              !RegExp(r'^\d+$').hasMatch(word) &&
              !RegExp(r'^[MF]$').hasMatch(word) &&
              !RegExp(r'^\d{2}[\s/]\d{2}[\s/]\d{4}$').hasMatch(word),
        )
        .toList();

    return cleanWords.join(' ').trim();
  }

  String? _extractBirthDate(String text) {
    // lucadev: Buscar fecha de nacimiento después de "FECHA DE NACIMIENTO" o "NACIMIENTO"
    var match = RegExp(
      r'(?:FECHA\s+DE\s+NACIMIENTO|NACIMIENTO|Fecha\s+de\s+Nacimiento)\s*(?:\n|\r\n)?\s*(\d{2}[\s/]\d{2}[\s/]\d{4})',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final date = _normalizeDate(match.group(1)!);

      if (_isValidBirthDate(date)) return date;
    }

    // lucadev: Buscar fecha antes de "NACIONALIDAD FECHA DE NACIMIENTO"
    match = RegExp(
      r'(\d{2}[\s/]\d{2}[\s/]\d{4})\s*(?:\n|\r\n)\s*NACIONALIDAD\s+FECHA\s+DE\s+NACIMIENTO',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final date = _normalizeDate(match.group(1)!);
      if (_isValidBirthDate(date)) return date;
    }

    // lucadev: Buscar fecha en el contexto de "PER" seguido de fecha
    match = RegExp(
      r'PER\s+(\d{2}[\s/]\d{2}[\s/]\d{4})',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final date = _normalizeDate(match.group(1)!);
      if (_isValidBirthDate(date)) return date;
    }

    // lucadev: Buscar todas las fechas y encontrar la que sea más probable fecha de nacimiento
    final allDates = RegExp(r'(\d{2}[\s/]\d{2}[\s/]\d{4})').allMatches(text);
    for (final dateMatch in allDates) {
      final dateStr = dateMatch.group(1)!;
      final startPos = dateMatch.start;
      final endPos = dateMatch.end;

      final contextBefore = text
          .substring(startPos > 50 ? startPos - 50 : 0, startPos)
          .toUpperCase();
      final contextAfter = text
          .substring(
            endPos,
            endPos + 50 < text.length ? endPos + 50 : text.length,
          )
          .toUpperCase();

      if (!contextBefore.contains('CADUCIDAD') &&
          !contextAfter.contains('CADUCIDAD') &&
          !contextBefore.contains('EMISIÓN') &&
          !contextAfter.contains('EMISIÓN') &&
          !contextBefore.contains('FECHA DE EMISIÓN') &&
          !contextAfter.contains('FECHA DE EMISIÓN') &&
          !contextBefore.contains('FECHA DE CADUCIDAD') &&
          !contextAfter.contains('FECHA DE CADUCIDAD')) {
        final date = _normalizeDate(dateStr);
        if (_isValidBirthDate(date)) return date;
      }
    }

    return null;
  }

  // lucadev: Valida si una fecha es una fecha de nacimiento razonable (año entre 1900 y 2010)
  bool _isValidBirthDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length != 3) return false;
      final year = int.tryParse(parts[2]);
      if (year == null) return false;

      return year >= 1900 && year <= 2010;
    } catch (e) {
      return false;
    }
  }

  String? _extractExpiryDate(String text) {
    // lucadev: Buscar fecha de caducidad después de "CADUCIDAD" o "EXPEDICIÓN"
    final match = RegExp(
      r'(?:CADUCIDAD|EXPEDICIÓN)\s*\n?\s*(\d{2}[\s/]\d{2}[\s/]\d{4})',
      caseSensitive: false,
    ).firstMatch(text);

    if (match != null) {
      return _normalizeDate(match.group(1)!);
    }

    return null;
  }

  String? _extractGender(String text) {
    // lucadev: Buscar "M" o "F" después de "SEXO"
    var match = RegExp(
      r'(?:SEXO|Sexo)\s*(?:\n|\r\n)?\s*([MF])',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    // lucadev: Buscar "M" o "F" en el contexto "980758 M" (formato común en DNI peruanos)
    match = RegExp(r'\d{6}\s+([MF])(?:\s|$|\n)').firstMatch(text);
    if (match != null) return match.group(1);

    // lucadev: Patrón más flexible: número seguido de espacio y M o F
    match = RegExp(r'\d+\s+([MF])(?:\s|$|\n)').firstMatch(text);
    if (match != null) return match.group(1);

    // lucadev: Buscar "M" o "F" que esté en una línea separada después de "SEXO"
    match = RegExp(
      r'(?:SEXO|Sexo)\s*(?:\n|\r\n)\s*([MF])(?:\s|$|\n)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    // lucadev: Buscar palabras completas
    if (text.toUpperCase().contains('MASCULINO')) return 'M';
    if (text.toUpperCase().contains('FEMENINO')) return 'F';

    return null;
  }

  // lucadev: Normaliza el formato de fecha (convierte espacios y guiones a barras)
  String _normalizeDate(String dateStr) {
    return dateStr.replaceAll(RegExp(r'[\s-]'), '/');
  }

  // lucadev: Limpia el nombre de palabras no deseadas
  String _cleanName(String text) {
    final invalidWords = [
      'APELLIDO',
      'PRIMER',
      'SEGUNDO',
      'TARJETA',
      'FECHA',
      'ESTADO',
      'SEXO',
      'NACIONALIDAD',
      'DOCUMENTO',
      'REGISTRO',
      'REPÚBLICA',
      'CUI',
      'PER',
      'SOLTERO',
      'NACIMIENTO',
      'EMISIÓN',
      'CADUCIDAD',
      'CIVIL',
      'IDENTIFICACIÓN',
      'NACIONAL',
      'DEL',
      'PERÚ',
      'PERU',
      'NOMBRE',
      'PRENOMBRE',
      'PRENOMBRES',
      'DOC',
      'IDENTIDAD',
      'DNI',
      'FIRMA',
      'FOTO',
      'SEÑAL',
      'PUB',
      'Y',
      'DE',
      'EL',
      'LA',
      'LOS',
      'LAS',
    ];

    final words = text.split(RegExp(r'[\s\n]+'));
    final cleanWords = words
        .map((word) => word.trim().toUpperCase())
        .where(
          (word) =>
              word.isNotEmpty &&
              word.length > 1 &&
              !invalidWords.contains(word) &&
              !RegExp(r'^\d+$').hasMatch(word) &&
              !RegExp(r'^[MF]$').hasMatch(word) &&
              !RegExp(r'^\d{2}[\s/]\d{2}[\s/]\d{4}$').hasMatch(word),
        )
        .toList();

    return cleanWords.join(' ').trim();
  }
}
