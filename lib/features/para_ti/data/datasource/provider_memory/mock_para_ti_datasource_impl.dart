import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/para_ti/data/models/recomendacion_model.dart';
import 'package:partners/features/para_ti/domain/entities/recomendacion_entity.dart';

abstract class ParaTiDatasource {
  Future<Either<AppException, List<RecomendacionEntity>>> getRecomendaciones();
}

class MockParaTiDatasourceImpl implements ParaTiDatasource {
  final List<RecomendacionModel> _recomendaciones = [
    const RecomendacionModel(
      id: '1',
      titulo: 'Oferta Especial',
      descripcion: '20% de descuento en todos los cafés',
      imagenUrl: 'https://via.placeholder.com/300',
      tipo: 'oferta',
    ),
    const RecomendacionModel(
      id: '2',
      titulo: 'Nuevo Producto',
      descripcion: 'Prueba nuestro nuevo latte de vainilla',
      imagenUrl: 'https://via.placeholder.com/300',
      tipo: 'producto',
    ),
    const RecomendacionModel(
      id: '3',
      titulo: 'Noticia',
      descripcion: 'Ahora aceptamos Yape y Plin',
      imagenUrl: 'https://via.placeholder.com/300',
      tipo: 'noticia',
    ),
  ];

  @override
  Future<Either<AppException, List<RecomendacionEntity>>> getRecomendaciones() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(_recomendaciones.map((m) => m.toEntity()).toList());
  }
}
