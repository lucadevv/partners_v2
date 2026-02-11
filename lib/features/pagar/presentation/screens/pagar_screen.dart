import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/pagar/domain/domain.dart';
import 'package:partners/features/pagar/presentation/presentation.dart';
import 'package:partners/main.dart';

@RoutePage()
class PagarScreen extends StatefulWidget implements AutoRouteWrapper {
  const PagarScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    final cubit = getIt<PagarCubit>();
    cubit.loadHistorialPagos();
    return BlocProvider(
      create: (_) => cubit,
      child: this,
    );
  }

  @override
  State<PagarScreen> createState() => _PagarScreenState();
}

class _PagarScreenState extends State<PagarScreen> {
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  MetodoPago _metodoSeleccionado = MetodoPago.efectivo;

  @override
  void dispose() {
    _montoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
      ),
      body: BlocBuilder<PagarCubit, PagarState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<PagarCubit>().loadHistorialPagos(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Formulario de pago
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Nuevo Pago',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _montoController,
                            decoration: const InputDecoration(
                              labelText: 'Monto',
                              prefixText: 'S/ ',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _descripcionController,
                            decoration: const InputDecoration(
                              labelText: 'Descripción',
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Método de Pago'),
                          Wrap(
                            spacing: 8,
                            children: MetodoPago.values.map((metodo) {
                              return ChoiceChip(
                                label: Text(_getMetodoPagoNombre(metodo)),
                                selected: _metodoSeleccionado == metodo,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _metodoSeleccionado = metodo;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: state.status == PagarStatus.loading
                                ? null
                                : _procesarPago,
                            child: state.status == PagarStatus.loading
                                ? const CircularProgressIndicator()
                                : const Text('Procesar Pago'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Historial
                  const Text(
                    'Historial de Pagos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.status == PagarStatus.loading &&
                      state.historialPagos.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else if (state.historialPagos.isEmpty)
                    const Center(
                      child: Text('No hay pagos registrados'),
                    )
                  else
                    ...state.historialPagos.map((pago) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(_getMetodoPagoIcono(pago.metodoPago)),
                            title: Text(pago.descripcion),
                            subtitle: Text(
                              '${pago.fecha.day}/${pago.fecha.month}/${pago.fecha.year}',
                            ),
                            trailing: Text(
                              'S/ ${pago.monto.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: context.appColor.primary,
                              ),
                            ),
                          ),
                        )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _procesarPago() {
    final monto = double.tryParse(_montoController.text);
    if (monto == null || monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un monto válido')),
      );
      return;
    }

    final pago = PagoEntity(
      id: '',
      monto: monto,
      metodoPago: _metodoSeleccionado,
      fecha: DateTime.now(),
      descripcion: _descripcionController.text.isEmpty
          ? 'Pago sin descripción'
          : _descripcionController.text,
      completado: false,
    );

    context.read<PagarCubit>().procesarPago(pago).then((_) {
      if (!mounted) return;
      _montoController.clear();
      _descripcionController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pago procesado exitosamente')),
      );
    });
  }

  String _getMetodoPagoNombre(MetodoPago metodo) {
    switch (metodo) {
      case MetodoPago.efectivo:
        return 'Efectivo';
      case MetodoPago.tarjeta:
        return 'Tarjeta';
      case MetodoPago.transferencia:
        return 'Transferencia';
      case MetodoPago.yape:
        return 'Yape';
      case MetodoPago.plin:
        return 'Plin';
    }
  }

  IconData _getMetodoPagoIcono(MetodoPago metodo) {
    switch (metodo) {
      case MetodoPago.efectivo:
        return Icons.money;
      case MetodoPago.tarjeta:
        return Icons.credit_card;
      case MetodoPago.transferencia:
        return Icons.account_balance;
      case MetodoPago.yape:
        return Icons.phone_android;
      case MetodoPago.plin:
        return Icons.phone_android;
    }
  }
}
