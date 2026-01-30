import 'package:partners/core/utils/enums/enums.dart';

class DocumentRq {
  final String sesionId;
  final String number;
  final DocumentType type;
  DocumentRq({
    required this.number,
    required this.type,
    required this.sesionId,
  });

  Map<String, String> toJson() {
    return {'session_id': sesionId, 'number': number, 'type': type.name};
  }
}
