import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/services/database/flags/flags_factory.dart';
import 'package:partners/core/services/database/flags/session_id_flug.dart';
import 'package:partners/features/auth/validation/domain/use_case/send_whatsapp_validation_usecase.dart';
import 'package:partners/features/auth/validation/domain/use_case/verify_whatsapp_otp_usecase.dart';

part 'whatsapp_validation_state.dart';

class WhatsappValidationCubit extends Cubit<WhatsappValidationState> {
  final SendWhatsappValidationUsecase _sendWhatsappValidationUsecase;
  final VerifyWhatsappOtpUsecase _verifyWhatsappOtpUsecase;

  final SessionIdFlug _sessionFlug = FlagsFactory.createSessionIdFlug();

  WhatsappValidationCubit({
    required SendWhatsappValidationUsecase sendWhatsappValidationUsecase,
    required VerifyWhatsappOtpUsecase verifyWhatsappOtpUsecase,
  }) : _sendWhatsappValidationUsecase = sendWhatsappValidationUsecase,
       _verifyWhatsappOtpUsecase = verifyWhatsappOtpUsecase,
       super(WhatsappValidationState.initial());

  Future<void> sendWhatsappValidation(String phone) async {
    final sessionId = _sessionFlug.sessionId ?? '';
    if (sessionId.isEmpty) return;
    if (state.status == WhatsappValidationStatus.loading) return;
    emit(state.copyWith(status: WhatsappValidationStatus.loading));
    final response = await _sendWhatsappValidationUsecase.call(
      sessionId: sessionId,
      phone: phone,
    );
    response.fold(
      (failure) {
        emit(
          state.copyWith(
            status: WhatsappValidationStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            status: WhatsappValidationStatus.success,
            debugOtp: success.debugOtp,
          ),
        );
      },
    );
  }

  Future<void> verifyWhatsappOtp(String otp) async {
    final sessionId = _sessionFlug.sessionId ?? '';
    if (sessionId.isEmpty) return;
    if (state.verifyStatus == WhatsappValidationStatus.loading) return;
    emit(state.copyWith(verifyStatus: WhatsappValidationStatus.loading));
    final response = await _verifyWhatsappOtpUsecase.call(
      sessionId: sessionId,
      otp: otp,
    );
    response.fold(
      (failure) {
        emit(
          state.copyWith(
            verifyStatus: WhatsappValidationStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        print("Verify WhatsApp OTP success: $success");
        emit(state.copyWith(verifyStatus: WhatsappValidationStatus.success));
      },
    );
  }
}
