import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/features/branches/presentation/cubit/branches_cubit.dart';
import 'package:partners/features/branches/presentation/cubit/branches_state.dart';
import 'package:partners/features/branches/presentation/widgets/branch_card_widget.dart';
import 'package:partners/features/branches/presentation/widgets/branches_empty_body.dart';
import 'package:partners/features/branches/presentation/widgets/branches_error_body.dart';
import 'package:partners/features/branches/presentation/widgets/branches_fab.dart';
import 'package:partners/features/branches/presentation/widgets/branches_screen_app_bar.dart';
import 'package:partners/main.dart';

@RoutePage()
class BranchesScreen extends StatelessWidget implements AutoRouteWrapper {
  const BranchesScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final cubit = getIt<BranchesCubit>();
    cubit.loadBranches();
    return BlocProvider(create: (_) => cubit, child: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const BranchesScreenAppBar(),
      body: Stack(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
                colors: [context.appColor.secondary, Colors.transparent],
              ),
            ),
            child: SizedBox.expand(),
          ),
          BlocBuilder<BranchesCubit, BranchesState>(
            builder: (context, state) {
              if (state.status == BranchesStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == BranchesStatus.failure) {
                return BranchesErrorBody(
                  errorMessage: state.errorMessage,
                  onRetry: () => context.read<BranchesCubit>().loadBranches(),
                );
              }
              if (state.branches.isEmpty) {
                return const BranchesEmptyBody();
              }
              return RefreshIndicator(
                onRefresh: () => context.read<BranchesCubit>().loadBranches(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  itemCount: state.branches.length,
                  itemBuilder: (context, index) {
                    final branch = state.branches[index];
                    final bottom = index < state.branches.length - 1
                        ? 20.0
                        : 100.0;
                    return Padding(
                      padding: EdgeInsets.only(bottom: bottom),
                      child: BranchCardWidget(branch: branch),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: const BranchesFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
