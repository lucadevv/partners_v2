import 'package:partners/features/auth/validation/domain/entities/steps_res_entity.dart';
import 'package:partners/features/auth/validation/domain/entities/validation_entity.dart';

class ItemFactory {
  static List<ItemValidation> getConfig() {
    return [
      const EmailItemValidation(),
      const PhoneItemValidation(),
      const PasswordItemValidation(),
      const BusinessItemValidation(),
      const IdentityItemValidation(),
    ];
  }

  static List<ItemValidation> createWithState({
    required StepsResEntity stepsEntity,
    required String nextStep,
  }) {
    return getConfig().map((item) {
      final isValid = _getIsValidForItem(item, stepsEntity);
      final state = item.validation(isValid, nextStep);
      return item.copyWith(state: state);
    }).toList();
  }

  static bool _getIsValidForItem(ItemValidation item, StepsResEntity entity) {
    final steps = entity.completedSteps;

    if (item is EmailItemValidation) return steps.emailVerification;
    if (item is PhoneItemValidation) return steps.whatsappVerification;
    if (item is PasswordItemValidation) return steps.passwordCreation;
    if (item is BusinessItemValidation) return steps.businessVerification;
    if (item is IdentityItemValidation) return steps.identityVerification;

    return false;
  }
}
