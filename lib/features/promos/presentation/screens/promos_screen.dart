import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/features/promos/presentation/presentation.dart';
import 'package:partners/main.dart';

@RoutePage()
class PromosScreen extends StatelessWidget implements AutoRouteWrapper {
  const PromosScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final cubit = getIt<PromosCubit>();
    cubit.loadPromos();
    return BlocProvider<PromosCubit>(create: (_) => cubit, child: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: Stack(
          alignment: Alignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.appColor.secondary,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: context.appColor.primary.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const SizedBox(width: 220, height: 56),
            ),
            Text(
              'Mis promos Smart',
              style: TextStyle(
                color: context.appColor.primary,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                fontFamily: 'Figtree',
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<PromosCubit, PromosState>(
        builder: (context, state) {
          if (state.status == PromosStatus.loading && state.promos.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: context.appColor.primary),
            );
          }
          if (state.status == PromosStatus.failure && state.promos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'Error al cargar las promos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.appColor.error,
                      fontSize: 16,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  16.spaceh,
                  TextButton.icon(
                    onPressed: () => context.read<PromosCubit>().loadPromos(),
                    icon: Icon(Icons.refresh, color: context.appColor.primary),
                    label: Text(
                      'Reintentar',
                      style: TextStyle(
                        color: context.appColor.primary,
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state.promos.isEmpty) {
            return Center(
              child: Text(
                'No tienes promociones aún',
                style: TextStyle(
                  color: context.appColor.onSurfaceVariant,
                  fontSize: 18,
                  fontFamily: 'Figtree',
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<PromosCubit>().loadPromos(),
            color: context.appColor.primary,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              itemCount: state.promos.length,
              itemBuilder: (context, index) {
                final promo = state.promos[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < state.promos.length - 1 ? 20 : 0,
                  ),
                  child: _PromoCard(
                    title: promo.title,
                    imageUrl: promo.imageUrl,
                    onTap: () => context.router.push(
                      PromoDetailRoute(promoId: promo.id),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: _CrearPromoButton(
        onPressed: () => _showPromoTypeBottomSheet(context),
      ),
    );
  }

  void _showPromoTypeBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const PromoTypeBottomSheet(),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback onTap;

  const _PromoCard({required this.title, this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColor.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 113,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.appColor.surfaceContainerHighest,
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: context.appColor.onSurfaceVariant,
                    ),
                  ),
                ),
                16.spacew,
                Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: context.appColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Figtree',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                16.spacew,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CrearPromoButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CrearPromoButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColor.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: context.appColor.primary, size: 22),
                    10.spacew,
                    Text(
                      'Crear promo',
                      style: TextStyle(
                        color: context.appColor.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
