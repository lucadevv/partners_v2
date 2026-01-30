import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/register/data/models/document_res_model.dart';
import 'package:partners/features/auth/register/domain/entities/rep_legal_response_entity.dart';

class DocumentMapper {
  static RepLegalResEntity modelToEntity(DocumentResModel model) {
    return RepLegalResEntity(
      documentNumber: model.data?.documentNumber ?? '',
      name: model.data?.name ?? '',
      lastName: model.data?.lastName ?? '',
      documentType: _mapDocumentType(model.data?.documentType ?? ''),
      position: '',
    );
  }

  static DocumentType _mapDocumentType(String type) {
    switch (type) {
      case 'dni':
        return DocumentType.dni;
      case 'ce':
        return DocumentType.ce;
      default:
        return DocumentType.dni;
    }
  }
}
