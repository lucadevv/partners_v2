import 'package:partners/features/branches/data/models/branch_model.dart';
import 'package:partners/features/branches/domain/entities/branch_entity.dart';

/// Mapper para convertir entre Model y Entity
/// Sigue el principio de Single Responsibility (SRP)
class BranchMapper {
  static BranchEntity modelToEntity(BranchModel model) {
    return model.toEntity();
  }

  static List<BranchEntity> modelsToEntities(List<BranchModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
