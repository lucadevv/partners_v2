import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/validation/domain/entities/steps_res_entity.dart';
import 'package:partners/features/auth/validation/domain/entities/validation_entity.dart';
import 'package:partners/features/auth/validation/domain/factories/strategies/base_items_strategy.dart';
import 'package:partners/features/auth/validation/domain/factories/strategies/business_item_strategy.dart';
import 'package:partners/features/auth/validation/domain/factories/strategies/final_items_strategy.dart';
import 'package:partners/features/auth/validation/domain/factories/strategies/item_config_strategy.dart';

class ItemFactory {
  static final List<ItemConfigStrategy> _strategies = [
    BaseItemsStrategy(),
    BusinessItemStrategy(),
    FinalItemsStrategy(),
  ];

  static List<ItemValidation> getConfig({RucType? rucType}) {
    final items = <ItemValidation>[];
    
    for (final strategy in _strategies) {
      if (strategy.shouldInclude(rucType)) {
        items.addAll(strategy.getItems());
      }
    }
    
    return items;
  }

  static List<ItemValidation> createWithState({
    required StepsResEntity stepsEntity,
    required String nextStep,
    RucType? rucType,
  }) {
    return getConfig(rucType: rucType).map((item) {
      final isValid = item.isValid(stepsEntity);
      final state = item.validation(isValid, nextStep);
      return item.copyWith(state: state);
    }).toList();
  }
}
