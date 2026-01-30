import 'package:partners/features/auth/validation/data/models/steps_res_model.dart';
import 'package:partners/features/auth/validation/domain/entities/steps_res_entity.dart';

class ValidationMapper {
  static StepsResEntity mapToEntity(StepsResModel model) {
    return StepsResEntity(
      nextStep: model.nextStep ?? '',
      completedSteps: mapCompletedStepsToEntity(model.completedSteps!),
    );
  }

  static CompletedStepsEntity mapCompletedStepsToEntity(
    CompletedStepsModel model,
  ) {
    return CompletedStepsEntity(
      emailVerification: model.emailVerification ?? false,
      whatsappVerification: model.whatsappVerification ?? false,
      businessVerification: model.businessVerification ?? false,
      identityVerification: model.identityVerification ?? false,
      passwordCreation: model.passwordCreation ?? false,
    );
  }
}
