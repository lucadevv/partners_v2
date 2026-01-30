// lib/core/services/database/sqlite/repository/session_validation_repository.dart
import 'package:partners/core/services/database/sqlite/dao/session_validation_dao.dart';
import 'package:partners/core/services/database/sqlite/entities/session_validation_entity.dart';

/// Interfaz del repositorio de validaciones de sesión
/// Sigue el principio de inversión de dependencias (DIP)
abstract class SessionValidationRepository {
  /// Crea o actualiza las validaciones de una sesión
  Future<void> saveValidation(SessionValidationEntity validation);

  /// Obtiene las validaciones de una sesión
  Future<SessionValidationEntity?> getValidationBySessionId(String sessionId);

  /// Inicializa las validaciones para una sesión (todos en false)
  Future<void> initializeValidation(String sessionId);

  /// Actualiza un campo específico de validación
  Future<void> updateValidationField(
    String sessionId,
    ValidationField field,
    bool value,
  );

  /// Marca un campo como completado
  Future<void> markFieldAsComplete(
    String sessionId,
    ValidationField field,
  );

  /// Elimina las validaciones de una sesión
  Future<void> deleteValidation(String sessionId);

  /// Elimina todas las validaciones
  Future<void> deleteAllValidations();

  /// Verifica si existen validaciones para una sesión
  Future<bool> validationExists(String sessionId);

  /// Verifica si todas las validaciones están completas
  Future<bool> areAllValidationsComplete(String sessionId, bool isRuc20);
}

/// Enum para los campos de validación
enum ValidationField {
  email,
  whatsapp,
  business,
  identity,
  password,
}

/// Implementación del repositorio de validaciones de sesión
/// Sigue el patrón Repository y el principio de responsabilidad única (SRP)
class SessionValidationRepositoryImpl implements SessionValidationRepository {
  final SessionValidationDao _dao;

  SessionValidationRepositoryImpl(this._dao);

  @override
  Future<void> saveValidation(SessionValidationEntity validation) async {
    final exists = await _dao.exists(validation.sessionId);
    
    if (exists) {
      await _dao.update(validation);
    } else {
      await _dao.insert(validation);
    }
  }

  @override
  Future<SessionValidationEntity?> getValidationBySessionId(
    String sessionId,
  ) async {
    return await _dao.findBySessionId(sessionId);
  }

  @override
  Future<void> initializeValidation(String sessionId) async {
    final exists = await _dao.exists(sessionId);
    
    if (!exists) {
      final initial = SessionValidationEntity.initial(sessionId);
      await _dao.insert(initial);
    }
  }

  @override
  Future<void> updateValidationField(
    String sessionId,
    ValidationField field,
    bool value,
  ) async {
    // Verificar si existe, si no, inicializar
    final exists = await _dao.exists(sessionId);
    if (!exists) {
      await initializeValidation(sessionId);
    }

    // Convertir el enum a string para el campo de la BD
    final fieldName = _fieldToColumnName(field);
    await _dao.updateValidationField(sessionId, fieldName, value);
  }

  @override
  Future<void> markFieldAsComplete(
    String sessionId,
    ValidationField field,
  ) async {
    await updateValidationField(sessionId, field, true);
  }

  @override
  Future<void> deleteValidation(String sessionId) async {
    await _dao.delete(sessionId);
  }

  @override
  Future<void> deleteAllValidations() async {
    await _dao.deleteAll();
  }

  @override
  Future<bool> validationExists(String sessionId) async {
    return await _dao.exists(sessionId);
  }

  @override
  Future<bool> areAllValidationsComplete(
    String sessionId,
    bool isRuc20,
  ) async {
    final validation = await _dao.findBySessionId(sessionId);
    if (validation == null) return false;
    
    return validation.areAllValidationsComplete(isRuc20);
  }

  /// Convierte el enum ValidationField al nombre de columna en la BD
  String _fieldToColumnName(ValidationField field) {
    switch (field) {
      case ValidationField.email:
        return 'email';
      case ValidationField.whatsapp:
        return 'whatsapp';
      case ValidationField.business:
        return 'business';
      case ValidationField.identity:
        return 'identity';
      case ValidationField.password:
        return 'password';
    }
  }
}
