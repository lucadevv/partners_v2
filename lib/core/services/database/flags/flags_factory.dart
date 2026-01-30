// lib/core/factories/flags_factory.dar
import 'package:partners/core/services/database/flags/session_id_flug.dart';

class FlagsFactory {
  // Cada flag es una nueva instancia, pero todas comparten el mismo SharedPreferences

  static SessionIdFlug createSessionIdFlug() => SessionIdFlug();

  // Método para obtener todos los flags como un mapa (útil para debug)
  static Map<String, dynamic> getAllStoredData() {
    final sessionFlug = createSessionIdFlug();
    return sessionFlug.getAllFlags();
  }
}
