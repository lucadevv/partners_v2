part of 'orquestador_auth_cubit.dart';

/// Effects para navegación del flujo de autenticación
sealed class OrquestadorAuthEffect extends Equatable {
  const OrquestadorAuthEffect();

  @override
  List<Object?> get props => [];
}

class NavigateToRegisterEffect extends OrquestadorAuthEffect {
  const NavigateToRegisterEffect();
}

class NavigateToValidationsEffect extends OrquestadorAuthEffect {
  const NavigateToValidationsEffect();
}

class NavigateToDocumentScanEffect extends OrquestadorAuthEffect {
  const NavigateToDocumentScanEffect();
}

class NavigateToBusinessValidationEffect extends OrquestadorAuthEffect {
  const NavigateToBusinessValidationEffect();
}

class NavigateToSuccessEffect extends OrquestadorAuthEffect {
  const NavigateToSuccessEffect();
}

class RegistrationCompletedEffect extends OrquestadorAuthEffect {
  const RegistrationCompletedEffect();
}

class ShowErrorEffect extends OrquestadorAuthEffect {
  final String message;

  const ShowErrorEffect(this.message);

  @override
  List<Object?> get props => [message];
}

extension OrquestadorAuthEffectX on OrquestadorAuthEffect {
  static OrquestadorAuthEffect navigateToRegister() =>
      const NavigateToRegisterEffect();
  static OrquestadorAuthEffect navigateToValidations() =>
      const NavigateToValidationsEffect();
  static OrquestadorAuthEffect navigateToDocumentScan() =>
      const NavigateToDocumentScanEffect();
  static OrquestadorAuthEffect navigateToBusinessValidation() =>
      const NavigateToBusinessValidationEffect();
  static OrquestadorAuthEffect navigateToSuccess() =>
      const NavigateToSuccessEffect();
  static OrquestadorAuthEffect registrationCompleted() =>
      const RegistrationCompletedEffect();
  static OrquestadorAuthEffect showError(String message) =>
      ShowErrorEffect(message);
}
