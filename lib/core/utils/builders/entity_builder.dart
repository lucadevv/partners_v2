import 'package:partners/core/utils/factories/entity_factory.dart';
import 'package:partners/core/utils/models/entity.dart';

class EntityBuilder {
  String? _ruc;
  String? _name;
  String? _lastName;
  String? _socialRazon;
  String? _typeOfCompany;
  String? _country;

  EntityBuilder setRuc(String ruc) {
    _ruc = ruc;
    return this;
  }

  EntityBuilder setName(String name) {
    _name = name;
    return this;
  }

  EntityBuilder setLastName(String lastName) {
    _lastName = lastName;
    return this;
  }

  EntityBuilder setSocialRazon(String socialRazon) {
    _socialRazon = socialRazon;
    return this;
  }

  EntityBuilder setTypeOfCompany(String typeOfCompany) {
    _typeOfCompany = typeOfCompany;
    return this;
  }

  EntityBuilder setCountry(String country) {
    _country = country;
    return this;
  }

  Entity build() {
    if (_ruc == null) throw Exception("RUC obligatorio");
    Map<String, dynamic> datos = {};
    if (_ruc!.startsWith('10')) {
      datos = {'nombres': _name, 'apellidos': _lastName};
    } else if (_ruc!.startsWith('20')) {
      datos = {'razonSocial': _socialRazon, 'tipoSociedad': _typeOfCompany};
    } else if (_ruc!.startsWith('15')) {
      datos = {'nombre': _name, 'pais': _country};
    }

    return EntityFactory.create(ruc: _ruc!, data: datos);
  }
}
