part of 'business_validation_cubit.dart';

enum BusinessValidationStatus { initial, loading, success, failure }

class BusinessValidationState extends Equatable {
  final BusinessValidationStatus status;
  final String? errorMessage;
  final BusinessValidationRes? response;
  const BusinessValidationState({
    this.status = BusinessValidationStatus.initial,
    this.errorMessage,
    this.response,
  });

  BusinessValidationState copyWith({
    BusinessValidationStatus? status,
    String? errorMessage,
    BusinessValidationRes? response,
  }) {
    return BusinessValidationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      response: response ?? this.response,
    );
  }

  factory BusinessValidationState.initial() {
    return const BusinessValidationState(
      status: BusinessValidationStatus.initial,
      errorMessage: null,
      response: null,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, response];
}
