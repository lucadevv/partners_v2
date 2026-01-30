import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/validations/ce_validator.dart';
import 'package:partners/core/utils/validations/dni_validator.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_ocr_entity.dart';

/// Servicio para procesar imágenes con OCR usando ML Kit
/// Basado en: https://github.com/flutter-ml/google_ml_kit_flutter
class OcrService {
  TextRecognizer? _textRecognizer;

  OcrService();

  /// Obtiene o crea el TextRecognizer latino (lazy initialization)
  /// Usa script latino para reconocer caracteres en documentos peruanos (DNI/CE)
  TextRecognizer get _recognizer {
    _textRecognizer ??= TextRecognizer(script: TextRecognitionScript.latin);
    return _textRecognizer!;
  }

  /// Procesa imagen con ML Kit y devuelve el texto completo
  /// Basado en el ejemplo oficial: https://github.com/flutter-ml/google_ml_kit_flutter
  Future<String> _processImageWithMLKit(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);

    try {
      final recognizedText = await _recognizer.processImage(inputImage);

      // Obtener texto completo (método recomendado por ML Kit)
      var textoCompleto = recognizedText.text.trim();

      // Si el texto completo está vacío o es muy corto, construir desde bloques
      if (textoCompleto.isEmpty || textoCompleto.length < 3) {
        debugPrint('⚠️ Texto completo vacío, construyendo desde bloques...');
        final textoDeBloques = StringBuffer();

        // Procesar cada bloque, línea y elemento (como en el ejemplo oficial)
        for (final block in recognizedText.blocks) {
          for (final line in block.lines) {
            for (final element in line.elements) {
              textoDeBloques.write(element.text);
              textoDeBloques.write(' ');
            }
            textoDeBloques.writeln();
          }
        }

        textoCompleto = textoDeBloques.toString().trim();

        if (textoCompleto.isNotEmpty) {
          debugPrint(
            '✅ Texto extraído de bloques: ${textoCompleto.length} caracteres',
          );
        }
      }

      if (textoCompleto.isNotEmpty) {
        debugPrint('✅ Texto detectado: ${textoCompleto.length} caracteres');
        debugPrint('📊 Bloques detectados: ${recognizedText.blocks.length}');

        // Mostrar información detallada de bloques para debugging
        for (int i = 0; i < recognizedText.blocks.length; i++) {
          final block = recognizedText.blocks[i];
          debugPrint(
            '   Bloque $i: "${block.text}" (${block.lines.length} líneas)',
          );

          // Mostrar líneas del bloque
          for (int j = 0; j < block.lines.length && j < 3; j++) {
            final line = block.lines[j];
            debugPrint('      Línea $j: "${line.text}"');
          }
        }

        return textoCompleto;
      }

      throw Exception(
        'No se pudo extraer texto de la imagen. Asegúrate de que el documento esté bien enfocado, con buena iluminación y que el texto sea claramente visible.',
      );
    } catch (e) {
      debugPrint('⚠️ Error al procesar imagen con ML Kit: $e');
      rethrow;
    }
  }

  /// Obtiene solo el texto crudo del OCR sin parsearlo
  Future<String> getRawText(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('La imagen no existe en la ruta: $imagePath');
      }

      return await _processImageWithMLKit(imagePath);
    } catch (e) {
      throw Exception('Error al obtener texto OCR: $e');
    }
  }

  /// Procesa una imagen y extrae información del documento
  Future<DocumentOcrEntity> processDocumentImage(String imagePath) async {
    try {
      // Verificar que el archivo existe
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('La imagen no existe en la ruta: $imagePath');
      }

      // Procesar con ML Kit (basado en ejemplo oficial)
      final textoCompleto = await _processImageWithMLKit(imagePath);

      // Log del texto completo extraído para debugging
      debugPrint('📄 Texto completo extraído por OCR:');
      debugPrint('═══════════════════════════════════════');
      debugPrint(textoCompleto);
      debugPrint('═══════════════════════════════════════');
      debugPrint('📊 Longitud del texto: ${textoCompleto.length} caracteres');

      // Verificar que se extrajo texto
      if (textoCompleto.trim().isEmpty) {
        throw Exception(
          'No se pudo extraer texto de la imagen. Asegúrate de que el documento esté bien enfocado y visible.',
        );
      }

      // Analizar el texto para extraer información
      // Si hay error en el parseo, lanzar excepción con el texto detectado para debugging
      try {
        return _parseDocumentText(textoCompleto, imagePath);
      } catch (e) {
        // Si falla el parseo, lanzar excepción con el texto detectado incluido
        throw Exception('${e.toString()}\n\nTexto detectado:\n$textoCompleto');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Error al procesar imagen: $e');
    }
  }

  /// Analiza el texto extraído y crea la entidad DocumentOcrEntity
  DocumentOcrEntity _parseDocumentText(String textoCompleto, String imagePath) {
    debugPrint('🔍 Analizando texto para detectar documento...');

    // Limpiar el texto: remover espacios extra pero mantener saltos de línea
    // Primero, normalizar espacios múltiples
    final textoLimpio = textoCompleto.replaceAll(RegExp(r'[ \t]+'), ' ').trim();

    // También crear versión sin espacios para búsqueda más flexible
    final textoSinEspacios = textoCompleto.replaceAll(RegExp(r'\s+'), '');

    debugPrint('📝 Texto limpio (con espacios): $textoLimpio');
    debugPrint('📝 Texto sin espacios: $textoSinEspacios');

    // Buscar número de DNI (8 dígitos consecutivos)
    // Intentar múltiples estrategias de búsqueda más agresivas
    RegExpMatch? dniMatch;

    // Estrategia 1: Buscar con word boundaries (más preciso)
    dniMatch = RegExp(r'\b\d{8}\b').firstMatch(textoLimpio);

    // Estrategia 2: Buscar sin word boundaries en texto limpio
    dniMatch ??= RegExp(r'\d{8}').firstMatch(textoLimpio);

    // Estrategia 3: Buscar en texto sin espacios
    dniMatch ??= RegExp(r'\d{8}').firstMatch(textoSinEspacios);

    // Estrategia 4: Buscar cualquier secuencia de 7-9 dígitos y filtrar por longitud
    if (dniMatch == null) {
      final digitosMatch = RegExp(r'\d{7,9}').allMatches(textoLimpio);
      for (final match in digitosMatch) {
        final numero = match.group(0)!;
        if (numero.length == 8) {
          dniMatch = match;
          break;
        }
      }
    }

    // Estrategia 5: Buscar en texto sin espacios con 7-9 dígitos
    if (dniMatch == null) {
      final digitosMatch = RegExp(r'\d{7,9}').allMatches(textoSinEspacios);
      for (final match in digitosMatch) {
        final numero = match.group(0)!;
        if (numero.length == 8) {
          dniMatch = match;
          break;
        }
      }
    }

    // Estrategia 6: Buscar cualquier secuencia de exactamente 8 dígitos (muy flexible)
    if (dniMatch == null) {
      // Buscar en todo el texto, incluso con caracteres alrededor
      final allMatches = RegExp(r'\d{8}').allMatches(textoCompleto);
      for (final match in allMatches) {
        final numero = match.group(0)!;
        // Validar que sea un DNI válido
        if (DniValidator.isValidDni(numero)) {
          dniMatch = match;
          break;
        }
      }
    }

    // Buscar número de CE (alfanumérico, generalmente más largo)
    RegExpMatch? ceMatch;

    // Estrategia 1: CE peruano formato estándar: letras + números (ej: A12345678)
    ceMatch = RegExp(
      r'\b[A-Z]{1,3}\d{6,9}\b',
      caseSensitive: false,
    ).firstMatch(textoLimpio);

    // Estrategia 2: Buscar sin word boundaries en texto limpio
    ceMatch ??= RegExp(
      r'[A-Z]{1,3}\d{6,9}',
      caseSensitive: false,
    ).firstMatch(textoLimpio);

    // Estrategia 3: Buscar formato más flexible: cualquier alfanumérico de 9-12 caracteres
    ceMatch ??= RegExp(
      r'[A-Z0-9]{9,12}',
      caseSensitive: false,
    ).firstMatch(textoLimpio);

    // Estrategia 4: Buscar en texto sin espacios
    ceMatch ??= RegExp(
      r'[A-Z0-9]{9,12}',
      caseSensitive: false,
    ).firstMatch(textoSinEspacios);

    // Estrategia 5: Buscar en texto completo (muy flexible)
    ceMatch ??= RegExp(
      r'[A-Z0-9]{9,12}',
      caseSensitive: false,
    ).firstMatch(textoCompleto);

    // Estrategia 6: Buscar formato CE más común: 1-2 letras seguidas de 8-9 dígitos
    ceMatch ??= RegExp(
      r'[A-Z]{1,2}\d{8,9}',
      caseSensitive: false,
    ).firstMatch(textoCompleto);

    debugPrint('🔎 DNI encontrado: ${dniMatch?.group(0)}');
    debugPrint('🔎 CE encontrado: ${ceMatch?.group(0)}');

    // Mostrar información detallada de debugging
    debugPrint('📊 Análisis del texto:');
    debugPrint('   - Longitud texto limpio: ${textoLimpio.length}');
    debugPrint('   - Longitud texto sin espacios: ${textoSinEspacios.length}');
    debugPrint(
      '   - Primeros 100 caracteres: ${textoLimpio.substring(0, textoLimpio.length > 100 ? 100 : textoLimpio.length)}...',
    );

    // Buscar todos los números de 7-9 dígitos para debugging
    final todosLosNumeros = RegExp(r'\d{7,9}').allMatches(textoLimpio);
    debugPrint(
      '   - Números de 7-9 dígitos encontrados: ${todosLosNumeros.map((m) => m.group(0)).toList()}',
    );

    // Buscar todos los alfanuméricos para debugging
    final todosLosAlfanumericos = RegExp(
      r'[A-Z0-9]{8,12}',
      caseSensitive: false,
    ).allMatches(textoLimpio);
    debugPrint(
      '   - Alfanuméricos de 8-12 caracteres: ${todosLosAlfanumericos.map((m) => m.group(0)).toList()}',
    );

    DocumentType tipoDocumento;
    String numeroDocumento;
    String? digitoVerificador;

    if (dniMatch != null) {
      // Es un DNI
      debugPrint('✅ Detectado como DNI');
      tipoDocumento = DocumentType.dni;
      final dniCompleto = dniMatch.group(0)!;

      // Validar que tenga 8 dígitos
      if (DniValidator.isValidDni(dniCompleto)) {
        numeroDocumento = dniCompleto;
        debugPrint('✅ DNI válido: $numeroDocumento');
        // El dígito verificador podría estar después del número
        final verificadorMatch = RegExp(r'\d{8}(\d)').firstMatch(textoLimpio);
        digitoVerificador = verificadorMatch?.group(1);
        if (digitoVerificador != null) {
          debugPrint('✅ Dígito verificador encontrado: $digitoVerificador');
        }
      } else {
        debugPrint('❌ DNI inválido: $dniCompleto');
        throw Exception(
          'DNI inválido: debe tener 8 dígitos. Texto detectado: ${textoLimpio.substring(0, 200)}...',
        );
      }
    } else if (ceMatch != null) {
      // Es un CE
      debugPrint('✅ Detectado como CE');
      tipoDocumento = DocumentType.ce;
      final ceCompleto = ceMatch.group(0)!.toUpperCase();

      // Validar que tenga el formato correcto de CE
      if (CeValidator.isValidCe(ceCompleto)) {
        numeroDocumento = ceCompleto;
        debugPrint('✅ CE válido: $numeroDocumento');
      } else {
        debugPrint('❌ CE inválido: $ceCompleto');
        throw Exception(
          'CE inválido: debe tener formato válido (ej: A12345678). Texto detectado: ${textoLimpio.substring(0, 200)}...',
        );
      }
    } else {
      debugPrint('❌ No se encontró DNI ni CE en el texto');
      debugPrint('💡 Texto completo detectado:');
      debugPrint('═══════════════════════════════════════');
      debugPrint(textoCompleto);
      debugPrint('═══════════════════════════════════════');
      debugPrint(
        '💡 Sugerencia: Asegúrate de que el documento esté bien enfocado y visible',
      );
      throw Exception(
        'No se pudo detectar un documento válido (DNI o CE).\n\nTexto detectado:\n${textoCompleto.substring(0, textoCompleto.length > 500 ? 500 : textoCompleto.length)}...',
      );
    }

    // Extraer nombres y apellidos (buscar patrones comunes en documentos peruanos)
    final nombres = _extractNombres(textoLimpio);
    final apellidos = _extractApellidos(textoLimpio);
    final fechaNacimiento = _extractFechaNacimiento(textoLimpio);

    return DocumentOcrEntity(
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumento,
      nombres: nombres,
      apellidos: apellidos,
      fechaNacimiento: fechaNacimiento,
      digitoVerificador: digitoVerificador,
      textoCompleto: textoCompleto,
      imagePath: imagePath,
      confianza:
          0.9, // ML Kit no proporciona confianza por campo, usar valor estimado
    );
  }

  /// Extrae nombres del texto OCR
  String? _extractNombres(String texto) {
    // Buscar patrones comunes: "NOMBRES:", "NOMBRE:", o líneas que parezcan nombres
    final nombresMatch = RegExp(
      r'(?:NOMBRES?|NOMBRE)[:\s]+([A-ZÁÉÍÓÚÑ\s]{3,})',
      caseSensitive: false,
    ).firstMatch(texto);

    if (nombresMatch != null) {
      return nombresMatch.group(1)?.trim();
    }

    // Buscar líneas que parezcan nombres (solo letras, mayúsculas)
    final lineas = texto.split('\n');
    for (final linea in lineas) {
      final limpia = linea.trim();
      if (limpia.length >= 3 &&
          limpia.length <= 50 &&
          RegExp(r'^[A-ZÁÉÍÓÚÑ\s]+$').hasMatch(limpia)) {
        return limpia;
      }
    }

    return null;
  }

  /// Extrae apellidos del texto OCR
  String? _extractApellidos(String texto) {
    // Buscar patrones comunes: "APELLIDOS:", "APELLIDO:"
    final apellidosMatch = RegExp(
      r'(?:APELLIDOS?|APELLIDO)[:\s]+([A-ZÁÉÍÓÚÑ\s]{3,})',
      caseSensitive: false,
    ).firstMatch(texto);

    if (apellidosMatch != null) {
      return apellidosMatch.group(1)?.trim();
    }

    return null;
  }

  /// Extrae fecha de nacimiento del texto OCR
  String? _extractFechaNacimiento(String texto) {
    // Buscar formato DD/MM/YYYY o DD-MM-YYYY
    final fechaMatch = RegExp(
      r'\b(\d{2})[/-](\d{2})[/-](\d{4})\b',
    ).firstMatch(texto);

    if (fechaMatch != null) {
      return '${fechaMatch.group(1)}/${fechaMatch.group(2)}/${fechaMatch.group(3)}';
    }

    return null;
  }

  /// Libera recursos del reconocedor de texto
  /// IMPORTANTE: Siempre cerrar el reconocedor cuando no se use más
  void dispose() {
    _textRecognizer?.close();
    _textRecognizer = null;
  }
}
