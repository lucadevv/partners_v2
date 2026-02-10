import 'package:partners/features/productos/data/models/producto_model.dart';
import 'package:partners/features/productos/domain/entities/producto_entity.dart';

/// Mapper para convertir entre Model y Entity
/// Sigue el principio de Single Responsibility (SRP)
class ProductoMapper {
  static ProductoEntity modelToEntity(ProductoModel model) {
    return model.toEntity();
  }

  static List<ProductoEntity> modelsToEntities(List<ProductoModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
