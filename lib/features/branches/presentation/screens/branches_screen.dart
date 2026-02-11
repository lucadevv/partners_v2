import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/models/models.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/core/services/services.dart';
import 'package:partners/features/branches/domain/domain.dart';
import 'package:partners/features/branches/presentation/presentation.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.appColor.primary),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'Mis sucursales',
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BranchesCubit, BranchesState>(
        builder: (context, state) {
          if (state.status == BranchesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == BranchesStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.errorMessage ?? "Error desconocido"}',
                    style: TextStyle(color: context.appColor.error),
                  ),
                  16.spaceh,
                  ElevatedButton(
                    onPressed: () {
                      context.read<BranchesCubit>().loadBranches();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state.branches.isEmpty) {
            return const Center(child: Text('No hay sucursales disponibles'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<BranchesCubit>().loadBranches(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: state.branches.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < state.branches.length - 1 ? 20 : 100,
                  ),
                  child: _buildBranchCard(context, state.branches[index]),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBranchCard(BuildContext context, BranchEntity branch) {
    final roleService = getIt<RoleService>();
    final canEdit = roleService.hasPermission(Permission.updateBranches);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              Container(
                height: 141,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: branch.imageUrl == null
                    ? const Center(
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Color(0xFF9CA3AF),
                        ),
                      )
                    : Image.network(branch.imageUrl!, fit: BoxFit.cover),
              ),
              // Edit button - solo si tiene permisos
              if (canEdit)
                Positioned(
                  left: 18,
                  bottom: 76,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Navegar a pantalla de edición
                      // context.router.push(EditBranchRoute(branchId: branch.id));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit,
                            color: context.appColor.primary,
                            size: 24,
                          ),
                          10.spacew,
                          Text(
                            'Editar',
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
              // Workers count
              Positioned(
                right: 18,
                top: 95,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 19,
                      height: 19,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 12,
                        color: Color(0xFF00114A),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${branch.workers}',
                      style: TextStyle(
                        color: context.appColor.onPrimary,
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Content section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    branch.name,
                    style: TextStyle(
                      color: context.appColor.onSurface,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Figtree',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                20.spacew,
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 23,
                            color: context.appColor.onSurface,
                          ),
                          7.spacew,
                          Expanded(
                            child: Text(
                              branch.address,
                              style: TextStyle(
                                color: context.appColor.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ),
                        ],
                      ),
                      12.spaceh,
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 24,
                            color: context.appColor.onSurface,
                          ),
                          7.spacew,
                          Text(
                            branch.phone,
                            style: TextStyle(
                              color: context.appColor.onSurface,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                      12.spaceh,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 21,
                            color: context.appColor.onSurface,
                          ),
                          7.spacew,
                          Expanded(
                            child: Text(
                              branch.schedule,
                              style: TextStyle(
                                color: context.appColor.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final roleService = getIt<RoleService>();
    // Superadmin tiene acceso total; además se verifica el permiso explícito
    final canCreate =
        roleService.hasRole(UserRole.superadmin) ||
        roleService.hasPermission(Permission.createBranches);
    if (!canCreate) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 109,
      height: 109,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70.5),
          border: Border.all(color: context.appColor.secondary, width: 2),
          color: context.appColor.secondary,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.router.push(const CreateBranchRoute()),
            borderRadius: BorderRadius.circular(70.5),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.appColor.primary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SizedBox(
                      width: 37,
                      height: 37,
                      child: Icon(
                        Icons.add,
                        color: context.appColor.onPrimary,
                        size: 17,
                      ),
                    ),
                  ),
                ),
                10.spaceh,
                Text(
                  'Nueva sucursal',
                  style: TextStyle(
                    color: context.appColor.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
