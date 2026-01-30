import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/person.dart';

class RepLegalResEntity extends Person {
  final String position;
  const RepLegalResEntity({
    required super.name,
    required super.lastName,
    required super.documentType,
    required super.documentNumber,
    required this.position,
  });

  factory RepLegalResEntity.empty() {
    return const RepLegalResEntity(
      name: '',
      lastName: '',
      documentType: DocumentType.dni,
      documentNumber: '',
      position: '',
    );
  }
  @override
  List<Object?> get props => [...super.props, position];
}
