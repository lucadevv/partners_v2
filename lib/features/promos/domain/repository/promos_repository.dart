import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/promos/domain/entities/promo_entity.dart';

/// Interfaz del repositorio de promos (capa Domain).
/// Sigue el principio de inversión de dependencias (DIP).
abstract class PromosRepository {
  Future<Either<AppException, List<PromoEntity>>> getPromos();
}
