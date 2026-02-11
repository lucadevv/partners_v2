import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/promos/data/datasource/promos_datasource.dart';
import 'package:partners/features/promos/data/models/promo_model.dart';

/// Implementación mock del datasource de promos (memoria).
class MockPromosDatasourceImpl implements PromosDatasource {
  @override
  Future<Either<AppException, List<PromoModel>>> getPromos() async {
    return Right<AppException, List<PromoModel>>([
      const PromoModel(id: '1', title: 'Promo 2x1', imageUrl: null),
      const PromoModel(id: '2', title: 'Descuento 20%', imageUrl: null),
      const PromoModel(id: '3', title: 'Happy Hour', imageUrl: null),
    ]);
  }
}
