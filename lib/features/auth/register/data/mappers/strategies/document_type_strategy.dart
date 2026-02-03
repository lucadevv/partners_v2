import 'package:partners/core/utils/models/document_identity.dart';

abstract class DocumentTypeStrategy {
  bool canHandle(String type);
  DocumentIdentity create(String number, String? securityCode);
}
