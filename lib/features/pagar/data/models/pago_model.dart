import 'package:partners/features/pagar/domain/entities/pago_entity.dart';

class PagoModel extends PagoEntity {
  const PagoModel({
    required super.id,
    required super.monto,
    required super.metodoPago,
    required super.fecha,
    required super.descripcion,
    required super.completado,
  });

  factory PagoModel.fromJson(Map<String, dynamic> json) {
    return PagoModel(
      id: json['id'] as String,
      monto: (json['monto'] as num).toDouble(),
      metodoPago: MetodoPago.values.firstWhere(
        (e) => e.name == json['metodoPago'],
        orElse: () => MetodoPago.efectivo,
      ),
      fecha: DateTime.parse(json['fecha'] as String),
      descripcion: json['descripcion'] as String,
      completado: json['completado'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monto': monto,
      'metodoPago': metodoPago.name,
      'fecha': fecha.toIso8601String(),
      'descripcion': descripcion,
      'completado': completado,
    };
  }

  PagoEntity toEntity() {
    return PagoEntity(
      id: id,
      monto: monto,
      metodoPago: metodoPago,
      fecha: fecha,
      descripcion: descripcion,
      completado: completado,
    );
  }
}
