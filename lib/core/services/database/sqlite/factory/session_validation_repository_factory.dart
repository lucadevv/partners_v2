// lib/core/services/database/sqlite/factory/session_validation_repository_factory.dart
import 'package:partners/core/services/database/sqlite/database_helper.dart';
import 'package:partners/core/services/database/sqlite/dao/session_validation_dao.dart';
import 'package:partners/core/services/database/sqlite/repository/session_validation_repository.dart';

/// Factory para crear instancias del SessionValidationRepository
/// Sigue el patrón Factory para centralizar la creación de objetos
class SessionValidationRepositoryFactory {
  static SessionValidationRepository? _instance;

  /// Obtiene una instancia única del SessionValidationRepository (Singleton)
  static SessionValidationRepository create() {
    _instance ??= _createRepository();
    return _instance!;
  }

  /// Crea una nueva instancia del repositorio con sus dependencias
  static SessionValidationRepository _createRepository() {
    final dbHelper = DatabaseHelper();
    final dao = SessionValidationDaoImpl(dbHelper);
    return SessionValidationRepositoryImpl(dao);
  }

  /// Resetea la instancia (útil para testing)
  static void reset() {
    _instance = null;
  }
}
