import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';
import 'package:partners/features/auth/cubit/strategies/navigation_strategy.dart';

class ValidationNavigationStrategy implements NavigationStrategy {
  @override
  bool canHandle(RucType rucType) => rucType != RucType.ruc20;

  @override
  OrquestorAuthEffect getEffect() => const NavigationValidateEffect();
}
