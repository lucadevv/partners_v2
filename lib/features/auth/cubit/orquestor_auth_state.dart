part of 'orquestor_auth_cubit.dart';

abstract class OrquestorAuthEffect extends Equatable {
  const OrquestorAuthEffect();

  @override
  List<Object?> get props => [];
}

class ValidateComerceEffect extends OrquestorAuthEffect {
  const ValidateComerceEffect();

  @override
  List<Object?> get props => [];
}

class NavigateToValidationEffect extends OrquestorAuthEffect {
  const NavigateToValidationEffect();

  @override
  List<Object?> get props => [];
}

class NavigateToDocumentSuccessEffect extends OrquestorAuthEffect {
  const NavigateToDocumentSuccessEffect();

  @override
  List<Object?> get props => [];
}

class NavigateToDashboardEffect extends OrquestorAuthEffect {
  const NavigateToDashboardEffect();

  @override
  List<Object?> get props => [];
}

class NavigateToValidationFromLoginEffect extends OrquestorAuthEffect {
  const NavigateToValidationFromLoginEffect();

  @override
  List<Object?> get props => [];
}

class OrquestorAuthState extends Equatable {
  final RegisterState registerState;
  final LoginState loginState;
  final OrquestorAuthEffect? effect;

  const OrquestorAuthState({
    required this.registerState,
    required this.loginState,
    this.effect,
  });

  OrquestorAuthState copyWith({
    RegisterState? registerState,
    LoginState? loginState,
    OrquestorAuthEffect? effect,
  }) =>
      OrquestorAuthState(
        registerState: registerState ?? this.registerState,
        loginState: loginState ?? this.loginState,
        effect: effect ?? this.effect,
      );

  factory OrquestorAuthState.initial() => OrquestorAuthState(
        registerState: RegisterState.initial(),
        loginState: LoginState.initial(),
        effect: null,
      );

  @override
  List<Object?> get props => [
        registerState,
        loginState,
        effect,
      ];
}
