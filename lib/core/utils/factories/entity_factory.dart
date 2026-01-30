import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/artificial_person.dart';
import 'package:partners/core/utils/models/entity.dart';
import 'package:partners/core/utils/models/foreing_person.dart';
import 'package:partners/core/utils/models/natural_person.dart';

class EntityFactory {
  static Entity create({
    required String ruc,
    required Map<String, dynamic> data, // Datos opcionales
  }) {
    // Automatiza la creación basándose en el prefijo del RUC
    if (ruc.startsWith('10')) {
      return NaturalPerson(
        ruc: ruc,
        name: data['name'] ?? '',
        lastName: data['lastName'] ?? '',
      );
    }
    if (ruc.startsWith('20')) {
      return ArtificialPerson(
        ruc: ruc,
        socialReason: data['razonSocial'] ?? '',
        typeOfCompany: data['typeOfSociety'] ?? SocietyType.sac,
      );
    }
    if (ruc.startsWith('15')) {
      return ForeingPerson(ruc: ruc, country: data['country'] ?? '');
    }
    throw Exception("Tipo de RUC no soportado");
  }
}
