import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/domain/entities/document_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';

class ValidateRegisterDocumentRegisterUsecase {
  final RegisterRepository _repository;

  ValidateRegisterDocumentRegisterUsecase({
    required RegisterRepository repository,
  }) : _repository = repository;

  Future<Either<AppException, DocumentResponseEntity>> validateDocument({
    required TipoDocumento type,
    required String number,
  }) async {
    return await _repository.validateDocument(type: type, number: number);
  }
}
