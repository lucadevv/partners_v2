part of 'business_validation_cubit.dart';

/// Effects para navegación y side-effects del BusinessValidationCubit
sealed class BusinessValidationEffect extends Equatable {
  const BusinessValidationEffect();

  @override
  List<Object?> get props => [];
}

class RucValidatedEffect extends BusinessValidationEffect {
  const RucValidatedEffect();

  factory RucValidatedEffect.create() => const RucValidatedEffect();
}

class ValidationCompletedEffect extends BusinessValidationEffect {
  const ValidationCompletedEffect();

  factory ValidationCompletedEffect.create() =>
      const ValidationCompletedEffect();
}

extension BusinessValidationEffectX on BusinessValidationEffect {
  static BusinessValidationEffect rucValidated() => const RucValidatedEffect();
  static BusinessValidationEffect validationCompleted() =>
      const ValidationCompletedEffect();
}
