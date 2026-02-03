import 'package:partners/core/utils/models/document_identity.dart';

class Ce extends DocumentIdentity {
  Ce({
    required super.type,
    required super.number,
  });

  @override
  bool isValid() {
    if (number.length <= 9) {
      return false;
    }
    return true;
  }
}
