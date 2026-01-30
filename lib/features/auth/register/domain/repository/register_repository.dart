import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/domain/entities/rep_legal_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/request/document_rq.dart';
import 'package:partners/features/auth/register/domain/entities/request/entity_rq.dart';
import 'package:partners/features/auth/register/domain/entities/request/start_register_req.dart';
import 'package:partners/features/auth/register/domain/entities/response/start_resgister_res_entity.dart';

abstract class RegisterRepository {
  Future<Either<AppException, RegisterResponseEntity>> validateComerce({
    required EntityRq entity,
  });

  Future<Either<AppException, RepLegalResEntity>> validateDocument({
    required DocumentRq entity,
  });

  Future<Either<AppException, StartRegisterResEntity>> startRegister({
    required StartRegisterReq entity,
  });
}
