import 'package:partners/features/auth/register/data/models/start_register_res_model.dart';
import 'package:partners/features/auth/register/domain/entities/response/start_resgister_res_entity.dart';

class StartRegisterMapper {
  static StartRegisterResEntity modelToEntity(StartRegisterResModel model) =>
      StartRegisterResEntity(
        message: model.message ?? '',
        sessionId: model.sessionId ?? '',
        nextStep: model.nextStep ?? '',
      );
}
