part of 'whatsapp_validation_cubit.dart';

enum WhatsappValidationStatus { initial, loading, success, failure }

class WhatsappValidationState extends Equatable {
  final WhatsappValidationStatus status;
  final WhatsappValidationStatus verifyStatus;
  final String? errorMessage;
  final String? debugOtp;
  
  const WhatsappValidationState({
    this.status = WhatsappValidationStatus.initial,
    this.verifyStatus = WhatsappValidationStatus.initial,
    this.errorMessage,
    this.debugOtp,
  });

  WhatsappValidationState copyWith({
    WhatsappValidationStatus? status,
    WhatsappValidationStatus? verifyStatus,
    String? errorMessage,
    String? debugOtp,
  }) {
    return WhatsappValidationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      debugOtp: debugOtp ?? this.debugOtp,
    );
  }

  factory WhatsappValidationState.initial() {
    return const WhatsappValidationState(
      status: WhatsappValidationStatus.initial,
      errorMessage: null,
      verifyStatus: WhatsappValidationStatus.initial,
      debugOtp: null,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, verifyStatus, debugOtp];
}
