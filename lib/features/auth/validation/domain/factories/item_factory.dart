import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/validation/domain/entities/steps_res_entity.dart';
import 'package:partners/features/auth/validation/domain/entities/validation_entity.dart';

class ItemFactory {
  static List<ItemValidation> getConfig({RucType? rucType}) {
    final items = <ItemValidation>[
      const EmailItemValidation(),
      const PhoneItemValidation(),
    ];
    
    // Solo agregar BusinessItemValidation si es ruc20
    if (rucType == RucType.ruc20) {
      items.add(const BusinessItemValidation());
    }
    
    items.addAll([
      const IdentityItemValidation(),
      const PasswordItemValidation(),
    ]);
    
    return items;
  }

  static List<ItemValidation> createWithState({
    required StepsResEntity stepsEntity,
    required String nextStep,
    RucType? rucType,
  }) {
    return getConfig(rucType: rucType).map((item) {
      final isValid = _getIsValidForItem(item, stepsEntity);
      final state = item.validation(isValid, nextStep);
      return item.copyWith(state: state);
    }).toList();
  }

  static bool _getIsValidForItem(ItemValidation item, StepsResEntity entity) {
    final steps = entity.completedSteps;

    if (item is EmailItemValidation) return steps.emailVerification;
    if (item is PhoneItemValidation) return steps.whatsappVerification;
    if (item is BusinessItemValidation) return steps.businessVerification;
    if (item is IdentityItemValidation) return steps.identityVerification;
    if (item is PasswordItemValidation) return steps.passwordCreation;

    return false;
  }
}
