import 'package:partners/features/auth/register/data/models/register_ruc_res_model.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';

class RegisterMapper {
  static RegisterResponseEntity modelToEntity(RegisterRucResModel model) =>
      RegisterResponseEntity(
        isExists: model.isExists ?? false,
        socialReason: model.data?.socialReason ?? '',
      );
}
