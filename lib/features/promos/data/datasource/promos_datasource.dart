import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/promos/data/models/promo_model.dart';

/// Interfaz del datasource de promos (capa Data).
abstract class PromosDatasource {
  Future<Either<AppException, List<PromoModel>>> getPromos();
}
