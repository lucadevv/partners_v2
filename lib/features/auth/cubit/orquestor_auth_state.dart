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

class OrquestorAuthState extends Equatable {
  final RegisterState registerState;
  final OrquestorAuthEffect? effect;

  const OrquestorAuthState({
    required this.registerState,
    this.effect,
  });

  OrquestorAuthState copyWith({
    RegisterState? registerState,
    OrquestorAuthEffect? effect,
  }) =>
      OrquestorAuthState(
        registerState: registerState ?? this.registerState,
        effect: effect ?? this.effect,
      );

  factory OrquestorAuthState.initial() => OrquestorAuthState(
        registerState: RegisterState.initial(),
        effect: null,
      );

  @override
  List<Object?> get props => [
        registerState,
        effect,
      ];
}
