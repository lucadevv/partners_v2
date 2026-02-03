import 'package:partners/core/utils/enums/enums.dart';

abstract class DocumentIdentity {
  final DocumentType type;
  final String number;

  const DocumentIdentity({required this.type, required this.number});

  bool isValid();

  String info() => 'type $type number: $number';
}
