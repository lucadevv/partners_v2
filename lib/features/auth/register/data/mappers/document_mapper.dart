import 'package:partners/core/utils/models/document_identity.dart';
import 'package:partners/features/auth/register/data/mappers/strategies/ce_strategy.dart';
import 'package:partners/features/auth/register/data/mappers/strategies/dni_strategy.dart';
import 'package:partners/features/auth/register/data/mappers/strategies/document_type_strategy.dart';
import 'package:partners/features/auth/register/data/models/document_res_model.dart';
import 'package:partners/features/auth/register/domain/entities/rep_legal_response_entity.dart';

class DocumentMapper {
  static RepLegalResEntity modelToEntity(DocumentResModel model) {
    final data = model.data!;

    return RepLegalResEntity(
      name: data.name ?? '',
      lastName: data.lastName ?? '',

      documentEdentity: _mapDocumentType(
        type: data.documentType ?? '',
        number: data.documentNumber ?? '',
        securityCode: '',
      ),
      position: '',
    );
  }

  static final List<DocumentTypeStrategy> _strategies = [
    DniStrategy(),
    CeStrategy(),
  ];

  static DocumentIdentity _mapDocumentType({
    required String type,
    required String number,
    String? securityCode,
  }) {
    for (final strategy in _strategies) {
      if (strategy.canHandle(type)) {
        return strategy.create(number, securityCode);
      }
    }
    
    return DniStrategy().create(number, securityCode);
  }
}
