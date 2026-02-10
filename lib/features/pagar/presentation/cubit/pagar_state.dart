import 'package:equatable/equatable.dart';
import 'package:partners/features/pagar/domain/entities/pago_entity.dart';

class PagarState extends Equatable {
  final PagarStatus status;
  final List<PagoEntity> historialPagos;
  final String? errorMessage;

  const PagarState({
    this.status = PagarStatus.initial,
    this.historialPagos = const [],
    this.errorMessage,
  });

  PagarState copyWith({
    PagarStatus? status,
    List<PagoEntity>? historialPagos,
    String? errorMessage,
  }) {
    return PagarState(
      status: status ?? this.status,
      historialPagos: historialPagos ?? this.historialPagos,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, historialPagos, errorMessage];
}

enum PagarStatus { initial, loading, success, failure }
