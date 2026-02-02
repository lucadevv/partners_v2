import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/core/services/database/flags/flags_factory.dart';
import 'package:partners/core/services/database/flags/session_id_flug.dart';
import 'package:partners/core/services/database/sqlite/repository/session_repository.dart';
import 'package:partners/core/utils/enums/enums.dart';

import 'package:partners/features/auth/validation/domain/entities/steps_res_entity.dart';
import 'package:partners/features/auth/validation/domain/entities/validation_entity.dart';
import 'package:partners/features/auth/validation/domain/factories/item_factory.dart';
import 'package:partners/features/auth/validation/domain/use_case/get_validation_steps_usecase.dart';

part 'validation_state.dart';

class ValidationCubit extends Cubit<ValidationState> with BaseCubitMixin {
  final GetValidationStepsUsecase _getValidationStepsUsecase;
  final SessionIdFlug _sessionFlug = FlagsFactory.createSessionIdFlug();
  late final SessionRepository _sessionRepository;

  ValidationCubit({
    required GetValidationStepsUsecase getValidationStepsUsecase,
  }) : _getValidationStepsUsecase = getValidationStepsUsecase,
       super(ValidationState.initial());

  Future<void> loadValidationSteps() async {
    emit(state.copyWith(stepsStatus: ValidationStatus.loading));
    final String sessionId = _sessionFlug.sessionId ?? '';
    final result = await _getValidationStepsUsecase(sessionId);
    result.fold(
      (failure) {
        String errorMessage = getErrorMessage(failure);
        emit(
          state.copyWith(
            stepsStatus: ValidationStatus.failure,
            errorMessage: errorMessage,
            validationItems: ItemFactory.getConfig(),
          ),
        );
      },
      (stepsEntity) async {
        final nextStep = stepsEntity.nextStep;

        final updatedItems = ItemFactory.createWithState(
          stepsEntity: stepsEntity,
          nextStep: nextStep,
          rucType: RucType.ruc10,
        );

        emit(
          state.copyWith(
            stepsStatus: ValidationStatus.success,
            stepsEntity: stepsEntity,
            validationItems: updatedItems,
            nextStep: nextStep,
          ),
        );
      },
    );
  }

  Future<void> updateStepStatus({
    required String stepName,
    required bool isCompleted,
  }) async {
    final currentEntity = state.stepsEntity;

    final updatedEntity = _updateStepInEntity(
      currentEntity,
      stepName,
      isCompleted,
    );

    // Obtener el RucType de la sesión
    final String sessionId = _sessionFlug.sessionId ?? '';
    RucType? rucType;
    if (sessionId.isNotEmpty) {
      final session = await _sessionRepository.getSessionBySessionId(sessionId);
      rucType = session?.ruc;
    }

    // Usar directamente el next_step del backend actualizado
    final nextStep = updatedEntity.nextStep;

    final updatedItems = ItemFactory.createWithState(
      stepsEntity: updatedEntity,
      nextStep: nextStep,
      rucType: rucType,
    );

    emit(
      state.copyWith(
        stepsEntity: updatedEntity,
        validationItems: updatedItems,
        nextStep: nextStep,
      ),
    );
  }

  StepsResEntity _updateStepInEntity(
    StepsResEntity entity,
    String stepName,
    bool isCompleted,
  ) {
    final completedSteps = entity.completedSteps;

    return entity.copyWith(
      completedSteps: completedSteps.copyWith(
        emailVerification: stepName == 'email_verification'
            ? isCompleted
            : completedSteps.emailVerification,
        whatsappVerification: stepName == 'whatsapp_verification'
            ? isCompleted
            : completedSteps.whatsappVerification,
        passwordCreation: stepName == 'password_creation'
            ? isCompleted
            : completedSteps.passwordCreation,
        businessVerification: stepName == 'business_verification'
            ? isCompleted
            : completedSteps.businessVerification,
        identityVerification: stepName == 'identity_verification'
            ? isCompleted
            : completedSteps.identityVerification,
      ),
    );
  }

  void reset() {
    emit(ValidationState.initial());
  }

  Future<void> setNextStep(String nextStep) async {
    // Obtener el RucType de la sesión
    final String sessionId = _sessionFlug.sessionId ?? '';
    RucType? rucType;
    if (sessionId.isNotEmpty) {
      final session = await _sessionRepository.getSessionBySessionId(sessionId);
      rucType = session?.ruc;
    }

    final updatedItems = ItemFactory.createWithState(
      stepsEntity: state.stepsEntity,
      nextStep: nextStep,
      rucType: rucType,
    );

    emit(state.copyWith(nextStep: nextStep, validationItems: updatedItems));
  }
}
