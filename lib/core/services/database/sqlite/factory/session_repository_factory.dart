// lib/core/services/database/sqlite/factory/session_repository_factory.dart
import 'package:partners/core/services/database/sqlite/database_helper.dart';
import 'package:partners/core/services/database/sqlite/dao/session_dao.dart';
import 'package:partners/core/services/database/sqlite/repository/session_repository.dart';

/// Factory para crear instancias del SessionRepository
/// Sigue el patrón Factory para centralizar la creación de objetos
class SessionRepositoryFactory {
  static SessionRepository? _instance;

  /// Obtiene una instancia única del SessionRepository (Singleton)
  static SessionRepository create() {
    _instance ??= _createRepository();
    return _instance!;
  }

  /// Crea una nueva instancia del repositorio con sus dependencias
  static SessionRepository _createRepository() {
    final dbHelper = DatabaseHelper();
    final dao = SessionDaoImpl(dbHelper);
    return SessionRepositoryImpl(dao);
  }

  /// Resetea la instancia (útil para testing)
  static void reset() {
    _instance = null;
  }
}
