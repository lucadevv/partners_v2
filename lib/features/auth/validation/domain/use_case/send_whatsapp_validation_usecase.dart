import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/validation/domain/entities/whatsapp_validation_req.dart';
import 'package:partners/features/auth/validation/domain/entities/whatsapp_validation_res.dart';
import 'package:partners/features/auth/validation/domain/repository/validation_repository.dart';

class SendWhatsappValidationUsecase {
  final ValidationRepository _repository;

  SendWhatsappValidationUsecase({required ValidationRepository repository})
      : _repository = repository;

  Future<Either<AppException, WhatsappValidationRes>> call({
    required String sessionId,
    required String phone,
  }) async {
    if (sessionId.isEmpty) {
      return Left(ValidationException("Session ID cannot be empty"));
    }
    if (phone.isEmpty) {
      return Left(ValidationException("Phone number cannot be empty"));
    }
    final entity = WhatsappValidationReq(sessionId: sessionId, phone: phone);
    return await _repository.sendWhatsappValidation(entity);
  }
}
