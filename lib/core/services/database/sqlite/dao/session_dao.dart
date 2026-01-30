// lib/core/services/database/sqlite/dao/session_dao.dart
import 'package:sqflite/sqflite.dart';
import 'package:partners/core/services/database/sqlite/database_helper.dart';
import 'package:partners/core/services/database/sqlite/entities/session_entity.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/logger/app_logger.dart';

/// Data Access Object para la tabla sessions
/// Implementa el patrón DAO para separar la lógica de acceso a datos
abstract class SessionDao {
  Future<void> insert(SessionEntity session);
  Future<SessionEntity?> findBySessionId(String sessionId);
  Future<SessionEntity?> findByRuc(RucType ruc);
  Future<List<SessionEntity>> findAll();
  Future<void> update(SessionEntity session);
  Future<void> delete(String sessionId);
  Future<void> deleteAll();
  Future<bool> exists(String sessionId);
}

/// Implementación del DAO para sessions
class SessionDaoImpl implements SessionDao {
  final DatabaseHelper _dbHelper;

  SessionDaoImpl(this._dbHelper);

  @override
  Future<void> insert(SessionEntity session) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'sessions',
        session.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al insertar sesión',
        e,
        stackTrace,
        'SessionDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<SessionEntity?> findBySessionId(String sessionId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'sessions',
        where: 'session_id = ?',
        whereArgs: [sessionId],
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return SessionEntity.fromMap(maps.first);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al buscar sesión por sessionId',
        e,
        stackTrace,
        'SessionDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<SessionEntity?> findByRuc(RucType ruc) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'sessions',
        where: 'ruc = ?',
        whereArgs: [ruc.name],
        orderBy: 'updated_at DESC',
        limit: 1,
      );

      if (maps.isEmpty) return null;
      return SessionEntity.fromMap(maps.first);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al buscar sesión por RUC',
        e,
        stackTrace,
        'SessionDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<List<SessionEntity>> findAll() async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'sessions',
        orderBy: 'updated_at DESC',
      );

      return maps.map((map) => SessionEntity.fromMap(map)).toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al obtener todas las sesiones',
        e,
        stackTrace,
        'SessionDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<void> update(SessionEntity session) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'sessions',
        session.toMap(),
        where: 'session_id = ?',
        whereArgs: [session.sessionId],
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al actualizar sesión',
        e,
        stackTrace,
        'SessionDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<void> delete(String sessionId) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        'sessions',
        where: 'session_id = ?',
        whereArgs: [sessionId],
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al eliminar sesión',
        e,
        stackTrace,
        'SessionDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      final db = await _dbHelper.database;
      await db.delete('sessions');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al eliminar todas las sesiones',
        e,
        stackTrace,
        'SessionDaoImpl',
      );
      rethrow;
    }
  }

  @override
  Future<bool> exists(String sessionId) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM sessions WHERE session_id = ?',
        [sessionId],
      );
      final count = Sqflite.firstIntValue(result) ?? 0;
      return count > 0;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al verificar existencia de sesión',
        e,
        stackTrace,
        'SessionDaoImpl',
      );
      rethrow;
    }
  }
}
