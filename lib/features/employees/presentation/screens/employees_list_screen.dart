import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/employees/presentation/cubit/employees_list_cubit.dart';
import 'package:partners/features/employees/presentation/cubit/employees_list_state.dart';
import 'package:partners/features/employees/presentation/screens/employees_screen_strings.dart';
import 'package:partners/features/employees/presentation/widgets/employee_card_widget.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/features/employees/presentation/widgets/employees_branch_selector.dart';
import 'package:partners/main.dart';

@RoutePage()
class EmployeesListScreen extends StatefulWidget implements AutoRouteWrapper {
  const EmployeesListScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<EmployeesListCubit>(
      create: (_) => getIt<EmployeesListCubit>()..loadInitial(),
      child: this,
    );
  }

  @override
  State<EmployeesListScreen> createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<EmployeesListCubit>();
    if (!cubit.state.hasNextPage) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.appColor.primary),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          EmployeesScreenStrings.appBarTitle,
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<EmployeesListCubit, EmployeesListState>(
        builder: (context, state) {
          if (state.status == EmployeesListStatus.loading &&
              state.employees.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == EmployeesListStatus.failure &&
              state.employees.isEmpty) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<EmployeesListCubit>().loadInitial(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${EmployeesScreenStrings.errorPrefix}${state.errorMessage ?? EmployeesScreenStrings.unknownError}',
                            style: TextStyle(color: context.appColor.error),
                            textAlign: TextAlign.center,
                          ),
                          16.spaceh,
                          ElevatedButton(
                            onPressed: () => context
                                .read<EmployeesListCubit>()
                                .loadInitial(),
                            child: const Text(
                                EmployeesScreenStrings.retryButton),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          if (state.employees.isEmpty) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<EmployeesListCubit>().loadInitial(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: const Center(
                    child: Text(EmployeesScreenStrings.emptyMessage),
                  ),
                ),
              ),
            );
          }
          final filtered = state.selectedBranchId == null
              ? state.employees
              : state.employees
                  .where((e) => e.branchId == state.selectedBranchId)
                  .toList();
          return RefreshIndicator(
            onRefresh: () =>
                context.read<EmployeesListCubit>().loadInitial(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: filtered.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: EmployeesBranchSelector(
                      branchOptions: state.branchOptions,
                      selectedBranchId: state.selectedBranchId,
                      onChanged: (id) =>
                          context.read<EmployeesListCubit>().selectBranch(id),
                    ),
                  );
                }
                if (index == filtered.length + 1) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: state.status == EmployeesListStatus.loadingMore
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox.shrink(),
                  );
                }
                final employee = filtered[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: EmployeeCardWidget(
                    employee: employee,
                    onTap: () async {
                      await context.router.push(
                        EmployeeDetailRoute(employeeId: employee.id),
                      );
                      if (context.mounted) {
                        context.read<EmployeesListCubit>().loadInitial();
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: ElevatedButton(
            onPressed: () async {
              await context.router.push(const CreateEmployeeRoute());
              if (context.mounted) {
                context.read<EmployeesListCubit>().loadInitial();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(EmployeesScreenStrings.createEmployeeFab),
          ),
        ),
      ),
    );
  }
}
