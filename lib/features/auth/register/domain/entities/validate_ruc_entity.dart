import 'package:equatable/equatable.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_comercio.dart';

/// Entidad simple para validar RUC
/// Solo contiene el tipo de comercio y el RUC completo
class ValidateRucEntity extends Equatable {
  final TipoComercio tipoComercio;
  final String ruc;

  const ValidateRucEntity({required this.tipoComercio, required this.ruc});

  @override
  List<Object> get props => [tipoComercio, ruc];

  Map<String, dynamic> toJson() {
    return {'ruc': ruc};
  }

  @override
  String toString() {
    return 'ValidateRucEntity(tipoComercio: $tipoComercio, ruc: $ruc)';
  }
}
