import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/core/services/database/flags/flags_factory.dart';
import 'package:partners/core/services/database/flags/session_id_flug.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/register/domain/use_case/send_document_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/send_ruc_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/start_register_usecase.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterStateX> with BaseCubitMixin {
  final SendDocumentUsecase _sendDocumentUsecase;
  final SendRucUsecase _sendRucUsecase;
  final StartRegisterUsecase _startRegisterUsecase;
  final SessionIdFlug _sessionFlug = FlagsFactory.createSessionIdFlug();

  RegisterCubit({
    required SendDocumentUsecase sendDocumentUsecase,
    required SendRucUsecase sendRucUsecase,
    required StartRegisterUsecase startRegisterUsecase,
  }) : _sendDocumentUsecase = sendDocumentUsecase,
       _sendRucUsecase = sendRucUsecase,
       _startRegisterUsecase = startRegisterUsecase,
       super(RegisterStateX.initial());

  Future<void> sendRuc({required String ruc, required RucType type}) async {
    if (state.sendRucStatus == RegisterStatus.loading) {
      return;
    }
    emit(state.copyWith(sendRucStatus: RegisterStatus.loading));

    final response = await _sendRucUsecase.call(type: type, ruc: ruc);

    await response.fold(
      (failure) async {
        String errorMessage = getErrorMessage(failure);
        emit(
          state.copyWith(
            sendRucStatus: RegisterStatus.failure,
            errorMessage: errorMessage,
          ),
        );
      },
      (responseEntity) async {
        emit(
          state.copyWith(
            sendRucStatus: RegisterStatus.success,
            rucData: responseEntity,
          ),
        );

        _sessionFlug.saveSessionId(responseEntity.sessionId);
      },
    );
  }

  Future<void> sendDocumendt({
    required DocumentType type,
    required String number,
  }) async {
    if (state.sendDocStatus == RegisterStatus.loading) {
      return;
    }
    emit(state.copyWith(sendDocStatus: RegisterStatus.loading));
    final String? sesionId = _sessionFlug.sessionId;
    final response = await _sendDocumentUsecase.call(
      type: type,
      number: number,
      sesionId: sesionId!,
    );
    await response.fold(
      (failure) async {
        String errorMessage = getErrorMessage(failure);
        emit(
          state.copyWith(
            sendDocStatus: RegisterStatus.failure,
            errorMessage: errorMessage,
          ),
        );
      },
      (responseEntity) async {
        emit(
          state.copyWith(
            sendDocStatus: RegisterStatus.success,
            docData: responseEntity,
          ),
        );
      },
    );
  }

  Future<void> submitStart(RucType rucType) async {
    if (state.sendStartStatus == RegisterStatus.loading) {
      return;
    }
    emit(state.copyWith(sendStartStatus: RegisterStatus.loading));

    final String? sesionId = _sessionFlug.sessionId;

    final response = await _startRegisterUsecase.call(
      type: rucType,
      sessionId: sesionId!,
    );
    await response.fold(
      (failure) async {
        String errorMessage = getErrorMessage(failure);
        emit(
          state.copyWith(
            sendStartStatus: RegisterStatus.failure,
            errorMessage: errorMessage,
          ),
        );
      },
      (responseEntity) async {
        emit(
          state.copyWith(
            sendStartStatus: RegisterStatus.success,
            startRegisterResEntity: responseEntity,
          ),
        );
        print("Start register ${responseEntity.nextStep}");
      },
    );
  }

  void reset() {
    emit(RegisterStateX.initial());
  }
}
