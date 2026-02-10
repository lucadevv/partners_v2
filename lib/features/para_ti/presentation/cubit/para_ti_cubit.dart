import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/para_ti/domain/use_case/get_recomendaciones_usecase.dart';
import 'package:partners/features/para_ti/presentation/cubit/para_ti_state.dart';

class ParaTiCubit extends Cubit<ParaTiState> with BaseCubitMixin {
  final GetRecomendacionesUsecase _getRecomendacionesUsecase;

  ParaTiCubit({required GetRecomendacionesUsecase getRecomendacionesUsecase})
      : _getRecomendacionesUsecase = getRecomendacionesUsecase,
        super(const ParaTiState());

  Future<void> loadRecomendaciones() async {
    emit(state.copyWith(status: ParaTiStatus.loading));
    final result = await _getRecomendacionesUsecase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: ParaTiStatus.failure,
        errorMessage: getErrorMessage(failure),
      )),
      (recomendaciones) => emit(state.copyWith(
        status: ParaTiStatus.success,
        recomendaciones: recomendaciones,
      )),
    );
  }
}
