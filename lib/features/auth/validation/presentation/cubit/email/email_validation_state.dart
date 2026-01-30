part of 'email_validation_cubit.dart';

enum EmailValidationStatus { initial, loading, success, failure }

class EmailValidationState extends Equatable {
  final EmailValidationStatus status;
  final EmailValidationStatus resendStatus;
  final String? errorMessage;
  const EmailValidationState({
    this.status = EmailValidationStatus.initial,
    this.resendStatus = EmailValidationStatus.initial,
    this.errorMessage,
  });

  EmailValidationState copyWith({
    EmailValidationStatus? status,
    EmailValidationStatus? resendStatus,
    String? errorMessage,
  }) {
    return EmailValidationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      resendStatus: resendStatus ?? this.resendStatus,
    );
  }

  factory EmailValidationState.initial() {
    return const EmailValidationState(
      status: EmailValidationStatus.initial,
      errorMessage: null,
      resendStatus: EmailValidationStatus.initial,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, resendStatus];
}
