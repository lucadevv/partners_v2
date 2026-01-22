import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'business_validation_state.dart';
part 'business_validation_effect.dart';

/// Cubit para validar el negocio/empresa (RUC 20)
class BusinessValidationCubit extends Cubit<BusinessValidationState> {
  BusinessValidationCubit() : super(const BusinessValidationState());

  /// Valida el RUC del negocio
  Future<void> validateBusinessRuc(String ruc) async {
    emit(state.copyWith(status: BusinessValidationStatus.loading));

    try {
      // TODO: Llamar al use case para validar RUC
      await Future.delayed(const Duration(seconds: 1)); // Mock

      // Simular respuesta con razón social
      emit(state.copyWith(
        status: BusinessValidationStatus.success,
        ruc: ruc,
        razonSocial: 'MARKETRIX S.A.C.',
        effect: const RucValidatedEffect(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BusinessValidationStatus.failure,
        errorMessage: 'RUC no encontrado',
      ));
    }
  }

  /// Confirmar y continuar
  void confirm() {
    if (state.razonSocial != null) {
      emit(state.copyWith(
        effect: const ValidationCompletedEffect(),
      ));
    }
  }

  /// Limpia el effect después de procesarlo
  void clearEffect() {
    emit(state.copyWith(effect: null));
  }

  /// Reset del estado
  void reset() {
    emit(const BusinessValidationState());
  }
}
