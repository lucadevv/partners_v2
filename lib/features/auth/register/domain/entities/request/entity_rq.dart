import 'package:partners/core/utils/models/entity.dart';

class EntityRq extends Entity {
  const EntityRq({required super.ruc});
  @override
  String getDisplayName() {
    return 'ruc: $ruc';
  }

  Map<String, String> toJson() {
    return {'ruc': ruc};
  }
}
