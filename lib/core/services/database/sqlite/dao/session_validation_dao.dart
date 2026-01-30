// lib/core/services/database/sqlite/dao/session_validation_dao.dart
import 'package:sqflite/sqflite.dart';
import 'package:partners/core/services/database/sqlite/database_helper.dart';
import 'package:partners/core/services/database/sqlite/entities/session_validation_entity.dart';
import 'package:partners/core/utils/logger/app_logger.dart';

/// Data Access Object para la tabla session_validations
/// Implementa el patrón DAO para separar la lógica de acceso a datos
abstract class SessionValidationDao {
  Future<void> insert(SessionValidationEntity validation);
  Future<SessionValidationEntity?> findBySessionId(String sessionId);
  Future<void> update(SessionValidationEntity validation);
  Future<void> delete(String sessionId);
  Future<void> deleteAll();
  Future<bool> exists(String sessionId);
  Future<void> updateValidationField(
    String sessionId,
    String field,
    bool value,
  );
}

/// Implementación del DAO para session_validations
class SessionValidationDaoImpl implements SessionValidationDao {
  final DatabaseHelper _dbHelper;

  SessionValidationDaoImpl(this._dbHelper);

  @override
  Future<void> insert(SessionValidationEntity validation) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'session_validations',
        validation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al insertar validación de sesión',
        e,
        stackTrace,
        'SessionValidationDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<SessionValidationEntity?> findBySessionId(String sessionId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'session_validations',
        where: 'session_id = ?',
        whereArgs: [sessionId],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return SessionValidationEntity.fromMap(maps.first);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al buscar validación por sessionId',
        e,
        stackTrace,
        'SessionValidationDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<void> update(SessionValidationEntity validation) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'session_validations',
        validation.toMap(),
        where: 'session_id = ?',
        whereArgs: [validation.sessionId],
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al actualizar validación de sesión',
        e,
        stackTrace,
        'SessionValidationDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<void> delete(String sessionId) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        'session_validations',
        where: 'session_id = ?',
        whereArgs: [sessionId],
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al eliminar validación de sesión',
        e,
        stackTrace,
        'SessionValidationDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      final db = await _dbHelper.database;
      await db.delete('session_validations');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al eliminar todas las validaciones',
        e,
        stackTrace,
        'SessionValidationDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<bool> exists(String sessionId) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM session_validations WHERE session_id = ?',
        [sessionId],
      );
      final count = Sqflite.firstIntValue(result) ?? 0;
      return count > 0;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al verificar existencia de validación',
        e,
        stackTrace,
        'SessionValidationDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<void> updateValidationField(
    String sessionId,
    String field,
    bool value,
  ) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'session_validations',
        {
          field: value ? 1 : 0,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'session_id = ?',
        whereArgs: [sessionId],
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al actualizar campo de validación',
        e,
        stackTrace,
        'SessionValidationDaoImpl',
      );
      rethrow;
    }
  }
}
