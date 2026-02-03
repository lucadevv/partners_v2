import 'package:partners/core/utils/models/document_identity.dart';

class Dni extends DocumentIdentity {
  final String securityCode;
  final String? expiryDate;

  Dni({
    required super.type,
    required super.number,
    required this.securityCode,
    this.expiryDate,
  });

  @override
  bool isValid() {
    if (number.length != 8) return false;
    if (securityCode.isEmpty || securityCode.length != 1) return false;
    return true;
  }

  String getFullNumber() => '$number-$securityCode';

  @override
  String info() => 'type $type number: $number, security code: $securityCode';

  bool isExpired() {
    if (expiryDate == null || expiryDate!.isEmpty) return false;

    try {
      // Normalizar la fecha: reemplazar espacios y guiones por "/"
      String cleanDate = expiryDate!.trim();
      cleanDate = cleanDate.replaceAll(RegExp(r'[\s-]'), '/');

      // Asegurarse de que solo haya "/" como separador
      cleanDate = cleanDate.replaceAll(RegExp(r'/+'), '/');

      final parts = cleanDate.split('/');

      if (parts.length != 3) return false;

      // Parsear los componentes de la fecha
      final day = int.tryParse(parts[0].trim());
      final month = int.tryParse(parts[1].trim());
      final year = int.tryParse(parts[2].trim());

      if (day == null || month == null || year == null) return false;

      // Validar rangos válidos
      if (day < 1 || day > 31) return false;
      if (month < 1 || month > 12) return false;
      if (year < 1900 || year > 2100) return false;

      // Crear la fecha de expiración del documento
      final expDate = DateTime(year, month, day);

      // Obtener la fecha actual del sistema (sin horas/minutos/segundos)
      // Esto permite validar documentos de cualquier año comparándolos con la fecha de hoy
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Comparar: si la fecha de expiración es anterior a la fecha actual, está vencido
      // Ejemplo: si hoy es 3 de febrero de 2026 y el documento vence el 2 de febrero de 2026, está vencido
      return expDate.isBefore(today);
    } catch (e) {
      // Si hay cualquier error al parsear, considerar que no está vencido
      // (mejor no bloquear al usuario por un error de parsing)
      return false;
    }
  }
}
