import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/data/models/document_res_model.dart';
import 'package:partners/features/auth/register/data/models/register_ruc_res_model.dart';
import 'package:partners/features/auth/register/data/models/start_register_res_model.dart';
import 'package:partners/features/auth/register/domain/entities/request/document_rq.dart';
import 'package:partners/features/auth/register/domain/entities/request/entity_rq.dart';
import 'package:partners/features/auth/register/domain/entities/request/start_register_req.dart';

abstract class RegisterDatasource {
  Future<Either<AppException, RegisterRucResModel>> validateComerce(
    EntityRq entity,
  );

  Future<Either<AppException, DocumentResModel>> validateDocument({
    required DocumentRq entity,
  });

  Future<Either<AppException, StartRegisterResModel>> startRegister({
    required StartRegisterReq entity,
  });
}
