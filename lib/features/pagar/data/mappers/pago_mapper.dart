import 'package:partners/features/pagar/data/models/pago_model.dart';
import 'package:partners/features/pagar/domain/entities/pago_entity.dart';

/// Mapper para convertir entre Model y Entity
/// Sigue el principio de Single Responsibility (SRP)
class PagoMapper {
  static PagoEntity modelToEntity(PagoModel model) {
    return model.toEntity();
  }

  static List<PagoEntity> modelsToEntities(List<PagoModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  static PagoModel entityToModel(PagoEntity entity) {
    return PagoModel(
      id: entity.id,
      monto: entity.monto,
      metodoPago: entity.metodoPago,
      fecha: entity.fecha,
      descripcion: entity.descripcion,
      completado: entity.completado,
    );
  }
}
