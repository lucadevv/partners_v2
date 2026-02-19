import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/features/auth/document_scan/data/models/document_scan_result.dart';
import 'package:partners/features/auth/document_scan/domain/parser/document_parser.dart';

class DniParser implements DocumentParser {
  @override
  DocumentScanResult? parse(String text) {
    // 1. LIMPIEZA PREFIJO
    final cleanText = text.replaceAll(RegExp(r'lucadev\d+\s*'), '');

    // 2. FILTRO DE BASURA (Sanity Check) - Rechazar texto ilegible inmediatamente
    if (!_isValidOcrText(cleanText)) {
      return null; // Descartar inmediatamente sin procesar Regex
    }

    String securityCode = '';
    String? number;

    // 3. Intentar primero con formato estándar (8 dígitos + guion + 1 dígito)
    // Este formato funciona para DNI modernos - NO TOCAR
    var dniMatch = RegExp(r'\b(\d{8})-(\d)\b').firstMatch(cleanText);
    if (dniMatch != null) {
      number = dniMatch.group(1);
      securityCode = dniMatch.group(2) ?? '';
    } else {
      // 4. Intentar formato sin guion pero con espacio o separador
      dniMatch = RegExp(r'(\d{8})[-\s]+(\d)').firstMatch(cleanText);
      if (dniMatch != null) {
        number = dniMatch.group(1);
        securityCode = dniMatch.group(2) ?? '';
      } else {
        // 5. Intentar formato MRZ (documentos antiguos/azules)
        // Optimización: Solo intentar MRZ si el texto contiene "PER"
        if (!cleanText.contains('PER') && !cleanText.contains('PERU')) {
          // Si no menciona PERU, no perder tiempo buscando formato MRZ antiguo
          final dniOnlyMatch = RegExp(r'\b(\d{8})\b').firstMatch(cleanText);
          if (dniOnlyMatch == null) return null;

          number = dniOnlyMatch.group(1);
          if (number == null) return null;
          securityCode = _extractSecurityCodeFromMrz(cleanText, number);
          if (securityCode.isEmpty) {
            return null;
          }
        } else {
          // El texto contiene "PER", intentar extraer del formato MRZ
          number = _extractDniFromMrz(cleanText);
          if (number != null) {
            securityCode = _extractSecurityCodeFromMrz(cleanText, number);
            if (securityCode.isEmpty) {
              // Si no encontramos el código, intentar buscar solo el número
              // y luego buscar el código cerca
              final dniOnlyMatch = RegExp(r'\b(\d{8})\b').firstMatch(cleanText);
              if (dniOnlyMatch != null) {
                number = dniOnlyMatch.group(1);
                securityCode = _extractSecurityCodeFromMrz(cleanText, number!);
                if (securityCode.isEmpty) {
                  return null;
                }
              } else {
                return null;
              }
            }
          } else {
            // Último intento: buscar cualquier secuencia de 8 dígitos
            final dniOnlyMatch = RegExp(r'\b(\d{8})\b').firstMatch(cleanText);
            if (dniOnlyMatch == null) return null;

            number = dniOnlyMatch.group(1);
            if (number == null) return null;
            securityCode = _extractSecurityCodeFromMrz(cleanText, number);
            if (securityCode.isEmpty) {
              return null;
            }
          }
        }
      }
    }

    if (number == null || number.isEmpty) {
      return null;
    }

    final lastName = _extractLastName(cleanText);
    final name = _extractName(cleanText, lastName);
    final dob = _extractBirthDate(cleanText);
    final gender = _extractGender(cleanText);
    final expiryDate = _extractExpiryDate(cleanText);

    final result = DocumentScanResult(
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
    print(
      'lucadev [DNI] parsed frame: number=$number-$securityCode '
      'surnames=$lastName names=$name dob=$dob expiry=$expiryDate gender=$gender',
    );
    return result;
  }

  /// Verifica si el texto parece legible antes de intentar parsear
  /// Rechaza texto basura inmediatamente para evitar procesar Regex innecesarios
  bool _isValidOcrText(String text) {
    if (text.length < 30) return false; // Muy corto, probablemente basura

    // Contar caracteres basura vs letras
    final garbageCount = RegExp(r'[<>\\\/|]').allMatches(text).length;
    final letterCount = RegExp(r'[A-ZÑÁÉÍÓÚ]').allMatches(text).length;

    // Si hay muy pocas letras, probablemente sea basura
    if (letterCount < 10) return false;

    // Solo rechazar si hay MUCHOS más caracteres basura que letras
    // (permitir algunos caracteres basura porque el MRZ los tiene)
    if (garbageCount > letterCount * 0.8) return false;

    // Detección de ruido extremo (ej: "CARRANEAKKLWtSC")
    // Si hay muchas consonantes repetidas juntas sin vocales, probablemente sea ruido
    // Pero ser más permisivo porque "CARRANZA" tiene muchas consonantes
    final consonantClusters = RegExp(
      r'[BCDFGHJKLMNPQRSTVWXYZ]{6,}',
    ).allMatches(text);
    if (consonantClusters.length > 3) {
      // Si hay más de 3 clusters de consonantes muy largos, probablemente sea ruido
      return false;
    }

    // Verificar que haya al menos algunos números (DNI siempre tiene números)
    final digitCount = RegExp(r'\d').allMatches(text).length;
    if (digitCount < 8) return false; // DNI mínimo tiene 8 dígitos

    return true;
  }

  /// Extrae el número de DNI del formato MRZ (documentos antiguos)
  /// Maneja errores de OCR como caracteres corruptos y espacios variables
  String? _extractDniFromMrz(String text) {
    // Priorizar I<PER porque es el formato más común en documentos antiguos
    // Patrones ordenados de más específico a más flexible

    // 1. I<PER seguido directamente de 8 dígitos sin espacios (más común)
    var match = RegExp(r'I<PER(\d{8})<').firstMatch(text);
    if (match != null) {
      return match.group(1);
    }

    // 2. I<PER con espacios opcionales, 8 dígitos sin espacios
    match = RegExp(r'I\s*<\s*PER\s*(\d{8})\s*<').firstMatch(text);
    if (match != null) {
      return match.group(1);
    }

    // 3. I<PER seguido de número con espacios (casos comunes: 4+4, 5+3, 6+2, etc.)
    final spacePatterns = [
      r'I<PER\s*(\d{4})\s+(\d{4})\s*<', // 4+4
      r'I<PER\s*(\d{5})\s+(\d{3})\s*<', // 5+3
      r'I<PER\s*(\d{3})\s+(\d{5})\s*<', // 3+5
      r'I<PER\s*(\d{6})\s+(\d{2})\s*<', // 6+2
      r'I<PER\s*(\d{2})\s+(\d{6})\s*<', // 2+6
      r'I<PER\s*(\d{7})\s+(\d{1})\s*<', // 7+1
      r'I<PER\s*(\d{1})\s+(\d{7})\s*<', // 1+7
      // Casos con múltiples espacios (ej: 73694 0 46)
      r'I<PER\s*(\d{5})\s+(\d{1})\s+(\d{2})\s*<', // 5+1+2
      r'I<PER\s*(\d{4})\s+(\d{1})\s+(\d{3})\s*<', // 4+1+3
      r'I<PER\s*(\d{3})\s+(\d{1})\s+(\d{4})\s*<', // 3+1+4
      r'I<PER\s*(\d{6})\s+(\d{1})\s+(\d{1})\s*<', // 6+1+1
    ];

    for (final pattern in spacePatterns) {
      match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        // Manejar patrones con 2 o 3 grupos
        if (match.groupCount == 2) {
          return '${match.group(1)}${match.group(2)}';
        } else if (match.groupCount == 3) {
          return '${match.group(1)}${match.group(2)}${match.group(3)}';
        }
      }
    }

    // 4. I<PER con espacios opcionales y número con espacios
    for (final pattern in spacePatterns) {
      final flexiblePattern = pattern.replaceFirst('I<PER', r'I\s*<\s*PER');
      match = RegExp(flexiblePattern).firstMatch(text);
      if (match != null) {
        // Manejar patrones con 2 o 3 grupos
        if (match.groupCount == 2) {
          return '${match.group(1)}${match.group(2)}';
        } else if (match.groupCount == 3) {
          return '${match.group(1)}${match.group(2)}${match.group(3)}';
        }
      }
    }

    // 5. I<PER con patrón flexible que captura dígitos y espacios
    // Capturar hasta encontrar < seguido de un dígito (código de seguridad)
    match = RegExp(r'I\s*<\s*PER\s*([\d\s]+?)\s*<\s*\d').firstMatch(text);
    if (match != null) {
      final rawNumber = match.group(1)?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
      if (rawNumber.length == 8) {
        return rawNumber;
      }
    }

    // 5b. I<PER con patrón flexible (fallback sin código de seguridad)
    match = RegExp(r'I\s*<\s*PER\s*([\d\s]{8,20})\s*<').firstMatch(text);
    if (match != null) {
      final rawNumber = match.group(1)?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
      if (rawNumber.length == 8) {
        return rawNumber;
      }
    }

    // 6. PER sin I< seguido directamente de 8 dígitos sin espacios
    match = RegExp(r'PER(\d{8})<').firstMatch(text);
    if (match != null) {
      return match.group(1);
    }

    // 7. PER con espacios opcionales, 8 dígitos sin espacios
    match = RegExp(r'PER\s*(\d{8})\s*<').firstMatch(text);
    if (match != null) {
      return match.group(1);
    }

    // 8. PER seguido de número con un espacio (casos comunes)
    final perSpacePatterns = [
      r'PER\s*(\d{4})\s+(\d{4})\s*<', // 4+4
      r'PER\s*(\d{5})\s+(\d{3})\s*<', // 5+3
      r'PER\s*(\d{3})\s+(\d{5})\s*<', // 3+5
      r'PER\s*(\d{6})\s+(\d{2})\s*<', // 6+2
      r'PER\s*(\d{2})\s+(\d{6})\s*<', // 2+6
      r'PER\s*(\d{7})\s+(\d{1})\s*<', // 7+1
      r'PER\s*(\d{1})\s+(\d{7})\s*<', // 1+7
    ];

    for (final pattern in perSpacePatterns) {
      match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        return '${match.group(1)}${match.group(2)}';
      }
    }

