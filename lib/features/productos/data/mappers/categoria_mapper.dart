import 'package:partners/features/productos/data/models/categoria_model.dart';
import 'package:partners/features/productos/domain/entities/categoria_entity.dart';

/// Mapper para convertir entre Model y Entity
/// Sigue el principio de Single Responsibility (SRP)
class CategoriaMapper {
  static CategoriaEntity modelToEntity(CategoriaModel model) {
    return model.toEntity();
  }

  static List<CategoriaEntity> modelsToEntities(
    List<CategoriaModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }
}
