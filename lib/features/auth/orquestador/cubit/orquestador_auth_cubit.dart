import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';

part 'orquestador_auth_state.dart';
part 'orquestador_auth_effect.dart';

/// Orquestador principal del flujo de autenticación
/// Coordina el flujo completo: Registro -> Validaciones -> Escaneo -> Negocio -> Éxito
class OrquestadorAuthCubit extends Cubit<OrquestadorAuthState> {
  OrquestadorAuthCubit() : super(const OrquestadorAuthState());

  /// Inicia el flujo de registro
  void startRegistration() {
    emit(
      state.copyWith(
        currentStep: AuthStep.register,
        effect: const NavigateToRegisterEffect(),
      ),
    );
  }

  /// Guarda los datos del registro y avanza a validaciones
  // void completeRegistration(
  //   RegisterEntity entity,
  //   RegisterResponseEntity response,
  // ) {
  //   emit(
  //     state.copyWith(
  //       currentStep: AuthStep.validations,
  //       registerData: entity,
  //       registerResponse: response,
  //       effect: const NavigateToValidationsEffect(),
  //     ),
  //   );
  // }

  /// Marca el email como validado
  void emailValidated(String email) {
    final validations = Map<String, dynamic>.from(state.validations);
    validations['email'] = email;

    emit(state.copyWith(validations: validations));
  }

  /// Marca el WhatsApp como validado
  void whatsappValidated(String phone) {
    final validations = Map<String, dynamic>.from(state.validations);
    validations['whatsapp'] = phone;

    emit(state.copyWith(validations: validations));
  }

  /// Marca la contraseña como guardada
  void passwordSaved(String password) {
    final validations = Map<String, dynamic>.from(state.validations);
    validations['password'] = password;

    emit(state.copyWith(validations: validations));
  }

  /// Completa las validaciones y avanza a escaneo de documento
  void completeValidations() {
    emit(
      state.copyWith(
        currentStep: AuthStep.documentScan,
        effect: const NavigateToDocumentScanEffect(),
      ),
    );
  }

  /// Guarda el documento escaneado y avanza según tipo de RUC
  void documentScanned(String imagePath) {
    // final validations = Map<String, dynamic>.from(state.validations);
    // validations['documentImage'] = imagePath;

    // // Si es RUC 20, ir a validación de negocio
    // final bool isRuc20 = state.registerData?.tipoComercio?.name == 'ruc20';

    // emit(
    //   state.copyWith(
    //     currentStep: isRuc20 ? AuthStep.businessValidation : AuthStep.success,
    //     validations: validations,
    //     effect: isRuc20
    //         ? const NavigateToBusinessValidationEffect()
    //         : const NavigateToSuccessEffect(),
    //   ),
    // );
  }

  /// Valida el negocio (solo para RUC 20)
  void businessValidated(String ruc, String razonSocial) {
    final validations = Map<String, dynamic>.from(state.validations);
    validations['businessRuc'] = ruc;
    validations['businessName'] = razonSocial;

    emit(
      state.copyWith(
        currentStep: AuthStep.success,
        validations: validations,
        effect: const NavigateToSuccessEffect(),
      ),
    );
  }

  /// Marca el proceso como completado
  void completeRegistrationProcess() {
    emit(
      state.copyWith(
        isCompleted: true,
        effect: const RegistrationCompletedEffect(),
      ),
    );
  }

  /// Maneja errores en cualquier paso
  void handleError(String errorMessage) {
    emit(
      state.copyWith(
        hasError: true,
        errorMessage: errorMessage,
        effect: ShowErrorEffect(errorMessage),
      ),
    );
  }

  /// Limpia el effect después de procesarlo
  void clearEffect() {
    emit(state.copyWith(effect: null));
  }

  /// Reinicia todo el flujo
  void reset() {
    emit(const OrquestadorAuthState());
  }

  /// Volver al paso anterior
  void goBack() {
    final previousStep = _getPreviousStep(state.currentStep);
    if (previousStep != null) {
      emit(
        state.copyWith(
          currentStep: previousStep,
          effect: _getNavigationEffect(previousStep),
        ),
      );
    }
  }

  AuthStep? _getPreviousStep(AuthStep current) {
    switch (current) {
      case AuthStep.validations:
        return AuthStep.register;
      case AuthStep.documentScan:
        return AuthStep.validations;
      case AuthStep.businessValidation:
        return AuthStep.documentScan;
      // case AuthStep.success:
      //   return state.registerData?.tipoComercio?.name == 'ruc20'
      //       ? AuthStep.businessValidation
      //       : AuthStep.documentScan;
      default:
        return null;
    }
  }

  OrquestadorAuthEffect? _getNavigationEffect(AuthStep step) {
    switch (step) {
      case AuthStep.register:
        return const NavigateToRegisterEffect();
      case AuthStep.validations:
        return const NavigateToValidationsEffect();
      case AuthStep.documentScan:
        return const NavigateToDocumentScanEffect();
      case AuthStep.businessValidation:
        return const NavigateToBusinessValidationEffect();
      case AuthStep.success:
        return const NavigateToSuccessEffect();
      default:
        return null;
    }
  }
}
