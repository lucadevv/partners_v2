part of 'orquestor_auth_cubit.dart';

abstract class OrquestorAuthEffect extends Equatable {
  const OrquestorAuthEffect();

  @override
  List<Object?> get props => [];
}

class NavigationValidateEffect extends OrquestorAuthEffect {
  const NavigationValidateEffect();
  @override
  List<Object?> get props => [];
}

class NavigationBussinesEffect extends OrquestorAuthEffect {
  const NavigationBussinesEffect();
  @override
  List<Object?> get props => [];
}

class NavigationLoginSuccessEffect extends OrquestorAuthEffect {
  final bool isCompleteData;
  
  const NavigationLoginSuccessEffect({required this.isCompleteData});
  
  @override
  List<Object?> get props => [isCompleteData];
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
  }) => OrquestorAuthState(
    registerState: registerState ?? this.registerState,
    loginState: loginState ?? this.loginState,
    effect: effect ?? this.effect,
  );

  factory OrquestorAuthState.initial() => OrquestorAuthState(
    registerState: RegisterStateX.initial(),
    loginState: LoginState.initial(),
    effect: null,
  );

  @override
  List<Object?> get props => [registerState, loginState, effect];
}
