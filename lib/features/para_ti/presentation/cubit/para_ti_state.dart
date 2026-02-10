import 'package:equatable/equatable.dart';
import 'package:partners/features/para_ti/domain/entities/recomendacion_entity.dart';

class ParaTiState extends Equatable {
  final ParaTiStatus status;
  final List<RecomendacionEntity> recomendaciones;
  final String? errorMessage;

  const ParaTiState({
    this.status = ParaTiStatus.initial,
    this.recomendaciones = const [],
    this.errorMessage,
  });

  ParaTiState copyWith({
    ParaTiStatus? status,
    List<RecomendacionEntity>? recomendaciones,
    String? errorMessage,
  }) {
    return ParaTiState(
      status: status ?? this.status,
      recomendaciones: recomendaciones ?? this.recomendaciones,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, recomendaciones, errorMessage];
}

enum ParaTiStatus { initial, loading, success, failure }
