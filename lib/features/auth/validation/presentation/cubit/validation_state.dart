part of 'validation_cubit.dart';

enum ValidationStatus {
  initial,
  loading,
  otpSent,
  stepCompleted,
  allCompleted,
  failure,
}

enum ValidationType {
  email,
  whatsapp,
  password,
  document,
}

class ValidationState extends Equatable {
  final ValidationStatus status;
  final ValidationType? validationType;
  final String? value;
  final Set<ValidationType> completedSteps;
  final String? errorMessage;
  final ValidationEffect? effect;

  const ValidationState({
    this.status = ValidationStatus.initial,
    this.validationType,
    this.value,
    this.completedSteps = const {},
    this.errorMessage,
    this.effect,
  });

  ValidationState copyWith({
    ValidationStatus? status,
    ValidationType? validationType,
    String? value,
    Set<ValidationType>? completedSteps,
    String? errorMessage,
    ValidationEffect? effect,
  }) {
    return ValidationState(
      status: status ?? this.status,
      validationType: validationType ?? this.validationType,
      value: value ?? this.value,
      completedSteps: completedSteps ?? this.completedSteps,
      errorMessage: errorMessage,
      effect: effect,
    );
  }

  @override
  List<Object?> get props => [
        status,
        validationType,
        value,
        completedSteps,
        errorMessage,
        effect,
      ];
}
