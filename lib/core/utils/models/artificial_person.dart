import 'package:partners/core/utils/models/entity.dart';

class ArtificialPerson extends Entity {
  final String socialReason;
  final String typeOfCompany;

  const ArtificialPerson({
    required super.ruc,
    required this.socialReason,
    required this.typeOfCompany,
  });

  @override
  String getDisplayName() {
    return "$socialReason $typeOfCompany";
  }
}
