import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/productos/domain/use_case/buscar_productos_usecase.dart';
import 'package:partners/features/productos/domain/use_case/get_categorias_usecase.dart';
import 'package:partners/features/productos/domain/use_case/get_productos_destacados_usecase.dart';
import 'package:partners/features/productos/domain/use_case/get_productos_usecase.dart';
import 'package:partners/features/productos/presentation/cubit/productos_state.dart';

/// Cubit para gestionar el estado de productos
/// Sigue el principio de Single Responsibility (SRP)
class ProductosCubit extends Cubit<ProductosState> with BaseCubitMixin {
  final GetProductosUsecase _getProductosUsecase;
  final GetCategoriasUsecase _getCategoriasUsecase;
  final BuscarProductosUsecase _buscarProductosUsecase;
  final GetProductosDestacadosUsecase _getProductosDestacadosUsecase;

  ProductosCubit({
    required GetProductosUsecase getProductosUsecase,
    required GetCategoriasUsecase getCategoriasUsecase,
    required BuscarProductosUsecase buscarProductosUsecase,
    required GetProductosDestacadosUsecase getProductosDestacadosUsecase,
  })  : _getProductosUsecase = getProductosUsecase,
        _getCategoriasUsecase = getCategoriasUsecase,
        _buscarProductosUsecase = buscarProductosUsecase,
        _getProductosDestacadosUsecase = getProductosDestacadosUsecase,
        super(const ProductosState());

  /// Carga inicial de productos y categorías
  Future<void> loadProductos() async {
    emit(state.copyWith(status: ProductosStatus.loading));
    
    final productosResult = await _getProductosUsecase();
    final categoriasResult = await _getCategoriasUsecase();
    final destacadosResult = await _getProductosDestacadosUsecase();

    productosResult.fold(
      (failure) {
        emit(state.copyWith(
          status: ProductosStatus.failure,
          errorMessage: getErrorMessage(failure),
        ));
      },
      (productos) {
        categoriasResult.fold(
          (failure) {
            emit(state.copyWith(
              status: ProductosStatus.failure,
              errorMessage: getErrorMessage(failure),
            ));
          },
          (categorias) {
            destacadosResult.fold(
              (failure) {
                emit(state.copyWith(
                  status: ProductosStatus.failure,
                  errorMessage: getErrorMessage(failure),
                ));
              },
              (destacados) {
                emit(state.copyWith(
                  status: ProductosStatus.success,
                  productos: productos,
                  categorias: categorias,
                  productosDestacados: destacados,
                ));
              },
            );
          },
        );
      },
    );
  }

  /// Busca productos por query
  Future<void> buscarProductos(String query) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(
        queryBusqueda: '',
        categoriaSeleccionada: null,
      ));
      return;
    }

    emit(state.copyWith(
      status: ProductosStatus.loading,
      queryBusqueda: query,
      categoriaSeleccionada: null,
    ));

    final result = await _buscarProductosUsecase(query);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProductosStatus.failure,
          errorMessage: getErrorMessage(failure),
        ));
      },
      (productos) {
        emit(state.copyWith(
          status: ProductosStatus.success,
          productos: productos,
        ));
      },
    );
  }

  /// Filtra productos por categoría
  void filtrarPorCategoria(String? categoriaId) {
    emit(state.copyWith(
      categoriaSeleccionada: categoriaId,
      queryBusqueda: '',
    ));
  }

  /// Limpia los filtros
  void limpiarFiltros() {
    emit(state.copyWith(
      categoriaSeleccionada: null,
      queryBusqueda: '',
    ));
    loadProductos();
  }
}
