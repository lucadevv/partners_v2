import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/core/utils/widgets/custom_text_field_widget.dart';
import 'package:partners/features/productos/presentation/cubit/productos_cubit.dart';
import 'package:partners/features/productos/presentation/cubit/productos_state.dart';
import 'package:partners/features/productos/presentation/widgets/categoria_chip_widget.dart';
import 'package:partners/features/productos/presentation/widgets/producto_card_widget.dart';
import 'package:partners/features/productos/presentation/widgets/productos_destacados_widget.dart';
import 'package:partners/main.dart';

@RoutePage()
class ProductosScreen extends StatefulWidget implements AutoRouteWrapper {
  const ProductosScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final cubit = getIt<ProductosCubit>();
    cubit.loadProductos();
    return BlocProvider(
      create: (_) => cubit,
      child: this,
    );
  }

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Productos'),
        ),
        body: BlocBuilder<ProductosCubit, ProductosState>(
          builder: (context, state) {
            if (state.status == ProductosStatus.loading &&
                state.productos.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == ProductosStatus.failure &&
                state.productos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: context.appColor.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Error al cargar productos',
                      style: TextStyle(color: context.appColor.error),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductosCubit>().loadProductos();
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<ProductosCubit>().loadProductos(),
              child: CustomScrollView(
                slivers: [
                // Barra de búsqueda
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomTextFieldWidget(
                      label: 'Buscar productos',
                      hintText: 'Buscar por nombre...',
                      controller: _searchController,
                      prefixIcon: const Icon(Icons.search),
                      onChanged: (value) {
                        context.read<ProductosCubit>().buscarProductos(value);
                      },
                    ),
                  ),
                ),

                // Categorías
                if (state.categorias.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.categorias.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return CategoriaChipWidget(
                              nombre: 'Todos',
                              icono: Icons.all_inclusive,
                              isSelected: state.categoriaSeleccionada == null,
                              onTap: () {
                                context.read<ProductosCubit>().limpiarFiltros();
                              },
                            );
                          }
                          final categoria = state.categorias[index - 1];
                          return CategoriaChipWidget(
                            nombre: categoria.nombre,
                            icono: _getIconForCategory(categoria.icono),
                            isSelected:
                                state.categoriaSeleccionada == categoria.id,
                            onTap: () {
                              context
                                  .read<ProductosCubit>()
                                  .filtrarPorCategoria(categoria.id);
                            },
                          );
                        },
                      ),
                    ),
                  ),

                // Productos destacados
                if (state.productosDestacados.isNotEmpty &&
                    state.categoriaSeleccionada == null &&
                    state.queryBusqueda.isEmpty)
                  SliverToBoxAdapter(
                    child: ProductosDestacadosWidget(
                      productos: state.productosDestacados,
                    ),
                  ),

                // Lista de productos
                if (state.productosFiltrados.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final producto = state.productosFiltrados[index];
                          return ProductoCardWidget(producto: producto);
                        },
                        childCount: state.productosFiltrados.length,
                      ),
                    ),
                  )
                else if (state.queryBusqueda.isNotEmpty ||
                    state.categoriaSeleccionada != null)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: context.appColor.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No se encontraron productos',
                            style: TextStyle(
                              color: context.appColor.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
  }

  IconData _getIconForCategory(String icono) {
    switch (icono) {
      case 'local_drink':
        return Icons.local_drink;
      case 'restaurant':
        return Icons.restaurant;
      case 'bakery_dining':
        return Icons.bakery_dining;
      case 'cake':
        return Icons.cake;
      default:
        return Icons.category;
    }
  }
}
