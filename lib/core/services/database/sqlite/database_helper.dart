// lib/core/services/database/sqlite/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:partners/core/utils/logger/app_logger.dart';

/// Helper para gestionar la base de datos SQLite
/// Sigue el patrón Singleton para asegurar una única instancia
class DatabaseHelper {
  static const String _databaseName = 'partners.db';
  static const int _databaseVersion = 2;
  
  static DatabaseHelper? _instance;
  Database? _database;

  // Constructor privado para Singleton
  DatabaseHelper._internal();

  /// Obtiene la instancia única del DatabaseHelper
  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  /// Obtiene la instancia de la base de datos (lazy initialization)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos y crea las tablas
  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _databaseName);

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al inicializar la base de datos',
        e,
        stackTrace,
        'DatabaseHelper',
      );
      rethrow;
    }
  }

  /// Crea las tablas en la primera ejecución
  Future<void> _onCreate(Database db, int version) async {
    try {
      // Tabla de sesiones
      await db.execute('''
        CREATE TABLE sessions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          session_id TEXT NOT NULL UNIQUE,
          ruc TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Índice para búsquedas rápidas por session_id
      await db.execute('''
        CREATE INDEX idx_sessions_session_id ON sessions(session_id)
      ''');

      // Índice para búsquedas por ruc
      await db.execute('''
        CREATE INDEX idx_sessions_ruc ON sessions(ruc)
      ''');

      // Tabla de validaciones de sesión (relación 1 a 1 con sessions)
      await db.execute('''
        CREATE TABLE session_validations (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          session_id TEXT NOT NULL UNIQUE,
          email INTEGER NOT NULL DEFAULT 0,
          whatsapp INTEGER NOT NULL DEFAULT 0,
          business INTEGER,
          identity INTEGER NOT NULL DEFAULT 0,
          password INTEGER NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE
        )
      ''');

      // Índice para búsquedas rápidas por session_id
      await db.execute('''
        CREATE INDEX idx_session_validations_session_id ON session_validations(session_id)
      ''');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al crear las tablas',
        e,
        stackTrace,
        'DatabaseHelper',
      );
      rethrow;
    }
  }

  /// Maneja las actualizaciones de la base de datos
  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    try {
      if (oldVersion < 2) {
        // Migración a versión 2: Agregar tabla session_validations
        await db.execute('''
          CREATE TABLE IF NOT EXISTS session_validations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id TEXT NOT NULL UNIQUE,
            email INTEGER NOT NULL DEFAULT 0,
            whatsapp INTEGER NOT NULL DEFAULT 0,
            business INTEGER,
            identity INTEGER NOT NULL DEFAULT 0,
            password INTEGER NOT NULL DEFAULT 0,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL,
            FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE INDEX IF NOT EXISTS idx_session_validations_session_id 
          ON session_validations(session_id)
        ''');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error en migración de base de datos',
        e,
        stackTrace,
        'DatabaseHelper',
      );
      rethrow;
    }
  }

  /// Cierra la base de datos
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
