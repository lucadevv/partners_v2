import 'package:partners/core/utils/validations/dni_validator.dart';
import 'package:partners/core/utils/validations/register_validation_error.dart';
import 'package:partners/features/auth/register/domain/entities/register_entity.dart';

/// Validador para RegisterEntity
/// 
/// Implementa Single Responsibility: solo valida RegisterEntity
class RegisterEntityValidator {
  RegisterEntityValidator._();

  /// Valida una instancia de RegisterEntity
  /// 
  /// [entity] La entidad a validar
  /// 
  /// Retorna lista de errores. Lista vacía si es válida.
  static List<RegisterValidationError> validate(RegisterEntity entity) {
    final errors = <RegisterValidationError>[];

    if (!_isTipoComercioValid(entity)) {
      errors.add(RegisterValidationError.tipoComercioRequired);
    }

    if (!_isTipoDocumentoValid(entity)) {
      errors.add(RegisterValidationError.tipoDocumentoRequired);
    }

    if (!_isNumeroDocumentoValid(entity)) {
      errors.add(RegisterValidationError.numeroDocumentoRequired);
      return errors;
    }

    if (!_isNumeroDocumentoNotEmpty(entity)) {
      errors.add(RegisterValidationError.numeroDocumentoEmpty);
      return errors;
    }

    if (!_isNumeroDocumentoFormatValid(entity)) {
      errors.add(RegisterValidationError.numeroDocumentoInvalid);
    }

    return errors;
  }

  /// Verifica si la entidad es válida
  static bool isValid(RegisterEntity entity) {
    return validate(entity).isEmpty;
  }

  /// Valida tipo de comercio
  static bool _isTipoComercioValid(RegisterEntity entity) {
    return entity.tipoComercio != null;
  }

  /// Valida tipo de documento
  static bool _isTipoDocumentoValid(RegisterEntity entity) {
    return entity.tipoDocumento != null;
  }

  /// Valida que número de documento exista
  static bool _isNumeroDocumentoValid(RegisterEntity entity) {
    return entity.numeroDocumento != null;
  }

  /// Valida que número de documento no esté vacío
  static bool _isNumeroDocumentoNotEmpty(RegisterEntity entity) {
    return DniValidator.isNotEmpty(entity.numeroDocumento);
  }

  /// Valida formato de número de documento
  static bool _isNumeroDocumentoFormatValid(RegisterEntity entity) {
    return DniValidator.isValidDni(entity.numeroDocumento);
  }
}
