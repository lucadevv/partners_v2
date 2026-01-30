part of 'orquestador_auth_cubit.dart';

enum AuthStep {
  initial,
  register,
  validations,
  documentScan,
  businessValidation,
  success,
}

class OrquestadorAuthState extends Equatable {
  final AuthStep currentStep;
  final RegisterResponseEntity? registerResponse;
  final Map<String, dynamic> validations;
  final bool isCompleted;
  final bool hasError;
  final String? errorMessage;
  final OrquestadorAuthEffect? effect;

  const OrquestadorAuthState({
    this.currentStep = AuthStep.initial,

    this.registerResponse,
    this.validations = const {},
    this.isCompleted = false,
    this.hasError = false,
    this.errorMessage,
    this.effect,
  });

  OrquestadorAuthState copyWith({
    AuthStep? currentStep,

    RegisterResponseEntity? registerResponse,
    Map<String, dynamic>? validations,
    bool? isCompleted,
    bool? hasError,
    String? errorMessage,
    OrquestadorAuthEffect? effect,
  }) {
    return OrquestadorAuthState(
      currentStep: currentStep ?? this.currentStep,

      registerResponse: registerResponse ?? this.registerResponse,
      validations: validations ?? this.validations,
      isCompleted: isCompleted ?? this.isCompleted,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      effect: effect,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,

    registerResponse,
    validations,
    isCompleted,
    hasError,
    errorMessage,
    effect,
  ];
}
