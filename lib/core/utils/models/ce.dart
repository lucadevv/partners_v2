import 'package:partners/core/utils/models/document_identity.dart';

class Ce extends DocumentIdentity {
  final String? expiryDate;

  Ce({
    required super.type,
    required super.number,
    this.expiryDate,
  });

  @override
  bool isValid() {
    // CE tiene 9 dígitos (ej. 007213384)
    if (number.length != 9) return false;
    if (!RegExp(r'^\d{9}$').hasMatch(number)) return false;
    return true;
  }

  /// Valida si el CE está vencido según fecha de caducidad.
  /// Acepta formatos: DD/MM/YYYY o DD MMM YYYY (ej. 01 MAR 2028).
  bool isExpired() {
    if (expiryDate == null || expiryDate!.trim().isEmpty) return false;

    try {
      String cleanDate = expiryDate!.trim();

      // Formato DD MMM YYYY (ej. 01 MAR 2028)
      final mmmMatch = RegExp(
        r'^(\d{1,2})\s+([A-Z]{3})\s+(\d{4})$',
        caseSensitive: false,
      ).firstMatch(cleanDate);
      if (mmmMatch != null) {
        final day = int.tryParse(mmmMatch.group(1)!);
        final month = _monthAbbrToNumber(mmmMatch.group(2)!);
        final year = int.tryParse(mmmMatch.group(3)!);
        if (day != null && month != null && year != null &&
            day >= 1 && day <= 31 && month >= 1 && month <= 12 &&
            year >= 1900 && year <= 2100) {
          final expDate = DateTime(year, month, day);
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          return expDate.isBefore(today);
        }
      }

      // Formato DD/MM/YYYY
      cleanDate = cleanDate.replaceAll(RegExp(r'[\s-]'), '/');
      cleanDate = cleanDate.replaceAll(RegExp(r'/+'), '/');
      final parts = cleanDate.split('/');
      if (parts.length != 3) return false;

      final day = int.tryParse(parts[0].trim());
      final month = int.tryParse(parts[1].trim());
      final year = int.tryParse(parts[2].trim());
      if (day == null || month == null || year == null) return false;
      if (day < 1 || day > 31 || month < 1 || month > 12 ||
          year < 1900 || year > 2100) return false;

      final expDate = DateTime(year, month, day);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      return expDate.isBefore(today);
    } catch (e) {
      return false;
    }
  }

  static int? _monthAbbrToNumber(String abbr) {
    const months = {
      'ENE': 1, 'JAN': 1, 'FEB': 2, 'MAR': 3, 'ABR': 4, 'APR': 4,
      'MAY': 5, 'JUN': 6, 'JUL': 7, 'AGO': 8, 'AUG': 8,
      'SEP': 9, 'OCT': 10, 'NOV': 11, 'DIC': 12, 'DEC': 12,
    };
    return months[abbr.toUpperCase()];
  }
}
