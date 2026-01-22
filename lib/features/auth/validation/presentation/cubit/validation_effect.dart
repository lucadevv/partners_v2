part of 'validation_cubit.dart';

/// Effects para navegación y side-effects del ValidationCubit
sealed class ValidationEffect extends Equatable {
  const ValidationEffect();

  @override
  List<Object?> get props => [];
}

class EmailCompletedEffect extends ValidationEffect {
  const EmailCompletedEffect();

  factory EmailCompletedEffect.create() => const EmailCompletedEffect();
}

class WhatsAppCompletedEffect extends ValidationEffect {
  const WhatsAppCompletedEffect();

  factory WhatsAppCompletedEffect.create() => const WhatsAppCompletedEffect();
}

class PasswordCompletedEffect extends ValidationEffect {
  const PasswordCompletedEffect();

  factory PasswordCompletedEffect.create() => const PasswordCompletedEffect();
}

class DocumentCompletedEffect extends ValidationEffect {
  const DocumentCompletedEffect();

  factory DocumentCompletedEffect.create() => const DocumentCompletedEffect();
}

class AllValidationsCompletedEffect extends ValidationEffect {
  const AllValidationsCompletedEffect();

  factory AllValidationsCompletedEffect.create() =>
      const AllValidationsCompletedEffect();
}

extension ValidationEffectX on ValidationEffect {
  static ValidationEffect emailCompleted() => const EmailCompletedEffect();
  static ValidationEffect whatsappCompleted() => const WhatsAppCompletedEffect();
  static ValidationEffect passwordCompleted() => const PasswordCompletedEffect();
  static ValidationEffect documentCompleted() => const DocumentCompletedEffect();
  static ValidationEffect allValidationsCompleted() =>
      const AllValidationsCompletedEffect();
}
