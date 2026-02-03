import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/core/utils/models/document_identity.dart';

class RepLegalResEntity {
  final String name;
  final String lastName;
  final DocumentIdentity documentEdentity;
  final String position;

  const RepLegalResEntity({
    required this.name,
    required this.lastName,
    required this.documentEdentity,
    required this.position,
  });

  factory RepLegalResEntity.empty() => RepLegalResEntity(
    name: '',
    lastName: '',
    documentEdentity: Dni(type: DocumentType.dni, number: '', securityCode: ''),
    position: '',
  );

  String get getFullName => '$name $lastName';
}
