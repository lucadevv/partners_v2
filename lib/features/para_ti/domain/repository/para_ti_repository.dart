import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/para_ti/domain/entities/recomendacion_entity.dart';

abstract class ParaTiRepository {
  Future<Either<AppException, List<RecomendacionEntity>>> getRecomendaciones();
}
