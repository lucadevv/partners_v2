import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/cubit/orquestor_auth_cubit.dart';

abstract class NavigationStrategy {
  bool canHandle(RucType rucType);
  OrquestorAuthEffect getEffect();
}
