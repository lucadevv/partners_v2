import 'package:equatable/equatable.dart';
import 'package:partners/core/utils/models/document_identity.dart';

class Person extends Equatable {
  final String name;
  final String lastName;
  final DateTime birthDate;
  final String gender;
  final DocumentIdentity documentEdentity;

  const Person({
    required this.name,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.documentEdentity,
  });

  String getFullName() {
    return '$name $lastName';
  }

  String getDocumentInfo() {
    return documentEdentity.info();
  }

  @override
  List<Object?> get props => [name, lastName, documentEdentity];
}
