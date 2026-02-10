import 'package:equatable/equatable.dart';

enum MetodoPago { efectivo, tarjeta, transferencia, yape, plin }

class PagoEntity extends Equatable {
  final String id;
  final double monto;
  final MetodoPago metodoPago;
  final DateTime fecha;
  final String descripcion;
  final bool completado;

  const PagoEntity({
    required this.id,
    required this.monto,
    required this.metodoPago,
    required this.fecha,
    required this.descripcion,
    required this.completado,
  });

  @override
  List<Object?> get props => [id, monto, metodoPago, fecha, descripcion, completado];
}
