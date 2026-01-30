import 'package:partners/core/utils/models/entity.dart';

class ForeingPerson extends Entity {
  final String country;

  const ForeingPerson({required super.ruc, required this.country});

  @override
  String getDisplayName() {
    return country;
  }
}
