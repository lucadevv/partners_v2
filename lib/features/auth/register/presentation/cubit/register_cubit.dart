import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/auth/register/domain/entities/register_entity.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/use_case/validate_commerce_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> with BaseCubitMixin {
  final ValidateCommerceUsecase _validateCommerceUsecase;

  RegisterCubit({
    required ValidateCommerceUsecase validateCommerceUsecase,
  }) : _validateCommerceUsecase = validateCommerceUsecase,
       super(RegisterState.initial());

  Future<void> validateComerce({
    required RegisterEntity entity,
  }) async {
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
}
