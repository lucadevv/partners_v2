import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/services/database/flags/flags_factory.dart';
import 'package:partners/core/services/database/flags/session_id_flug.dart';
import 'package:partners/core/utils/conts/prefers_keys.dart';
import 'package:partners/features/auth/validation/domain/entities/business_validation_res.dart';
import 'package:partners/features/auth/validation/domain/use_case/validate_business_usecase.dart';

part 'business_validation_state.dart';

class BusinessValidationCubit extends Cubit<BusinessValidationState> {
  final ValidateBusinessUsecase _validateBusinessUsecase;

  final SessionIdFlug _sessionFlug = FlagsFactory.createSessionIdFlug();
  BusinessValidationCubit({
    required ValidateBusinessUsecase validateBusinessUsecase,
  }) : _validateBusinessUsecase = validateBusinessUsecase,
       super(BusinessValidationState.initial());

  Future<void> validateBusiness(File rucFile) async {
    final sessionId = _sessionFlug.getFlag(PrefersKeys.sessionId);
    if (state.status == BusinessValidationStatus.loading) return;
    emit(state.copyWith(status: BusinessValidationStatus.loading));
    final response = await _validateBusinessUsecase.call(
      sessionId: sessionId,
      rucFile: rucFile,
    );
    response.fold(
      (failure) {
        print("lucadev ${failure.message}");
        emit(
          state.copyWith(
            status: BusinessValidationStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: BusinessValidationStatus.success,
            response: success,
          ),
        );
      },
    );
  }

  Future<void> resetState() async {
    emit(BusinessValidationState.initial());
  }
}