    // 9. PER con patrón flexible
    match = RegExp(r'PER\s*([\d\s]{8,20})\s*<').firstMatch(text);
    if (match != null) {
      final rawNumber = match.group(1)?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
      if (rawNumber.length == 8) {
        return rawNumber;
      }
    }

    // 10. Manejar casos donde el OCR lee mal I< como otros caracteres
    // Buscar patrones como: 14PER, 1<PER, 1 PER, etc.
    match = RegExp(r'[0-9I1]\s*[<]?\s*PER\s*(\d{8})\s*<').firstMatch(text);
    if (match != null) {
      return match.group(1);
    }

    // 11. Patrón muy flexible para casos extremos de OCR corrupto
    match = RegExp(
      r'[0-9I1]\s*[<]?\s*PER\s*([\d\s]{8,20})\s*<',
    ).firstMatch(text);
    if (match != null) {
      final rawNumber = match.group(1)?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
      if (rawNumber.length == 8) {
        return rawNumber;
      }
    }

    return null;
  }

  /// Extrae el código de seguridad del formato MRZ
  String _extractSecurityCodeFromMrz(String text, String dniNumber) {
    final escapedDni = RegExp.escape(dniNumber);

    // 1. I<PER seguido del número y luego < y un dígito (más común)
    // Manejar múltiples < después del código
    var match = RegExp('I<PER$escapedDni<+\\s*(\\d)').firstMatch(text);
    if (match != null) {
      return match.group(1) ?? '';
    }

    // 2. I<PER con espacios opcionales
    match = RegExp(
      'I\\s*<\\s*PER\\s*$escapedDni\\s*<+\\s*(\\d)',
    ).firstMatch(text);
    if (match != null) {
      return match.group(1) ?? '';
    }

    // 3. I<PER con número que tiene espacios
    final spacePatterns = [
      r'I<PER\s*(\d{4})\s+(\d{4})\s*<+\s*(\d)',
      r'I<PER\s*(\d{5})\s+(\d{3})\s*<+\s*(\d)',
      r'I<PER\s*(\d{3})\s+(\d{5})\s*<+\s*(\d)',
      r'I<PER\s*(\d{6})\s+(\d{2})\s*<+\s*(\d)',
      r'I<PER\s*(\d{2})\s+(\d{6})\s*<+\s*(\d)',
      r'I<PER\s*(\d{7})\s+(\d{1})\s*<+\s*(\d)',
      r'I<PER\s*(\d{1})\s+(\d{7})\s*<+\s*(\d)',
      // Casos con múltiples espacios (ej: 73694 0 46)
      r'I<PER\s*(\d{5})\s+(\d{1})\s+(\d{2})\s*<+\s*(\d)',
      r'I<PER\s*(\d{4})\s+(\d{1})\s+(\d{3})\s*<+\s*(\d)',
      r'I<PER\s*(\d{3})\s+(\d{1})\s+(\d{4})\s*<+\s*(\d)',
      r'I<PER\s*(\d{6})\s+(\d{1})\s+(\d{1})\s*<+\s*(\d)',
    ];

    for (final pattern in spacePatterns) {
      match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        // Manejar patrones con 2 o 3 grupos de dígitos
        String mrzNumber;
        int codeGroupIndex;

        if (match.groupCount == 3) {
          // Patrón con 2 grupos de dígitos + 1 grupo de código
          mrzNumber = '${match.group(1)}${match.group(2)}';
          codeGroupIndex = 3;
        } else if (match.groupCount == 4) {
          // Patrón con 3 grupos de dígitos + 1 grupo de código
          mrzNumber = '${match.group(1)}${match.group(2)}${match.group(3)}';
          codeGroupIndex = 4;
        } else {
          continue;
        }

        if (mrzNumber == dniNumber) {
          return match.group(codeGroupIndex) ?? '';
        }
      }
    }

    // 4. I<PER con espacios opcionales y número con espacios
    for (final pattern in spacePatterns) {
      final flexiblePattern = pattern.replaceFirst('I<PER', r'I\s*<\s*PER');
      match = RegExp(flexiblePattern).firstMatch(text);
      if (match != null) {
        // Manejar patrones con 2 o 3 grupos de dígitos
        String mrzNumber;
        int codeGroupIndex;

        if (match.groupCount == 3) {
          // Patrón con 2 grupos de dígitos + 1 grupo de código
          mrzNumber = '${match.group(1)}${match.group(2)}';
          codeGroupIndex = 3;
        } else if (match.groupCount == 4) {
          // Patrón con 3 grupos de dígitos + 1 grupo de código
          mrzNumber = '${match.group(1)}${match.group(2)}${match.group(3)}';
          codeGroupIndex = 4;
        } else {
          continue;
        }

        if (mrzNumber == dniNumber) {
          return match.group(codeGroupIndex) ?? '';
        }
      }
    }

    // 5. I<PER con patrón flexible
    match = RegExp(r'I\s*<\s*PER\s*([\d\s]+?)\s*<+\s*(\d)').firstMatch(text);
    if (match != null) {
      final mrzNumber = match.group(1)?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
      if (mrzNumber == dniNumber) {
        return match.group(2) ?? '';
      }
    }

    // 6. PER sin I< seguido del número y luego < y un dígito
    match = RegExp('PER\\s*$escapedDni\\s*<+\\s*(\\d)').firstMatch(text);
    if (match != null) {
      return match.group(1) ?? '';
    }

    // 7. PER con número que tiene espacios
    final perSpacePatterns = [
      r'PER\s*(\d{4})\s+(\d{4})\s*<+\s*(\d)',
      r'PER\s*(\d{5})\s+(\d{3})\s*<+\s*(\d)',
      r'PER\s*(\d{3})\s+(\d{5})\s*<+\s*(\d)',
      r'PER\s*(\d{6})\s+(\d{2})\s*<+\s*(\d)',
      r'PER\s*(\d{2})\s+(\d{6})\s*<+\s*(\d)',
      r'PER\s*(\d{7})\s+(\d{1})\s*<+\s*(\d)',
      r'PER\s*(\d{1})\s+(\d{7})\s*<+\s*(\d)',
    ];

    for (final pattern in perSpacePatterns) {
      match = RegExp(pattern).firstMatch(text);
      if (match != null) {
        final mrzNumber = '${match.group(1)}${match.group(2)}';
        if (mrzNumber == dniNumber) {
          return match.group(3) ?? '';
        }
      }
    }

    // 8. PER con patrón flexible
    match = RegExp(r'PER\s*([\d\s]+?)\s*<+\s*(\d)').firstMatch(text);
    if (match != null) {
      final mrzNumber = match.group(1)?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
      if (mrzNumber == dniNumber) {
        return match.group(2) ?? '';
      }
    }

    // 9. Buscar después del número con separadores comunes
    match = RegExp('$escapedDni[-\\s<]+(\\d)').firstMatch(text);
    if (match != null) {
      return match.group(1) ?? '';
    }

    return '';
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

  String? _extractName(String text, String? extractedLastName) {
    final cleanText = text.replaceAll(RegExp(r'lucadev\d+\s*'), '');

    String? rejectIfSameAsLastName(String? candidate) {
      if (candidate == null || candidate.isEmpty) return null;
      if (extractedLastName == null || extractedLastName.isEmpty)
        return candidate;
      if (candidate.trim().toUpperCase() ==
          extractedLastName.trim().toUpperCase())
        return null;
      return candidate;
    }

    const labelPattern =
        r'PRE\s*NOMBRES|PRENOMBRES|Prenombres|Pre\s+Nombres|Pre\s+Nonbres|Prenombre|PREHOMBRES|PREMOMBRES';
    const namePattern = r'([A-ZÁÉÍÓÚÑ]{2,}(?:\s+[A-ZÁÉÍÓÚÑ]{2,}){1,3})';

    // 1. Label y valor en la misma línea: "Prenombres LUIS IVAN"
    var match = RegExp(
      '(?:$labelPattern)\\s+$namePattern(?:\\s|\$|\n)',
      caseSensitive: false,
    ).firstMatch(cleanText);
    if (match != null) {
      final name = match.group(1)?.trim();
      if (name != null && name.length >= 5) {
        final cleaned = _cleanName(name);
        if (cleaned.isNotEmpty && !_cleanNameIsLabelOrGarbage(cleaned)) {
          final result = rejectIfSameAsLastName(cleaned);
          if (result != null) return result;
        }
      }
    }

    // 2. Valor DESPUÉS del label (línea siguiente): "Prenombres\nLUIS IVAN"
    match = RegExp(
      '(?:$labelPattern)\\s*(?:\\n|\\r\\n|\\s{2,})($namePattern)',
      caseSensitive: false,
    ).firstMatch(cleanText);
    if (match != null) {
      final name = match.group(1)?.trim();
      if (name != null && name.length >= 5) {
        final cleaned = _cleanName(name);
        if (cleaned.isNotEmpty && !_cleanNameIsLabelOrGarbage(cleaned)) {
          final result = rejectIfSameAsLastName(cleaned);
          if (result != null) return result;
        }
      }
    }

    // 3. Valor ANTES del label (línea anterior): "LUIS IVAN\nPrenombres"
    match = RegExp(
      '($namePattern)\\s*(?:\\n|\\r\\n)(?:$labelPattern)',
      caseSensitive: false,
    ).firstMatch(cleanText);
    if (match != null) {
      final name = match.group(1)?.trim();
      if (name != null && name.length >= 5) {
        final cleaned = _cleanName(name);
        if (cleaned.isNotEmpty && !_cleanNameIsLabelOrGarbage(cleaned)) {
          final result = rejectIfSameAsLastName(cleaned);
          if (result != null) return result;
        }
      }
    }

    // 4. Por líneas: buscar label y tomar línea anterior o siguiente
    final lines = cleanText.split(RegExp(r'[\n\r]+'));
    for (int i = 0; i < lines.length; i++) {
      if (!RegExp(labelPattern, caseSensitive: false).hasMatch(lines[i])) {
        continue;
      }
      for (final candidate in [
        if (i > 0) lines[i - 1].trim(),
        if (i < lines.length - 1) lines[i + 1].trim(),
      ]) {
        if (candidate.isEmpty || candidate.length < 5) continue;
        if (!RegExp(r'^[A-ZÁÉÍÓÚÑ\s]+$').hasMatch(candidate)) continue;
        if (RegExp(r'\d').hasMatch(candidate)) continue;
        final cleaned = _cleanName(candidate);
        if (cleaned.isNotEmpty &&
            cleaned.length >= 5 &&
            !_cleanNameIsLabelOrGarbage(cleaned)) {
          final result = rejectIfSameAsLastName(cleaned);
          if (result != null) return result;
        }
      }
    }

    // 5. Fallback: "NOMBRES: LUIS IVAN"
    match = RegExp(
      r'(?:NOMBRES|Nombres)\s*:\s*([A-ZÁÉÍÓÚÑ\s]+?)(?:\s{2,}|\n|$)',
      caseSensitive: false,
    ).firstMatch(cleanText);
    if (match != null) {
      final name = match.group(1)?.trim();
      if (name != null && name.length >= 5) {
        final cleaned = _cleanName(name);
        if (cleaned.isNotEmpty && !_cleanNameIsLabelOrGarbage(cleaned)) {
          final result = rejectIfSameAsLastName(cleaned);
          if (result != null) return result;
        }
      }
    }

    return null;
  }

  bool _cleanNameIsLabelOrGarbage(String s) {
    final upper = s.toUpperCase();
    // Evitar labels del DNI o apellidos que se cuelan en la línea de Prenombres
    const garbage = [
      'APELLIDO',
      'PRIMER',
      'SEGUNDO',
      'PRENOMBRES',
      'NOMBRES',
      'SEXO',
      'NACIMIENTO',
      'PER',
      'CUI',
      'TARJETA',
      'ESTADO',
      'CIVIL',
    ];
    final words = upper.split(RegExp(r'\s+'));
    for (final g in garbage) {
      if (words.any((w) => w == g || w.startsWith(g))) return true;
    }
    return false;
  }

  String? _extractLastName(String text) {
    // Limpiar prefijos de debug si existen
    final cleanText = text.replaceAll(RegExp(r'lucadev\d+\s*'), '');

    // Buscar primer apellido - línea inmediatamente anterior a "PRIMER APELLIDO"
    // Ejemplo: "CARRANZA\nPRIMER APELLIDO" - capturar solo "CARRANZA"
    // Usar patrón más flexible que no dependa del inicio de línea
    var primerMatch = RegExp(
      r'([A-ZÁÉÍÓÚÑ]+)\s*(?:\n|\r\n|\s+)(?:PRIMER|Primer)\s+(?:APELLIDO|Apellido|Apelido)',
      caseSensitive: false,
    ).firstMatch(cleanText);

    // Buscar segundo apellido - línea inmediatamente anterior a "SEGUNDO APELLIDO"
    // Ejemplo: "SALDAÑA\nSEGUNDO APELLIDO" - capturar solo "SALDAÑA"
    var segundoMatch = RegExp(
      r'([A-ZÁÉÍÓÚÑ]+)\s*(?:\n|\r\n|\s+)(?:SEGUNDO|Segundo)\s+(?:APELLIDO|Apellido|Apelido)',
      caseSensitive: false,
    ).firstMatch(cleanText);

    String? primerApellido;
    String? segundoApellido;

    if (primerMatch != null) {
      final raw = primerMatch.group(1)?.trim();
      if (raw != null && raw.isNotEmpty) {
        primerApellido = _cleanLastName(raw);
        if (primerApellido.isEmpty ||
            primerApellido.length < 2 ||
            RegExp(r'^\d+$').hasMatch(primerApellido)) {
          primerApellido = null;
        }
      }
    }

    // Si no encontramos con el primer patrón, buscar en líneas adyacentes
    if (primerApellido == null) {
      final lines = cleanText.split(RegExp(r'[\n\r]+'));
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (RegExp(
          r'PRIMER\s+(?:APELLIDO|Apellido|Apelido)',
          caseSensitive: false,
        ).hasMatch(line)) {
          // Buscar en la línea anterior
          if (i > 0) {
            final prevLine = lines[i - 1].trim();
            if (RegExp(r'^[A-ZÁÉÍÓÚÑ]+$').hasMatch(prevLine) &&
                prevLine.length >= 3) {
              primerApellido = _cleanLastName(prevLine);
              if (primerApellido.isEmpty ||
                  primerApellido.length < 2 ||
                  RegExp(r'^\d+$').hasMatch(primerApellido)) {
                primerApellido = null;
              } else {
                break;
              }
            }
          }
        }
      }
    }

    if (segundoMatch != null) {
      final raw = segundoMatch.group(1)?.trim();
      if (raw != null && raw.isNotEmpty) {
        segundoApellido = _cleanLastName(raw);
        if (segundoApellido.isEmpty ||
            segundoApellido.length < 2 ||
            RegExp(r'^\d+$').hasMatch(segundoApellido)) {
          segundoApellido = null;
        }
      }
    }

    // Si no encontramos con el primer patrón, buscar en líneas adyacentes
    if (segundoApellido == null) {
      final lines = cleanText.split(RegExp(r'[\n\r]+'));
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (RegExp(
          r'SEGUNDO\s+(?:APELLIDO|Apellido|Apelido)',
          caseSensitive: false,
        ).hasMatch(line)) {
          // Buscar en la línea anterior
          if (i > 0) {
            final prevLine = lines[i - 1].trim();
            if (RegExp(r'^[A-ZÁÉÍÓÚÑ]+$').hasMatch(prevLine) &&
                prevLine.length >= 3) {
              segundoApellido = _cleanLastName(prevLine);
              if (segundoApellido.isEmpty ||
                  segundoApellido.length < 2 ||
                  RegExp(r'^\d+$').hasMatch(segundoApellido)) {
                segundoApellido = null;
              } else {
                break;
              }
            }
          }
        }
      }
    }

    if (primerApellido != null && segundoApellido != null) {
      return '$primerApellido $segundoApellido';
    } else if (primerApellido != null) {
      return primerApellido;
    } else if (segundoApellido != null) {
      return segundoApellido;
    }

    final genericMatch = RegExp(
      r'(?:APELLIDOS|Apellidos)\s*:\s*([A-ZÁÉÍÓÚÑ\s]+)',
      caseSensitive: false,
    ).firstMatch(cleanText);
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
      // NOTA: No incluir nombres propios como 'LUIS', 'IVAN', 'SALDANA', 'CARRANZA'
      // porque son datos válidos que queremos conservar
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

  String? _extractBirthDate(String text) {
    // Limpiar prefijos de debug
    final cleanText = text.replaceAll(RegExp(r'lucadev\d+\s*'), '');

    // Patrón 1: Fecha cerca de "NACIMIENTO" o "FECHA DE NACIMIENTO"
    var match = RegExp(
      r'(?:FECHA\s+DE\s+NACIMIENTO|NACIMIENTO|Fecha\s+de\s+Nacimiento|Nacimiento)\s*(?:\n|\r\n|\s+)?(\d{2}[\s/]\d{2}[\s/]\d{4})',
      caseSensitive: false,
    ).firstMatch(cleanText);
    if (match != null) {
      final date = _normalizeDate(match.group(1)!);
      if (_isValidBirthDate(date)) return date;
    }

    // Patrón 2: Fecha ANTES de "NACIMIENTO"
    match = RegExp(
      r'(\d{2}[\s/]\d{2}[\s/]\d{4})\s*(?:\n|\r\n|\s+)(?:NACIONALIDAD\s+)?(?:FECHA\s+DE\s+)?NACIMIENTO',
      caseSensitive: false,
    ).firstMatch(cleanText);
    if (match != null) {
      final date = _normalizeDate(match.group(1)!);
      if (_isValidBirthDate(date)) return date;
    }

    // Patrón 3: Fecha cerca de "PER" (formato MRZ)
    match = RegExp(
      r'PER\s+(\d{2}[\s/]\d{2}[\s/]\d{4})',
      caseSensitive: false,
    ).firstMatch(cleanText);
    if (match != null) {
      final date = _normalizeDate(match.group(1)!);
      if (_isValidBirthDate(date)) return date;
    }

    // Patrón 4: Buscar todas las fechas y encontrar la que NO es caducidad ni emisión
    final allDates = RegExp(
      r'(\d{2}[\s/]\d{2}[\s/]\d{4})',
    ).allMatches(cleanText);
    for (final dateMatch in allDates) {
      final dateStr = dateMatch.group(1)!;
      final startPos = dateMatch.start;
      final endPos = dateMatch.end;

      final contextBefore = cleanText
          .substring(startPos > 100 ? startPos - 100 : 0, startPos)
          .toUpperCase();
      final contextAfter = cleanText
          .substring(
            endPos,
            endPos + 100 < cleanText.length ? endPos + 100 : cleanText.length,
          )
          .toUpperCase();

      // Excluir fechas de caducidad y emisión
      if (!contextBefore.contains('CADUCIDAD') &&
          !contextAfter.contains('CADUCIDAD') &&
          !contextBefore.contains('EMISIÓN') &&
          !contextAfter.contains('EMISIÓN') &&
          !contextBefore.contains('EMISION') &&
          !contextAfter.contains('EMISION') &&
          !contextBefore.contains('FECHA DE EMISIÓN') &&
          !contextAfter.contains('FECHA DE EMISIÓN') &&
          !contextBefore.contains('FECHA DE CADUCIDAD') &&
          !contextAfter.contains('FECHA DE CADUCIDAD') &&
          !contextBefore.contains('FECHA CADUCIDAD') &&
          !contextAfter.contains('FECHA CADUCIDAD') &&
          !contextBefore.contains('FECHA EMISION') &&
          !contextAfter.contains('FECHA EMISION') &&
          !contextBefore.contains('INSCRIPCIÓN') &&
          !contextAfter.contains('INSCRIPCIÓN') &&
          !contextBefore.contains('INSCRIPCION') &&
          !contextAfter.contains('INSCRIPCION')) {
        final date = _normalizeDate(dateStr);
        if (_isValidBirthDate(date)) return date;
      }
    }

    return null;
  }

  bool _isValidBirthDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length != 3) return false;
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day == null || month == null || year == null) return false;
      if (day < 1 || day > 31) return false;
      if (month < 1 || month > 12) return false;
      return year >= 1900 && year <= 2010;
    } catch (e) {
      return false;
    }
  }

  /// Extrae la fecha de caducidad SOLO de la zona "Fecha de Caducidad".
  /// La fecha puede estar antes o después del label (misma línea o saltos de línea).
  /// Emisión (2025) está arriba; Caducidad (2033) está abajo. Tomar la más cercana
  /// al label y, si hay varias, la de año mayor.
  String? _extractExpiryDate(String text) {
    final cleanText = text.replaceAll(RegExp(r'lucadev\d+\s*'), '');
    const label = r'FECHA\s+DE\s+CADUCIDAD';
    final pos = RegExp(label, caseSensitive: false).firstMatch(cleanText);
    if (pos == null) return null;

    final labelEnd = pos.end;

    // Ventana ANTES (80 chars) y DESPUÉS (80 chars) del label
    // Caducidad está debajo; puede haber salto de línea. Emisión está arriba.
    final beforeStart = (pos.start - 80).clamp(0, cleanText.length);
    final afterEnd = (labelEnd + 80).clamp(0, cleanText.length);
    final windowBefore = cleanText.substring(beforeStart, pos.start);
    final windowAfter = cleanText.substring(labelEnd, afterEnd);

    // Combinar ventanas antes y después; tomar la de AÑO MAYOR (Caducidad 2033 > Emisión 2025)
    final allDates = [
      ..._extractAllValidDates(windowBefore),
      ..._extractAllValidDates(windowAfter),
    ];
    if (allDates.isEmpty) return null;
    return allDates.reduce((a, b) => a.$2 > b.$2 ? a : b).$1;
  }

  List<(String, int)> _extractAllValidDates(String sub) {
    final matches = RegExp(r'(\d{2})[\s/](\d{2})[\s/](\d{4})').allMatches(sub);
    final result = <(String, int)>[];
    for (final m in matches) {
      final d = int.tryParse(m.group(1) ?? '');
      final mo = int.tryParse(m.group(2) ?? '');
      final y = int.tryParse(m.group(3) ?? '');
      if (d == null || mo == null || y == null) continue;
      if (d < 1 || d > 31 || mo < 1 || mo > 12) continue;
      if (y < 2020 || y > 2100) continue;
      result.add(('${m.group(1)}/${m.group(2)}/${m.group(3)}', y));
    }
    return result;
  }

  String? _extractGender(String text) {
    var match = RegExp(
      r'(?:SEXO|Sexo)\s*(?:\n|\r\n)?\s*([MF])',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    match = RegExp(r'\d{6}\s+([MF])(?:\s|$|\n)').firstMatch(text);
    if (match != null) return match.group(1);

    match = RegExp(r'\d+\s+([MF])(?:\s|$|\n)').firstMatch(text);
    if (match != null) return match.group(1);

    match = RegExp(
      r'(?:SEXO|Sexo)\s*(?:\n|\r\n)\s*([MF])(?:\s|$|\n)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) return match.group(1);

    if (text.toUpperCase().contains('MASCULINO')) return 'M';
    if (text.toUpperCase().contains('FEMENINO')) return 'F';

    return null;
  }

  String _normalizeDate(String dateStr) {
    return dateStr.replaceAll(RegExp(r'[\s-]'), '/');
  }

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
      // NOTA: No incluir nombres propios como 'LUIS', 'IVAN', 'SALDANA', 'CARRANZA'
      // porque son datos válidos que queremos conservar
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
