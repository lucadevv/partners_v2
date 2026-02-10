import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/para_ti/domain/entities/recomendacion_entity.dart';
import 'package:partners/features/para_ti/domain/repository/para_ti_repository.dart';

class GetRecomendacionesUsecase {
  final ParaTiRepository _repository;

  GetRecomendacionesUsecase({required ParaTiRepository repository})
      : _repository = repository;

  Future<Either<AppException, List<RecomendacionEntity>>> call() async {
    return await _repository.getRecomendaciones();
  }
}
