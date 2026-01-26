import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/auth/register/domain/entities/document_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';
import 'package:partners/features/auth/register/domain/entities/validate_ruc_entity.dart';
import 'package:partners/features/auth/register/domain/use_case/validate_commerce_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/validate_document_register_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> with BaseCubitMixin {
  final ValidateCommerceUsecase _validateCommerceUsecase;
  final ValidateRegisterDocumentRegisterUsecase _validateDocumentUsecase;

  RegisterCubit({
    required ValidateCommerceUsecase validateCommerceUsecase,
    required ValidateRegisterDocumentRegisterUsecase validateDocumentUsecase,
  }) : _validateCommerceUsecase = validateCommerceUsecase,
       _validateDocumentUsecase = validateDocumentUsecase,
       super(RegisterState.initial());

  Future<void> validateComerce({required ValidateRucEntity entity}) async {
    if (state.status == RegisterStatus.loading) {
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading));

    final response = await _validateCommerceUsecase.validateComerce(
      entity: entity,
    );

    await response.fold(
      (failure) async {
        String errorMessage = getErrorMessage(failure);

        emit(
          state.copyWith(
            status: RegisterStatus.failure,
            errorMessage: errorMessage,
          ),
        );
      },
      (responseEntity) async {
        emit(
          state.copyWith(
            responseEntity: responseEntity,
            status: RegisterStatus.success,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> validateDocument({
    required TipoDocumento type,
    required String number,
  }) async {
    if (state.documentStatus == DocumentStatus.loading) {
      return;
    }

    emit(state.copyWith(documentStatus: DocumentStatus.loading));

    final response = await _validateDocumentUsecase.validateDocument(
      type: type,
      number: number,
    );

    await response.fold(
      (failure) async {
        String errorMessage = getErrorMessage(failure);
        print('errorMessage validateDocument $errorMessage');
        emit(
          state.copyWith(
            documentStatus: DocumentStatus.failure,
            documentErrorMessage: errorMessage,
          ),
        );
      },
      (responseEntity) async {
        print("validateDocument success ${responseEntity.name}");
        emit(
          state.copyWith(
            documentResponseEntity: responseEntity,
            documentStatus: DocumentStatus.success,
            documentErrorMessage: null,
          ),
        );
      },
    );
  }

  void reset() {
    emit(RegisterState.initial());
  }
}
