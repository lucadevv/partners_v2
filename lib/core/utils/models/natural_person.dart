import 'package:partners/core/utils/models/entity.dart';

class NaturalPerson extends Entity {
  final String name;
  final String lastName;

  const NaturalPerson({
    required super.ruc,
    required this.name,
    required this.lastName,
  });

  @override
  String getDisplayName() {
    return '$name $lastName';
  }
}
