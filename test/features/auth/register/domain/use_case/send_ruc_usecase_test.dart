import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/request/entity_rq.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';
import 'package:partners/features/auth/register/domain/use_case/send_ruc_usecase.dart';

class MockRegisterRepository extends Mock implements RegisterRepository {}

const tRuc10 = '10733456723';
const tRuc20 = '20123456789';

void main() {
  late SendRucUsecase useCase;
  late MockRegisterRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(EntityRq(ruc: tRuc10));
  });

  setUp(() {
    mockRepository = MockRegisterRepository();
    useCase = SendRucUsecase(repository: mockRepository);
  });

  const tResponse = RegisterResponseEntity(
    sessionId: 'session-1',
    ruc: tRuc10,
    isExists: true,
    socialReason: 'Razón Social Test',
  );

  group('SendRucUsecase', () {
    test('retorna RegisterResponseEntity cuando el RUC es válido y el repo tiene éxito',
        () async {
      when(() => mockRepository.validateComerce(entity: any(named: 'entity')))
          .thenAnswer((_) async => const Right(tResponse));

      final result = await useCase.call(type: RucType.ruc10, ruc: tRuc10);

      expect(result, const Right(tResponse));
      verify(() => mockRepository.validateComerce(entity: any(named: 'entity')))
          .called(1);
    });

    test('retorna Left(Ruc no valido) cuando el RUC no cumple formato ruc10',
        () async {
      final result = await useCase.call(type: RucType.ruc10, ruc: '123');

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Ruc no valido'),
        (_) => throw StateError('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.validateComerce(entity: any(named: 'entity')));
    });

    test('retorna Left cuando el RUC tiene 11 dígitos pero no empieza con 10 para ruc10',
        () async {
      final result = await useCase.call(type: RucType.ruc10, ruc: '20123456789');

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Ruc no valido'),
        (_) => throw StateError('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.validateComerce(entity: any(named: 'entity')));
    });

    test('retorna Left cuando el repositorio falla', () async {
      when(() => mockRepository.validateComerce(entity: any(named: 'entity')))
          .thenAnswer((_) async =>
              const Left(ValidationException('Comercio no encontrado')));

      final result = await useCase.call(type: RucType.ruc10, ruc: tRuc10);

      expect(
        result,
        const Left(ValidationException('Comercio no encontrado')),
      );
      verify(() => mockRepository.validateComerce(entity: any(named: 'entity')))
          .called(1);
    });

    test('acepta RUC 20 válido (11 dígitos, empieza con 20)', () async {
      when(() => mockRepository.validateComerce(entity: any(named: 'entity')))
          .thenAnswer((_) async => const Right(RegisterResponseEntity(
                sessionId: 's2',
                ruc: tRuc20,
                isExists: true,
                socialReason: 'Empresa 20',
              )));

      final result = await useCase.call(type: RucType.ruc20, ruc: tRuc20);

      expect(result.isRight(), true);
      verify(() => mockRepository.validateComerce(entity: any(named: 'entity')))
          .called(1);
    });
  });
}
