import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/ce.dart';
import 'package:partners/features/auth/register/data/mappers/strategies/document_type_strategy.dart';

class CeStrategy implements DocumentTypeStrategy {
  @override
  bool canHandle(String type) => type.toLowerCase() == 'ce';

  @override
  Ce create(String number, String? securityCode) {
    return Ce(
      type: DocumentType.ce,
      number: number,
    );
  }
}
