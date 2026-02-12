import 'package:equatable/equatable.dart';

enum CreateBranchStatus {
  initial,
  loading,
  success,
  failure,
}

class CreateBranchState extends Equatable {
  final CreateBranchStatus status;
  /// Mensaje del backend al crear sucursal (ej. "Sucursal creada con éxito").
  final String? successMessage;
  final String? errorMessage;

  const CreateBranchState({
    this.status = CreateBranchStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  CreateBranchState copyWith({
    CreateBranchStatus? status,
    String? successMessage,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CreateBranchState(
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, successMessage, errorMessage];
}
