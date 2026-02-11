import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/domain/entities/request/start_register_req.dart';
import 'package:partners/features/auth/register/domain/entities/response/start_resgister_res_entity.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';
import 'package:partners/features/auth/register/domain/use_case/start_register_usecase.dart';

class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  late StartRegisterUsecase useCase;
  late MockRegisterRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const StartRegisterReq(
      sessionId: 'session-456',
      rucType: RucType.ruc10,
    ));
  });

  setUp(() {
    mockRepository = MockRegisterRepository();
    useCase = StartRegisterUsecase(repository: mockRepository);
  });

  const tSessionId = 'session-456';

  final tResponse = const StartRegisterResEntity(
    message: 'OK',
    sessionId: tSessionId,
    nextStep: 'validation',
  );

  group('StartRegisterUsecase', () {
    test('retorna StartRegisterResEntity cuando el repo tiene éxito', () async {
      when(() => mockRepository.startRegister(entity: any(named: 'entity')))
          .thenAnswer((_) async => Right(tResponse));

      final result = await useCase.call(
        type: RucType.ruc10,
        sessionId: tSessionId,
      );

      expect(result, Right(tResponse));
      verify(() => mockRepository.startRegister(entity: any(named: 'entity')))
          .called(1);
    });

    test('retorna Left cuando el repositorio falla', () async {
      when(() => mockRepository.startRegister(entity: any(named: 'entity')))
          .thenAnswer((_) async =>
              const Left(ValidationException('Error al iniciar registro')));

      final result = await useCase.call(
        type: RucType.ruc10,
        sessionId: tSessionId,
      );

      expect(
        result,
        const Left(ValidationException('Error al iniciar registro')),
      );
      verify(() => mockRepository.startRegister(entity: any(named: 'entity')))
          .called(1);
    });
  });
}
