import 'package:partners/core/utils/models/document_identity.dart';

// lucadev: Carné de Extranjería (CE) - NO tiene código de seguridad
class Ce extends DocumentIdentity {
  Ce({
    required super.type,
    required super.number,
  });

  @override
  bool isValid() {
    // lucadev: CE debe tener más de 9 caracteres (ej: 007213384)
    if (number.length <= 9) {
      return false;
    }
    return true;
  }
}
