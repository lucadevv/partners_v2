import 'package:get_it/get_it.dart';
import 'package:partners/features/pagar/data/datasource/pagar_datasource.dart';
import 'package:partners/features/pagar/data/datasource/provider_memory/mock_pagar_datasource_impl.dart';
import 'package:partners/features/pagar/data/repository/pagar_repository_impl.dart';
import 'package:partners/features/pagar/domain/repository/pagar_repository.dart';
import 'package:partners/features/pagar/domain/use_case/get_historial_pagos_usecase.dart';
import 'package:partners/features/pagar/domain/use_case/procesar_pago_usecase.dart';
import 'package:partners/features/pagar/presentation/cubit/pagar_cubit.dart';

class PagarInjection {
  final GetIt _getIt;

  PagarInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    if (!_getIt.isRegistered<PagarDatasource>()) {
      _getIt.registerLazySingleton<PagarDatasource>(
        () => MockPagarDatasourceImpl(),
      );
    }

    if (!_getIt.isRegistered<PagarRepository>()) {
      _getIt.registerLazySingleton<PagarRepository>(
        () => PagarRepositoryImpl(datasource: _getIt<PagarDatasource>()),
      );
    }

    if (!_getIt.isRegistered<GetHistorialPagosUsecase>()) {
      _getIt.registerLazySingleton<GetHistorialPagosUsecase>(
        () => GetHistorialPagosUsecase(repository: _getIt<PagarRepository>()),
      );
    }

    if (!_getIt.isRegistered<ProcesarPagoUsecase>()) {
      _getIt.registerLazySingleton<ProcesarPagoUsecase>(
        () => ProcesarPagoUsecase(repository: _getIt<PagarRepository>()),
      );
    }

    if (!_getIt.isRegistered<PagarCubit>()) {
      _getIt.registerFactory<PagarCubit>(
        () => PagarCubit(
          getHistorialPagosUsecase: _getIt<GetHistorialPagosUsecase>(),
          procesarPagoUsecase: _getIt<ProcesarPagoUsecase>(),
        ),
      );
    }
  }
}
