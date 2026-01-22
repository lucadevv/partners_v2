import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'validation_state.dart';
part 'validation_effect.dart';

/// Cubit para manejar la validación de cuenta (email, whatsapp, password, documento)
class ValidationCubit extends Cubit<ValidationState> {
  ValidationCubit() : super(const ValidationState());

  /// Valida el email y envía OTP
  Future<void> validateEmail(String email) async {
    emit(state.copyWith(status: ValidationStatus.loading));

    try {
      // TODO: Llamar al use case para validar email
      await Future.delayed(const Duration(seconds: 1)); // Mock

      // Simular envío de OTP
      emit(state.copyWith(
        status: ValidationStatus.otpSent,
        validationType: ValidationType.email,
        value: email,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ValidationStatus.failure,
        errorMessage: 'Error al validar email',
      ));
    }
  }

  /// Verifica el código OTP del email
  Future<void> verifyEmailOtp(String code) async {
    emit(state.copyWith(status: ValidationStatus.loading));

    try {
      // TODO: Llamar al use case para verificar OTP
      await Future.delayed(const Duration(seconds: 1)); // Mock

      emit(state.copyWith(
        status: ValidationStatus.stepCompleted,
        completedSteps: {...state.completedSteps, ValidationType.email},
        effect: const EmailCompletedEffect(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ValidationStatus.failure,
        errorMessage: 'Código OTP inválido',
      ));
    }
  }

  /// Valida el WhatsApp y envía OTP
  Future<void> validateWhatsApp(String phone) async {
    emit(state.copyWith(status: ValidationStatus.loading));

    try {
      // TODO: Llamar al use case para validar WhatsApp
      await Future.delayed(const Duration(seconds: 1)); // Mock

      emit(state.copyWith(
        status: ValidationStatus.otpSent,
        validationType: ValidationType.whatsapp,
        value: phone,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ValidationStatus.failure,
        errorMessage: 'Error al validar WhatsApp',
      ));
    }
  }

  /// Verifica el código OTP del WhatsApp
  Future<void> verifyWhatsAppOtp(String code) async {
    emit(state.copyWith(status: ValidationStatus.loading));

    try {
      // TODO: Llamar al use case para verificar OTP
      await Future.delayed(const Duration(seconds: 1)); // Mock

      emit(state.copyWith(
        status: ValidationStatus.stepCompleted,
        completedSteps: {...state.completedSteps, ValidationType.whatsapp},
        effect: const WhatsAppCompletedEffect(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ValidationStatus.failure,
        errorMessage: 'Código OTP inválido',
      ));
    }
  }

  /// Guarda la contraseña
  Future<void> savePassword(String password) async {
    emit(state.copyWith(status: ValidationStatus.loading));

    try {
      // TODO: Llamar al use case para guardar password
      await Future.delayed(const Duration(seconds: 1)); // Mock

      emit(state.copyWith(
        status: ValidationStatus.stepCompleted,
        completedSteps: {...state.completedSteps, ValidationType.password},
        effect: const PasswordCompletedEffect(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ValidationStatus.failure,
        errorMessage: 'Error al guardar contraseña',
      ));
    }
  }

  /// Marca el documento como validado (se hace en otra pantalla)
  void documentValidated() {
    emit(state.copyWith(
      status: ValidationStatus.stepCompleted,
      completedSteps: {...state.completedSteps, ValidationType.document},
      effect: const DocumentCompletedEffect(),
    ));
  }

  /// Verifica si todas las validaciones están completadas
  void checkAllCompleted() {
    if (state.completedSteps.length == 4) {
      emit(state.copyWith(
        status: ValidationStatus.allCompleted,
        effect: const AllValidationsCompletedEffect(),
      ));
    }
  }

  /// Limpia el effect después de procesarlo
  void clearEffect() {
    emit(state.copyWith(effect: null));
  }

  /// Reset del estado
  void reset() {
    emit(const ValidationState());
  }
}
