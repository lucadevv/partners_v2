import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/validation/domain/entities/validation_entity.dart';
import 'package:partners/features/auth/validation/domain/factories/strategies/item_config_strategy.dart';

class BusinessItemStrategy implements ItemConfigStrategy {
  @override
  bool shouldInclude(RucType? rucType) => rucType == RucType.ruc20;

  @override
  List<ItemValidation> getItems() {
    return [const BusinessItemValidation()];
  }
}
