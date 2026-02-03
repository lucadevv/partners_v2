import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/services/database/flags/flags_factory.dart';
import 'package:partners/core/services/database/flags/session_id_flug.dart';
import 'package:partners/core/utils/conts/prefers_keys.dart';
import 'package:partners/features/auth/validation/domain/use_case/resend_email_code_usecase.dart';
import 'package:partners/features/auth/validation/domain/use_case/send_email_validation_usecase.dart';

part 'email_validation_state.dart';

class EmailValidationCubit extends Cubit<EmailValidationState> {
  final SendEmailValidationUsecase _sendEmailValidationUsecase;
  final ResendEmailCodeUsecase _resendEmailCodeUsecase;

  final SessionIdFlug _sessionFlug = FlagsFactory.createSessionIdFlug();
  EmailValidationCubit({
    required SendEmailValidationUsecase sendEmailValidationUsecase,
    required ResendEmailCodeUsecase resendEmailCodeUsecase,
  }) : _sendEmailValidationUsecase = sendEmailValidationUsecase,
       _resendEmailCodeUsecase = resendEmailCodeUsecase,
       super(EmailValidationState.initial());

  Future<void> sendEmailValidation(String email) async {
    final sessionId = _sessionFlug.getFlag(PrefersKeys.sessionId);
    if (state.status == EmailValidationStatus.loading) return;
    emit(state.copyWith(status: EmailValidationStatus.loading));
    final response = await _sendEmailValidationUsecase.call(
      sessionId: sessionId,
      email: email,
    );
    response.fold(
      (failure) {
        emit(
          state.copyWith(
            status: EmailValidationStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(state.copyWith(status: EmailValidationStatus.success));
      },
    );
  }

  Future<void> resendEmailCode(String otp) async {
    final sessionId = _sessionFlug.getFlag(PrefersKeys.sessionId);
    if (state.resendStatus == EmailValidationStatus.loading) return;
    emit(state.copyWith(resendStatus: EmailValidationStatus.loading));
    final response = await _resendEmailCodeUsecase.call(
      sessionId: sessionId,
      otp: otp,
    );
    response.fold(
      (failure) {
        emit(
          state.copyWith(
            resendStatus: EmailValidationStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(state.copyWith(resendStatus: EmailValidationStatus.success));
      },
    );
  }

  Future<void> resetState() async {
    emit(EmailValidationState.initial());
  }
}
