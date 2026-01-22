part of 'business_validation_cubit.dart';

enum BusinessValidationStatus {
  initial,
  loading,
  success,
  failure,
}

class BusinessValidationState extends Equatable {
  final BusinessValidationStatus status;
  final String? ruc;
  final String? razonSocial;
  final String? errorMessage;
  final BusinessValidationEffect? effect;

  const BusinessValidationState({
    this.status = BusinessValidationStatus.initial,
    this.ruc,
    this.razonSocial,
    this.errorMessage,
    this.effect,
  });

  BusinessValidationState copyWith({
    BusinessValidationStatus? status,
    String? ruc,
    String? razonSocial,
    String? errorMessage,
    BusinessValidationEffect? effect,
  }) {
    return BusinessValidationState(
      status: status ?? this.status,
      ruc: ruc ?? this.ruc,
      razonSocial: razonSocial ?? this.razonSocial,
      errorMessage: errorMessage,
      effect: effect,
    );
  }

  @override
  List<Object?> get props => [
        status,
        ruc,
        razonSocial,
        errorMessage,
        effect,
      ];
}
