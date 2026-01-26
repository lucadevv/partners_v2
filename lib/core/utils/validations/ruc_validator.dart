import 'package:partners/core/utils/validations/dni_validator.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_comercio.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';

/// Validador para RUC peruano
///
/// Formato RUC:
/// - RUC 10: 10 + DNI (8 dígitos) + código de seguridad (1 dígito) = 11 dígitos
/// - RUC 15: 15 + DNI/CE (8-9 dígitos) + código de seguridad (1 dígito) = 12-13 dígitos
/// - RUC 20: 20 + DNI/CE (8-9 dígitos) + código de seguridad (1 dígito) = 12-13 dígitos
class RucValidator {
  RucValidator._();

  /// Valida si un RUC es válido según el tipo de comercio
  ///
  /// [ruc] El número de RUC a validar
  /// [tipoComercio] El tipo de comercio (ruc10, ruc15, ruc20)
  /// [tipoDocumento] El tipo de documento (dni o ce) - solo para ruc15 y ruc20
  ///
  /// Retorna `true` si es válido, `false` en caso contrario
  static bool isValidRuc(
    String? ruc,
    TipoComercio tipoComercio, {
    TipoDocumento? tipoDocumento,
  }) {
    if (ruc == null || ruc.isEmpty) {
      return false;
    }

    // Remover espacios y caracteres especiales
    final rucLimpio = ruc.replaceAll(RegExp(r'[\s\-]'), '');

    // Validar que contenga solo dígitos
    if (!RegExp(r'^\d+$').hasMatch(rucLimpio)) {
      return false;
    }

    switch (tipoComercio) {
      case TipoComercio.ruc10:
        // RUC 10: debe tener 11 dígitos, empezar con 10
        if (rucLimpio.length != 11) {
          return false;
        }
        if (!rucLimpio.startsWith('10')) {
          return false;
        }
        // Extraer DNI (8 dígitos después del prefijo 10)
        final dni = rucLimpio.substring(2, 10);
        // Validar que el DNI sea válido
        return DniValidator.isValidDni(dni);

      case TipoComercio.ruc15:
        // RUC 15: debe tener 12-13 dígitos, empezar con 15
        if (rucLimpio.length != 11) {
          return false;
        }
        if (!rucLimpio.startsWith('15')) {
          return false;
        }
        // Extraer documento (8-9 dígitos después del prefijo 15)
        final documento = rucLimpio.substring(2, rucLimpio.length - 1);
        // Validar según tipo de documento
        if (tipoDocumento == TipoDocumento.dni) {
          return DniValidator.isValidDni(documento);
        } else if (tipoDocumento == TipoDocumento.ce) {
          return documento.length == 9 && RegExp(r'^\d+$').hasMatch(documento);
        }
        // Si no se especifica tipo, validar como DNI (8 dígitos)
        return DniValidator.isValidDni(documento);

      case TipoComercio.ruc20:
        // RUC 20: debe tener 12-13 dígitos, empezar con 20
        if (rucLimpio.length != 11) {
          return false;
        }
        if (!rucLimpio.startsWith('20')) {
          return false;
        }
        // Extraer documento (8-9 dígitos después del prefijo 20)
        final documento = rucLimpio.substring(2, rucLimpio.length - 1);
        // Validar según tipo de documento
        if (tipoDocumento == TipoDocumento.dni) {
          return DniValidator.isValidDni(documento);
        } else if (tipoDocumento == TipoDocumento.ce) {
          return documento.length == 9 && RegExp(r'^\d+$').hasMatch(documento);
        }
        // Si no se especifica tipo, validar como DNI (8 dígitos)
        return DniValidator.isValidDni(documento);
    }
  }

  /// Extrae el DNI/CE del RUC
  ///
  /// [ruc] El número de RUC
  /// [tipoComercio] El tipo de comercio
  ///
  /// Retorna el número de documento sin el prefijo y código de seguridad
  static String? extractDocumento(String? ruc, TipoComercio tipoComercio) {
    if (ruc == null || ruc.isEmpty) {
      return null;
    }

    final rucLimpio = ruc.replaceAll(RegExp(r'[\s\-]'), '');

    switch (tipoComercio) {
      case TipoComercio.ruc10:
        // RUC 10: 10 + DNI (8) + código (1) = 11
        if (rucLimpio.length != 11 || !rucLimpio.startsWith('10')) {
          return null;
        }
        return rucLimpio.substring(2, 10); // DNI de 8 dígitos

      case TipoComercio.ruc15:
        // RUC 15: 15 + DNI/CE (8-9) + código (1) = 12-13
        if (rucLimpio.length < 12 ||
            rucLimpio.length > 13 ||
            !rucLimpio.startsWith('15')) {
          return null;
        }
        return rucLimpio.substring(2, rucLimpio.length - 1); // DNI/CE

      case TipoComercio.ruc20:
        // RUC 20: 20 + DNI/CE (8-9) + código (1) = 12-13
        if (rucLimpio.length < 12 ||
            rucLimpio.length > 13 ||
            !rucLimpio.startsWith('20')) {
          return null;
        }
        return rucLimpio.substring(2, rucLimpio.length - 1); // DNI/CE
    }
  }

  /// Obtiene el código de seguridad del RUC
  ///
  /// [ruc] El número de RUC
  ///
  /// Retorna el último dígito (código de seguridad)
  static String? extractCodigoSeguridad(String? ruc) {
    if (ruc == null || ruc.isEmpty) {
      return null;
    }

    final rucLimpio = ruc.replaceAll(RegExp(r'[\s\-]'), '');
    if (rucLimpio.length < 11) {
      return null;
    }

    return rucLimpio.substring(rucLimpio.length - 1);
  }

  /// Valida si un RUC no está vacío
  ///
  /// [ruc] El número de RUC a validar
  ///
  /// Retorna `true` si no está vacío
  static bool isNotEmpty(String? ruc) {
    return ruc != null && ruc.trim().isNotEmpty;
  }
}
