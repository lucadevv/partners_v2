import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/para_ti/data/models/recomendacion_model.dart';

/// Datasource interface for Para Ti (Data Layer)
abstract class ParaTiDatasource {
  Future<Either<AppException, List<RecomendacionModel>>> getRecomendaciones();
}
