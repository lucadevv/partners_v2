part of 'register_cubit.dart';

enum RegisterStatus { initial, loading, success, failure }
enum DocumentStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterResponseEntity? responseEntity;
  final RegisterStatus status;
  final String? errorMessage;

  // Campos para validación de documento
  final DocumentResponseEntity? documentResponseEntity;
  final DocumentStatus documentStatus;
  final String? documentErrorMessage;

  const RegisterState({
    this.responseEntity,
    required this.status,
    this.errorMessage,
    this.documentResponseEntity,
    required this.documentStatus,
    this.documentErrorMessage,
  });

  RegisterState copyWith({
    RegisterResponseEntity? responseEntity,
    RegisterStatus? status,
    String? errorMessage,
    DocumentResponseEntity? documentResponseEntity,
    DocumentStatus? documentStatus,
    String? documentErrorMessage,
  }) =>
      RegisterState(
        responseEntity: responseEntity ?? this.responseEntity,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        documentResponseEntity:
            documentResponseEntity ?? this.documentResponseEntity,
        documentStatus: documentStatus ?? this.documentStatus,
        documentErrorMessage:
            documentErrorMessage ?? this.documentErrorMessage,
      );

  factory RegisterState.initial() => const RegisterState(
        responseEntity: null,
        status: RegisterStatus.initial,
        errorMessage: null,
        documentResponseEntity: null,
        documentStatus: DocumentStatus.initial,
        documentErrorMessage: null,
      );

  @override
  List<Object?> get props => [
        responseEntity,
        status,
        errorMessage,
        documentResponseEntity,
        documentStatus,
        documentErrorMessage,
      ];
}
