import 'package:get_it/get_it.dart';
import 'package:partners/features/para_ti/data/datasource/para_ti_datasource.dart';
import 'package:partners/features/para_ti/data/datasource/provider_memory/mock_para_ti_datasource_impl.dart';
import 'package:partners/features/para_ti/data/repository/para_ti_repository_impl.dart';
import 'package:partners/features/para_ti/domain/repository/para_ti_repository.dart';
import 'package:partners/features/para_ti/domain/use_case/get_recomendaciones_usecase.dart';
import 'package:partners/features/para_ti/presentation/cubit/para_ti_cubit.dart';

class ParaTiInjection {
  final GetIt _getIt;

  ParaTiInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    // Datasource
    if (!_getIt.isRegistered<ParaTiDatasource>()) {
      _getIt.registerLazySingleton<ParaTiDatasource>(
        () => MockParaTiDatasourceImpl(),
      );
    }

    // Repository
    if (!_getIt.isRegistered<ParaTiRepository>()) {
      _getIt.registerLazySingleton<ParaTiRepository>(
        () => ParaTiRepositoryImpl(
          datasource: _getIt<ParaTiDatasource>(),
        ),
      );
    }

    if (!_getIt.isRegistered<GetRecomendacionesUsecase>()) {
      _getIt.registerLazySingleton<GetRecomendacionesUsecase>(
        () => GetRecomendacionesUsecase(
          repository: _getIt<ParaTiRepository>(),
        ),
      );
    }

    if (!_getIt.isRegistered<ParaTiCubit>()) {
      _getIt.registerFactory<ParaTiCubit>(
        () => ParaTiCubit(
          getRecomendacionesUsecase: _getIt<GetRecomendacionesUsecase>(),
        ),
      );
    }
  }
}
