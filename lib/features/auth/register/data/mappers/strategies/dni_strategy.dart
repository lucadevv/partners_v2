import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/features/auth/register/data/mappers/strategies/document_type_strategy.dart';

class DniStrategy implements DocumentTypeStrategy {
  @override
  bool canHandle(String type) => type.toLowerCase() == 'dni';

  @override
  Dni create(String number, String? securityCode) {
    return Dni(
      type: DocumentType.dni,
      number: number,
      securityCode: securityCode ?? '',
    );
  }
}
