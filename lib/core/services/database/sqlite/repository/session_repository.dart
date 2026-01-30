// lib/core/services/database/sqlite/repository/session_repository.dart
import 'package:partners/core/services/database/sqlite/dao/session_dao.dart';
import 'package:partners/core/services/database/sqlite/entities/session_entity.dart';
import 'package:partners/core/utils/enums/enums.dart';

/// Interfaz del repositorio de sesiones
/// Sigue el principio de inversión de dependencias (DIP)
abstract class SessionRepository {
  /// Guarda o actualiza una sesión
  Future<void> saveSession(String sessionId, RucType ruc);

  /// Obtiene una sesión por su sessionId
  Future<SessionEntity?> getSessionBySessionId(String sessionId);

  /// Obtiene la última sesión por RUC
  Future<SessionEntity?> getSessionByRuc(RucType ruc);

  /// Obtiene todas las sesiones
  Future<List<SessionEntity>> getAllSessions();

  /// Elimina una sesión por sessionId
  Future<void> deleteSession(String sessionId);

  /// Elimina todas las sesiones
  Future<void> deleteAllSessions();

  /// Verifica si existe una sesión
  Future<bool> sessionExists(String sessionId);

  /// Obtiene el sessionId actual (el más reciente)
  Future<String?> getCurrentSessionId();
}

/// Implementación del repositorio de sesiones
/// Sigue el patrón Repository y el principio de responsabilidad única (SRP)
class SessionRepositoryImpl implements SessionRepository {
  final SessionDao _dao;

  SessionRepositoryImpl(this._dao);

  @override
  Future<void> saveSession(String sessionId, RucType ruc) async {
    final now = DateTime.now();
    
    // Verificar si ya existe
    final existing = await _dao.findBySessionId(sessionId);
    
    if (existing != null) {
      // Actualizar la sesión existente
      final updated = existing.copyWith(
        ruc: ruc,
        updatedAt: now,
      );
      await _dao.update(updated);
    } else {
      // Crear nueva sesión
      final newSession = SessionEntity(
        sessionId: sessionId,
        ruc: ruc,
        createdAt: now,
        updatedAt: now,
      );
      await _dao.insert(newSession);
    }
  }

  @override
  Future<SessionEntity?> getSessionBySessionId(String sessionId) async {
    return await _dao.findBySessionId(sessionId);
  }

  @override
  Future<SessionEntity?> getSessionByRuc(RucType ruc) async {
    return await _dao.findByRuc(ruc);
  }

  @override
  Future<List<SessionEntity>> getAllSessions() async {
    return await _dao.findAll();
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await _dao.delete(sessionId);
  }

  @override
  Future<void> deleteAllSessions() async {
    await _dao.deleteAll();
  }

  @override
  Future<bool> sessionExists(String sessionId) async {
    return await _dao.exists(sessionId);
  }

  @override
  Future<String?> getCurrentSessionId() async {
    final sessions = await _dao.findAll();
    if (sessions.isEmpty) return null;
    
    // Retornar el sessionId más reciente
    return sessions.first.sessionId;
  }
}
