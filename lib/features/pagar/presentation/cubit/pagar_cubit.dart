import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/pagar/domain/entities/pago_entity.dart';
import 'package:partners/features/pagar/domain/use_case/get_historial_pagos_usecase.dart';
import 'package:partners/features/pagar/domain/use_case/procesar_pago_usecase.dart';
import 'package:partners/features/pagar/presentation/cubit/pagar_state.dart';

class PagarCubit extends Cubit<PagarState> with BaseCubitMixin {
  final GetHistorialPagosUsecase _getHistorialPagosUsecase;
  final ProcesarPagoUsecase _procesarPagoUsecase;

  PagarCubit({
    required GetHistorialPagosUsecase getHistorialPagosUsecase,
    required ProcesarPagoUsecase procesarPagoUsecase,
  })  : _getHistorialPagosUsecase = getHistorialPagosUsecase,
        _procesarPagoUsecase = procesarPagoUsecase,
        super(const PagarState());

  Future<void> loadHistorialPagos() async {
    emit(state.copyWith(status: PagarStatus.loading));
    final result = await _getHistorialPagosUsecase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: PagarStatus.failure,
        errorMessage: getErrorMessage(failure),
      )),
      (pagos) => emit(state.copyWith(
        status: PagarStatus.success,
        historialPagos: pagos,
      )),
    );
  }

  Future<void> procesarPago(PagoEntity pago) async {
    emit(state.copyWith(status: PagarStatus.loading));
    final result = await _procesarPagoUsecase(pago);
    result.fold(
      (failure) => emit(state.copyWith(
        status: PagarStatus.failure,
        errorMessage: getErrorMessage(failure),
      )),
      (pagoCompletado) {
        final nuevosPagos = [pagoCompletado, ...state.historialPagos];
        emit(state.copyWith(
          status: PagarStatus.success,
          historialPagos: nuevosPagos,
        ));
      },
    );
  }
}
