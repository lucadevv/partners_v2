part of 'register_cubit.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterResponseEntity? responseEntity;
  final RegisterStatus status;
  final String? errorMessage;

  const RegisterState({
    this.responseEntity,
    required this.status,
    this.errorMessage,
  });

  RegisterState copyWith({
    RegisterResponseEntity? responseEntity,
    RegisterStatus? status,
    String? errorMessage,
  }) =>
      RegisterState(
        responseEntity: responseEntity ?? this.responseEntity,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  factory RegisterState.initial() => const RegisterState(
        responseEntity: null,
        status: RegisterStatus.initial,
        errorMessage: null,
      );

  @override
  List<Object?> get props => [responseEntity, status, errorMessage];
}
