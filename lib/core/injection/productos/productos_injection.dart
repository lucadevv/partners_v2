import 'package:get_it/get_it.dart';
import 'package:partners/features/productos/data/datasource/productos_datasource.dart';
import 'package:partners/features/productos/data/datasource/provider_memory/mock_productos_datasource_impl.dart';
import 'package:partners/features/productos/data/repository/productos_repository_impl.dart';
import 'package:partners/features/productos/domain/repository/productos_repository.dart';
import 'package:partners/features/productos/domain/use_case/buscar_productos_usecase.dart';
import 'package:partners/features/productos/domain/use_case/get_categorias_usecase.dart';
import 'package:partners/features/productos/domain/use_case/get_productos_destacados_usecase.dart';
import 'package:partners/features/productos/domain/use_case/get_productos_usecase.dart';
import 'package:partners/features/productos/presentation/cubit/productos_cubit.dart';

class ProductosInjection {
  final GetIt _getIt;

  ProductosInjection({required GetIt getIt}) : _getIt = getIt {
    _init();
  }

  void _init() {
    // Datasource
    if (!_getIt.isRegistered<ProductosDatasource>()) {
      _getIt.registerLazySingleton<ProductosDatasource>(
        () => MockProductosDatasourceImpl(),
      );
    }

    // Repository
    if (!_getIt.isRegistered<ProductosRepository>()) {
      _getIt.registerLazySingleton<ProductosRepository>(
        () => ProductosRepositoryImpl(
          datasource: _getIt<ProductosDatasource>(),
        ),
      );
    }

    // Use Cases
    if (!_getIt.isRegistered<GetProductosUsecase>()) {
      _getIt.registerLazySingleton<GetProductosUsecase>(
        () => GetProductosUsecase(
          repository: _getIt<ProductosRepository>(),
        ),
      );
    }

    if (!_getIt.isRegistered<GetCategoriasUsecase>()) {
      _getIt.registerLazySingleton<GetCategoriasUsecase>(
        () => GetCategoriasUsecase(
          repository: _getIt<ProductosRepository>(),
        ),
      );
    }

    if (!_getIt.isRegistered<BuscarProductosUsecase>()) {
      _getIt.registerLazySingleton<BuscarProductosUsecase>(
        () => BuscarProductosUsecase(
          repository: _getIt<ProductosRepository>(),
        ),
      );
    }

    if (!_getIt.isRegistered<GetProductosDestacadosUsecase>()) {
      _getIt.registerLazySingleton<GetProductosDestacadosUsecase>(
        () => GetProductosDestacadosUsecase(
          repository: _getIt<ProductosRepository>(),
        ),
      );
    }

    // Cubit
    if (!_getIt.isRegistered<ProductosCubit>()) {
      _getIt.registerFactory<ProductosCubit>(
        () => ProductosCubit(
          getProductosUsecase: _getIt<GetProductosUsecase>(),
          getCategoriasUsecase: _getIt<GetCategoriasUsecase>(),
          buscarProductosUsecase: _getIt<BuscarProductosUsecase>(),
          getProductosDestacadosUsecase: _getIt<GetProductosDestacadosUsecase>(),
        ),
      );
    }
  }
}
