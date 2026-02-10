import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/para_ti/data/datasource/provider_memory/mock_para_ti_datasource_impl.dart';
import 'package:partners/features/para_ti/domain/entities/recomendacion_entity.dart';
import 'package:partners/features/para_ti/domain/repository/para_ti_repository.dart';

class ParaTiRepositoryImpl implements ParaTiRepository {
  final MockParaTiDatasourceImpl _datasource = MockParaTiDatasourceImpl();

  @override
  Future<Either<AppException, List<RecomendacionEntity>>> getRecomendaciones() async {
    return await _datasource.getRecomendaciones();
  }
}
