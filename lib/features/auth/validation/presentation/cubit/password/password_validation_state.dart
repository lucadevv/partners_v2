part of 'password_validation_cubit.dart';

enum PasswordValidationStatus { initial, loading, success, failure }

class PasswordValidationState extends Equatable {
  final PasswordValidationStatus status;
  final String? errorMessage;

  const PasswordValidationState({
    this.status = PasswordValidationStatus.initial,
    this.errorMessage,
  });

  PasswordValidationState copyWith({
    PasswordValidationStatus? status,
    String? errorMessage,
  }) {
    return PasswordValidationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory PasswordValidationState.initial() {
    return const PasswordValidationState(
      status: PasswordValidationStatus.initial,
      errorMessage: null,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
