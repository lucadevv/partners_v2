import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/data/models/document_res_model.dart';
import 'package:partners/features/auth/register/data/models/register_ruc_res_model.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';
import 'package:partners/features/auth/register/domain/entities/validate_ruc_entity.dart';

abstract class RegisterDatasource {
  Future<Either<AppException, RegisterRucResModel>> validateComerce(
    ValidateRucEntity request,
  );

  Future<Either<AppException, DocumentResModel>> validateDocument({
    required TipoDocumento type,
    required String number,
  });
}
