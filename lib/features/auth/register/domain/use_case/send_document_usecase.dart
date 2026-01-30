import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/domain/entities/rep_legal_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/request/document_rq.dart';
import 'package:partners/features/auth/register/domain/factory/doc_config_factory.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';

class SendDocumentUsecase {
  final RegisterRepository _repository;

  SendDocumentUsecase({required RegisterRepository repository})
    : _repository = repository;

  Future<Either<AppException, RepLegalResEntity>> call({
    required String number,
    required DocumentType type,
    required String sesionId,
  }) async {
    final validator = DocConfigFactory.getValidatorStrategy(type);
    if (!validator.validate(number)) {
      return Future.value(
        Left(ValidationException(validator.getErrorMessage())),
      );
    }
    if (sesionId.isEmpty) {
      return Future.value(
        Left(ValidationException('El ID de sesión no puede estar vacío')),
      );
    }
    final entity = DocumentRq(number: number, type: type, sesionId: sesionId);
    return await _repository.validateDocument(entity: entity);
  }
}
