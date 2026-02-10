import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/features/home/presentation/cubit/home_cubit.dart';
import 'package:partners/features/home/presentation/cubit/home_state.dart';
import 'package:partners/features/home/presentation/widgets/smart_card_widget.dart';
import 'package:partners/features/home/presentation/widgets/smart_tool_card_widget.dart';
import 'package:partners/features/home/presentation/widgets/transaction_item_widget.dart';
import 'package:partners/main.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;

    return BlocProvider(
      create: (context) {
        final cubit = getIt<HomeCubit>();
        cubit.loadHomeData();
        return cubit;
      },
      child: Scaffold(
        backgroundColor: surfaceColor, // Celeste from ThemeData
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (state.status == HomeStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Error loading data',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeCubit>().loadHomeData();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // Header + Tools Grid section with oval behind both
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 500, // Total height: header (~140) + grid (300)
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Oval with gradient - BEHIND title and grid using ClipPath
                        Positioned.fill(child: _ToolsOvalBackground()),
                        // Header with title - dark blue background
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                top: 60,
                                left: 20,
                                right: 20,
                                bottom: 20,
                              ),
                              child: const Text(
                                'Mis herramientas Smart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                            ),
                            // Smart Tools Grid - positioned below header
                            if (state.smartTools.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: SizedBox(
                                  height: 300, // Fixed height for grid
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          childAspectRatio: 0.85,
                                        ),
                                    itemCount: state.smartTools.length,
                                    itemBuilder: (context, index) {
                                      final tool = state.smartTools[index];
                                      return SmartToolCardWidget(tool: tool);
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (state.smartCard != null)
                          Positioned(
                            bottom: -50,
                            left: 20,
                            right: 20,
                            child: SmartCardWidget(card: state.smartCard!),
                          ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 64)),

                // Transactions Section
                SliverToBoxAdapter(
                  child: Container(
                    color: surfaceColor, // Use ThemeData surface (celeste)
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transacciones',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Figtree',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to full transactions
                          },
                          child: const Text(
                            'Ver completo',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Transactions List
                if (state.recentTransactions.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final transaction = state.recentTransactions[index];
                        return Container(
                          color:
                              surfaceColor, // Use ThemeData surface (celeste)
                          child: TransactionItemWidget(
                            transaction: transaction,
                          ),
                        );
                      }, childCount: state.recentTransactions.length),
                    ),
                  ),

                // Bottom spacing for navbar
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Widget for oval background behind tools section
class _ToolsOvalBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ToolsOvalClipper(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(
          0xFF0F2B69,
        ), // Solo color azul, sin gradiente ni shadow
      ),
    );
  }
}

// Custom clipper for oval shape behind tools
class _ToolsOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Parte superior completamente recta
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);

    // Crear un óvalo elíptico que se curve hacia ABAJO en la parte inferior
    // El óvalo debe cubrir todo el alto (título + grid) y la curva debe estar en la parte inferior
    // Usar curvas bezier cúbicas para crear la curva elíptica visible en la parte inferior
    // Los puntos de control deben estar más abajo para crear la curva elíptica pronunciada
    // Ajustar para que la curva sea visible en la parte inferior (cerca de size.height)
    final controlPoint1 = Offset(size.width * 3.0, size.height * 1.3);
    final controlPoint2 = Offset(-size.width * 2.0, size.height * 1.3);
    final endPoint = Offset(0, 0);

    // Crear la curva elíptica usando cubic bezier
    // Esto crea una curva suave que se curva hacia abajo en la parte inferior
    // Los puntos de control están más abajo y más alejados para crear la forma elíptica
    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // Cerrar el path - esto creará la línea izquierda recta hacia arriba
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
