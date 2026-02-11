import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/features/home/presentation/cubit/home_cubit.dart';
import 'package:partners/features/home/presentation/cubit/home_state.dart';
import 'package:partners/features/home/presentation/widgets/home_header_section.dart';
import 'package:partners/features/home/presentation/widgets/home_tools_grid_section.dart';
import 'package:partners/features/home/presentation/widgets/home_tools_oval_background.dart';
import 'package:partners/features/home/presentation/widgets/home_transactions_section.dart';
import 'package:partners/features/home/presentation/widgets/smart_card_widget.dart';
import 'package:partners/main.dart';

@RoutePage()
class HomeScreen extends StatelessWidget implements AutoRouteWrapper {
  const HomeScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final cubit = getIt<HomeCubit>();
    cubit.loadHomeData();
    return BlocProvider(
      create: (_) => cubit,
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;

    return Scaffold(
      backgroundColor: surfaceColor,
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

          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadHomeData(),
            child: CustomScrollView(
              slivers: [
                // Header + Tools Grid section with oval behind both
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 500, // Total height: header (~140) + grid (300)
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Oval background - BEHIND title and grid
                        const Positioned.fill(child: HomeToolsOvalBackground()),
                        // Header and Tools Grid
                        Column(
                          children: [
                            const HomeHeaderSection(),
                            HomeToolsGridSection(tools: state.smartTools),
                          ],
                        ),
                        // Smart Card positioned below
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
                  child: HomeTransactionsSection(
                    transactions: state.recentTransactions,
                    backgroundColor: surfaceColor,
                    // onViewAll is null, so it will use the default navigation
                  ),
                ),

                // Bottom spacing for navbar
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          );
        },
      ),
    );
  }
}
