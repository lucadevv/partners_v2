import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/validation/domain/entities/validation_entity.dart';

abstract class ItemConfigStrategy {
  bool shouldInclude(RucType? rucType);
  List<ItemValidation> getItems();
}
