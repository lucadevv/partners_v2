import 'package:partners/core/utils/enums/enums.dart';

// lucadev: Clase abstracta base para documentos de identidad
// lucadev: El código de seguridad solo pertenece al DNI, no al CE
abstract class DocumentIdentity {
  final DocumentType type;
  final String number;

  DocumentIdentity({required this.type, required this.number});

  bool isValid();

  String info() => 'type $type number: $number';
}
