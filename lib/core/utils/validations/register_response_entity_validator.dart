import 'package:partners/core/utils/validations/register_response_validation_error.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';

/// Validador para RegisterResponseEntity
///
/// Implementa Single Responsibility: solo valida RegisterResponseEntity
class RegisterResponseEntityValidator {
  RegisterResponseEntityValidator._();

  /// Valida una instancia de RegisterResponseEntity
  ///
  /// [entity] La entidad a validar
  ///
  /// Retorna lista de errores. Lista vacía si es válida.
  static List<RegisterResponseValidationError> validate(
    RegisterResponseEntity entity,
  ) {
    final errors = <RegisterResponseValidationError>[];

    if (!_isNombresNotEmpty(entity)) {
      errors.add(RegisterResponseValidationError.namesEmpty);
    }

    if (!_isApellidosNotEmpty(entity)) {
      errors.add(RegisterResponseValidationError.lastNamesEmpty);
    }

    return errors;
  }

  /// Verifica si la entidad es válida
  static bool isValid(RegisterResponseEntity entity) {
    return validate(entity).isEmpty;
  }

  /// Valida que nombres no esté vacío
  static bool _isNombresNotEmpty(RegisterResponseEntity entity) {
    return entity.nombres!.trim().isNotEmpty;
  }

  /// Valida que apellidos no esté vacío
  static bool _isApellidosNotEmpty(RegisterResponseEntity entity) {
    return entity.apellidos!.trim().isNotEmpty;
  }
}
