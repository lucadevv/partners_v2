import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/features/transactions/domain/domain.dart';
import 'package:partners/features/transactions/presentation/presentation.dart';
import 'package:partners/main.dart';

@RoutePage()
class TransactionsScreen extends StatelessWidget implements AutoRouteWrapper {
  const TransactionsScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final cubit = getIt<TransactionsCubit>();
    cubit.loadTransactions();
    return BlocProvider(create: (_) => cubit, child: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.appColor.primary),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'Transacciones',
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: context.appColor.primary),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          if (state.status == TransactionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TransactionsStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.errorMessage ?? "Error desconocido"}',
                    style: TextStyle(color: context.appColor.error),
                    textAlign: TextAlign.center,
                  ),
                  16.spaceh,
                  ElevatedButton(
                    onPressed: () {
                      context.read<TransactionsCubit>().loadTransactions();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          if (state.transactions.isEmpty) {
            return Center(
              child: Text(
                'No hay transacciones',
                style: TextStyle(
                  color: context.appColor.onSurface,
                  fontSize: 18,
                  fontFamily: 'Figtree',
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                context.read<TransactionsCubit>().loadTransactions(),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < state.transactions.length - 1 ? 10 : 0,
                  ),
                  child: _buildTransactionItem(
                    context,
                    state.transactions[index],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    TransactionEntity transaction,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 80,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.router.push(
                TransactionDetailRoute(
                  transactionName: transaction.name,
                  transactionDate: transaction.date,
                  transactionPoints: transaction.pointsLabel,
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 30,
                    color: context.appColor.primary,
                  ),
                  10.spacew,
                  Text(
                    transaction.pointsLabel,
                    style: TextStyle(
                      color: context.appColor.primary,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  20.spacew,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          transaction.name,
                          style: TextStyle(
                            color: context.appColor.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Figtree',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        8.spaceh,
                        Text(
                          transaction.date,
                          style: TextStyle(
                            color: context.appColor.onSurfaceVariant,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Figtree',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: ctx.appColor.surface,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: Icon(
                        Icons.arrow_back,
                        color: ctx.appColor.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Filtrar por',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ctx.appColor.onSurface,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ),
                  35.spacew,
                ],
              ),
              30.spaceh,
              _buildFilterOption(ctx, 'Solo hoy', true),
              20.spaceh,
              _buildFilterOption(ctx, 'Últimos 07 días', false),
              20.spaceh,
              _buildFilterOption(ctx, 'Últimos 15 días', false),
              20.spaceh,
              _buildFilterOption(ctx, 'Últimos 30 días', false),
              20.spaceh,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    String title,
    bool isSelected,
  ) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? context.appColor.primary : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? context.appColor.primary
                  : context.appColor.onSurface,
              width: 1,
            ),
          ),
          child: const SizedBox(width: 24, height: 24),
        ),
        20.spacew,
        Text(
          title,
          style: TextStyle(
            color: context.appColor.onSurface,
            fontSize: 23,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontFamily: 'Figtree',
          ),
        ),
      ],
    );
  }
}
