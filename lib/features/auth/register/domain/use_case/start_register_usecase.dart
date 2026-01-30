import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/domain/entities/request/start_register_req.dart';
import 'package:partners/features/auth/register/domain/entities/response/start_resgister_res_entity.dart';
import 'package:partners/features/auth/register/domain/factory/ruc_config_factory.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';

class StartRegisterUsecase {
  final RegisterRepository _repository;

  StartRegisterUsecase({required RegisterRepository repository})
    : _repository = repository;

  Future<Either<AppException, StartRegisterResEntity>> call({
    required RucType type,
    required String sessionId,
  }) async {
    final strategy = RucConfigFactory.getValidatorStrategy(type);
    final entity = StartRegisterReq(
      sessionId: sessionId,
      rucType: strategy.getRuc(),
    );
    return await _repository.startRegister(entity: entity);
  }
}
