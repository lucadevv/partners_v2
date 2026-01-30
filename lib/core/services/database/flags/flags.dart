// lib/core/services/database/flags.dart

import 'package:partners/core/managers/shared_preferences_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Flags {
  /// Guarda cualquier tipo de valor
  Future<void> saveFlag(String key, dynamic value);

  /// Obtiene valor dinámico
  dynamic getFlag(String key);

  /// Obtiene valor tipado
  T? getFlagAs<T>(String key);

  /// Elimina flag
  Future<void> removeFlag(String key);

  /// Verifica existencia
  bool containsFlag(String key);

  /// Obtiene todas las keys
  Set<String> getAllKeys();
}

/// Implementación base que todos los flags compartirán
abstract class BaseFlags implements Flags {
  final SharedPreferences _prefs;

  BaseFlags() : _prefs = SharedPreferencesManager.instance;

  @override
  Future<void> saveFlag(String key, dynamic value) async {
    if (value == null) {
      await removeFlag(key);
      return;
    }

    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else if (value is DateTime) {
      await _prefs.setString(key, value.toIso8601String());
    } else {
      // Para otros tipos, convertimos a String
      await _prefs.setString(key, value.toString());
    }
  }

  @override
  dynamic getFlag(String key) {
    return _prefs.get(key);
  }

  @override
  T? getFlagAs<T>(String key) {
    final value = _prefs.get(key);

    if (value == null) return null;

    // Conversiones específicas
    if (T == DateTime && value is String) {
      return DateTime.tryParse(value) as T?;
    }

    // Para tipos básicos
    try {
      return value as T;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> removeFlag(String key) async {
    await _prefs.remove(key);
  }

  @override
  bool containsFlag(String key) {
    return _prefs.containsKey(key);
  }

  @override
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }

  /// Métodos adicionales útiles
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  Map<String, dynamic> getAllFlags() {
    final result = <String, dynamic>{};
    for (final key in _prefs.getKeys()) {
      result[key] = _prefs.get(key);
    }
    return result;
  }
}
