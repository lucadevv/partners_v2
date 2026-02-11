import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/promos/domain/use_case/get_promos_usecase.dart';
import 'package:partners/features/promos/presentation/cubit/promos_state.dart';

/// Cubit de la pantalla de listado de promos.
/// Sigue el principio de responsabilidad única (SRP).
class PromosCubit extends Cubit<PromosState> with BaseCubitMixin {
  final GetPromosUsecase _getPromosUsecase;

  PromosCubit({
    required GetPromosUsecase getPromosUsecase,
  })  : _getPromosUsecase = getPromosUsecase,
        super(const PromosState());

  /// Carga la lista de promociones (usado por RefreshIndicator y por Reintentar).
  Future<void> loadPromos() async {
    emit(state.copyWith(status: PromosStatus.loading));

    final result = await _getPromosUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: PromosStatus.failure,
          errorMessage: getErrorMessage(failure),
        ));
      },
      (promos) {
        emit(state.copyWith(
          status: PromosStatus.success,
          promos: promos,
        ));
      },
    );
  }
}
