import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/models/models.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/core/services/services.dart';
import 'package:partners/features/branches/domain/domain.dart';
import 'package:partners/features/branches/presentation/presentation.dart';
import 'package:partners/main.dart';

@RoutePage()
class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;

    // Load branches when screen is built
    return BlocProvider(
      create: (context) {
        final cubit = getIt<BranchesCubit>();
        cubit.loadBranches();
        return cubit;
      },
      child: Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F2B69)),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'Mis sucursales',
          style: TextStyle(
            color: Color(0xFF0F2B69),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == BranchesStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.errorMessage ?? "Error desconocido"}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
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
            return const Center(
              child: Text('No hay sucursales disponibles'),
            );
          }

          return ListView.builder(
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
          );
        },
      ),
        floatingActionButton: _buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildBranchCard(BuildContext context, BranchEntity branch) {
    final roleService = getIt<RoleService>();
    final canEdit = roleService.hasPermission(Permission.updateBranches);
    
    return Container(
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
                          const Icon(
                            Icons.edit,
                            color: Color(0xFF00114A),
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Editar',
                            style: TextStyle(
                              color: Color(0xFF00114A),
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
                      style: const TextStyle(
                        color: Colors.white,
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
                    style: const TextStyle(
                      color: Color(0xFF1C274C),
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Figtree',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 23,
                            color: Color(0xFF1C274C),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              branch.address,
                              style: const TextStyle(
                                color: Color(0xFF1C274C),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Phone
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 24,
                            color: Color(0xFF1C274C),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            branch.phone,
                            style: const TextStyle(
                              color: Color(0xFF1C274C),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Schedule
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 21,
                            color: Color(0xFF1C274C),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              branch.schedule,
                              style: const TextStyle(
                                color: Color(0xFF1C274C),
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
    
    // Verificar permisos antes de mostrar el botón
    if (!roleService.hasPermission(Permission.createBranches)) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 109,
      height: 109,
      decoration: BoxDecoration(
        color: const Color(0xFF0EA5E9),
        borderRadius: BorderRadius.circular(70.5),
        border: Border.all(color: const Color(0xFF0EA5E9), width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Verificar permisos nuevamente antes de navegar
            if (roleService.hasPermission(Permission.createBranches)) {
              context.router.push(const CreateBranchRoute());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No tiene permisos para crear sucursales'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(70.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 37,
                height: 37,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A2B7A),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 17),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nueva sucursal',
                style: TextStyle(
                  color: Colors.white,
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
    );
  }
}
