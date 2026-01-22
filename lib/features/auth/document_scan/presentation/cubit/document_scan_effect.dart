part of 'document_scan_cubit.dart';

/// Effects para navegación y side-effects del DocumentScanCubit
sealed class DocumentScanEffect extends Equatable {
  const DocumentScanEffect();

  @override
  List<Object?> get props => [];
}

class DocumentValidatedEffect extends DocumentScanEffect {
  const DocumentValidatedEffect();

  factory DocumentValidatedEffect.create() => const DocumentValidatedEffect();
}

class NavigateToBusinessValidationEffect extends DocumentScanEffect {
  const NavigateToBusinessValidationEffect();

  factory NavigateToBusinessValidationEffect.create() =>
      const NavigateToBusinessValidationEffect();
}

extension DocumentScanEffectX on DocumentScanEffect {
  static DocumentScanEffect documentValidated() =>
      const DocumentValidatedEffect();
  static DocumentScanEffect navigateToBusinessValidation() =>
      const NavigateToBusinessValidationEffect();
}
