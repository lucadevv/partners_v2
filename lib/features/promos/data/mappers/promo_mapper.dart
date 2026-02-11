import 'package:partners/features/promos/data/models/promo_model.dart';
import 'package:partners/features/promos/domain/entities/promo_entity.dart';

/// Mapper entre Model (Data) y Entity (Domain).
/// Sigue el principio de responsabilidad única (SRP).
class PromoMapper {
  static PromoEntity modelToEntity(PromoModel model) {
    return model.toEntity();
  }

  static List<PromoEntity> modelsToEntities(List<PromoModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
