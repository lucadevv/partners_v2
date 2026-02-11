import 'package:partners/features/para_ti/data/models/recomendacion_model.dart';
import 'package:partners/features/para_ti/domain/entities/recomendacion_entity.dart';

/// Mapper para convertir entre Model y Entity
/// Sigue el principio de Single Responsibility (SRP)
class RecomendacionMapper {
  static RecomendacionEntity modelToEntity(RecomendacionModel model) {
    return model.toEntity();
  }

  static List<RecomendacionEntity> modelsToEntities(
    List<RecomendacionModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
