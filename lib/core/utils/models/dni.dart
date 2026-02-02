import 'package:partners/core/utils/models/document_identity.dart';

// lucadev: DNI peruano - incluye código de seguridad (ej: 73694046-4)
class Dni extends DocumentIdentity {
  final String securityCode; // lucadev: Código de seguridad único del DNI (dígito después del guion)
  final String? expiryDate;

  Dni({
    required super.type,
    required super.number,
    required this.securityCode, // lucadev: Requerido solo para DNI
    this.expiryDate,
  });

  @override
  bool isValid() {
    // lucadev: DNI debe tener 8 dígitos y código de seguridad de 1 dígito
    if (number.length != 8) return false;
    if (securityCode.isEmpty || securityCode.length != 1) return false;
    return true;
  }

  // lucadev: Método para obtener el número completo con código de seguridad
  String getFullNumber() => '$number-$securityCode';

  @override
  String info() => 'type $type number: $number, security code: $securityCode';

  bool isExpired() {
    if (expiryDate == null) return false;

    try {
      final cleanDate = expiryDate!.replaceAll(' ', '/');
      final parts = cleanDate.split('/');

      if (parts.length != 3) return false;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final expDate = DateTime(year, month, day);
      final now = DateTime.now();

      return expDate.isBefore(DateTime(now.year, now.month, now.day));
    } catch (e) {
      return false;
    }
  }
}
