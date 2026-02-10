import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/pagar/data/datasource/pagar_datasource.dart';
import 'package:partners/features/pagar/data/models/pago_model.dart';
import 'package:partners/features/pagar/domain/entities/pago_entity.dart';

class MockPagarDatasourceImpl implements PagarDatasource {
  final List<PagoModel> _historialPagos = [
    PagoModel(
      id: '1',
      monto: 150.00,
      metodoPago: MetodoPago.tarjeta,
      fecha: DateTime.now().subtract(const Duration(days: 1)),
      descripcion: 'Pago de productos',
      completado: true,
    ),
    PagoModel(
      id: '2',
      monto: 75.50,
      metodoPago: MetodoPago.yape,
      fecha: DateTime.now().subtract(const Duration(days: 3)),
      descripcion: 'Pago de servicios',
      completado: true,
    ),
    PagoModel(
      id: '3',
      monto: 200.00,
      metodoPago: MetodoPago.efectivo,
      fecha: DateTime.now().subtract(const Duration(days: 5)),
      descripcion: 'Pago de factura',
      completado: true,
    ),
  ];

  @override
  Future<Either<AppException, List<PagoModel>>> getHistorialPagos() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(_historialPagos);
  }

  @override
  Future<Either<AppException, PagoModel>> procesarPago(PagoModel pago) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final nuevoPago = PagoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      monto: pago.monto,
      metodoPago: pago.metodoPago,
      fecha: DateTime.now(),
      descripcion: pago.descripcion,
      completado: true,
    );
    
    _historialPagos.insert(0, nuevoPago);
    return Right(nuevoPago);
  }
}
