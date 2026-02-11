import 'package:equatable/equatable.dart';
import 'package:partners/features/promos/domain/entities/promo_entity.dart';

/// Estados del PromosCubit.
enum PromosStatus {
  initial,
  loading,
  success,
  failure,
}

/// Estado del PromosCubit.
class PromosState extends Equatable {
  final PromosStatus status;
  final List<PromoEntity> promos;
  final String? errorMessage;

  const PromosState({
    this.status = PromosStatus.initial,
    this.promos = const [],
    this.errorMessage,
  });

  PromosState copyWith({
    PromosStatus? status,
    List<PromoEntity>? promos,
    String? errorMessage,
  }) {
    return PromosState(
      status: status ?? this.status,
      promos: promos ?? this.promos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, promos, errorMessage];
}
