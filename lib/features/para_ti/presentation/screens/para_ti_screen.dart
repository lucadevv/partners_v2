import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/features/para_ti/presentation/cubit/para_ti_cubit.dart';
import 'package:partners/features/para_ti/presentation/cubit/para_ti_state.dart';
import 'package:partners/main.dart';

@RoutePage()
class ParaTiScreen extends StatelessWidget {
  const ParaTiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<ParaTiCubit>();
        cubit.loadRecomendaciones();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Para Ti'),
        ),
        body: BlocBuilder<ParaTiCubit, ParaTiState>(
          builder: (context, state) {
            if (state.status == ParaTiStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ParaTiStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: context.appColor.error),
                    const SizedBox(height: 16),
                    Text(state.errorMessage ?? 'Error al cargar'),
                  ],
                ),
              );
            }

            if (state.recomendaciones.isEmpty) {
              return const Center(child: Text('No hay recomendaciones'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.recomendaciones.length,
              itemBuilder: (context, index) {
                final rec = state.recomendaciones[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.appColor.primaryContainer,
                      child: Icon(_getIconForType(rec.tipo)),
                    ),
                    title: Text(rec.titulo),
                    subtitle: Text(rec.descripcion),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  IconData _getIconForType(String tipo) {
    switch (tipo) {
      case 'oferta':
        return Icons.local_offer;
      case 'producto':
        return Icons.shopping_bag;
      case 'noticia':
        return Icons.newspaper;
      default:
        return Icons.info;
    }
  }
}
