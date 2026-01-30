import 'package:equatable/equatable.dart';
import 'package:partners/core/utils/enums/enums.dart';

abstract class Person extends Equatable {
  final String name;
  final String lastName;
  final DocumentType documentType;
  final String documentNumber;

  const Person({
    required this.name,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
  });

  String getFullName() {
    return '$name $lastName';
  }

  String getDocumentInfo() {
    return '${documentType.name}: $documentNumber';
  }

  @override
  List<Object?> get props => [name, lastName, documentType, documentNumber];
}
