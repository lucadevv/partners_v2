import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/ce.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/core/utils/models/document_identity.dart';
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

  // lucadev: Mapea el tipo de documento desde el modelo a la entidad
  // lucadev: El código de seguridad solo se usa para DNI
  static DocumentIdentity _mapDocumentType({
    required String type,
    required String number,
    String? securityCode,
  }) {
    final typeLower = type.toLowerCase();

    switch (typeLower) {
      case 'dni':
        return Dni(
          type: DocumentType.dni,
          number: number,
          securityCode: securityCode ?? '', // lucadev: Código de seguridad solo para DNI
        );

      case 'ce':
        return Ce(
          type: DocumentType.ce,
          number: number,
          // lucadev: CE no tiene código de seguridad
        );

      default:
        return Dni(
          type: DocumentType.dni,
          number: number,
          securityCode: securityCode ?? '',
        );
    }
  }
}
