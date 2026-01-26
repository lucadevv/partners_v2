import 'package:partners/features/auth/register/data/models/document_res_model.dart';
import 'package:partners/features/auth/register/domain/entities/document_response_entity.dart';

class DocumentMapper {
  static DocumentResponseEntity modelToEntity(DocumentResModel model) =>
      DocumentResponseEntity(
        success: model.success ?? false,
        documentNumber: model.data?.documentNumber ?? '',
        name: model.data?.name ?? '',
        lastName: model.data?.lastName,
        birthDate: model.data?.birthDate,
        gender: model.data?.gender,
        address: model.data?.address,
        ubigeo: model.data?.ubigeo,
        manualEntry: model.manualEntry ?? false,
      );
}
