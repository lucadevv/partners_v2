import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/register/domain/entities/rep_legal_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/request/document_rq.dart';
import 'package:partners/features/auth/register/domain/repository/register_repository.dart';
import 'package:partners/features/auth/register/domain/use_case/send_document_usecase.dart';

class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  late SendDocumentUsecase useCase;
  late MockRegisterRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(DocumentRq(
      number: '12345678',
      type: DocumentType.dni,
      sesionId: 'session-123',
    ));
  });

  setUp(() {
    mockRepository = MockRegisterRepository();
    useCase = SendDocumentUsecase(repository: mockRepository);
  });

  const tSessionId = 'session-123';
  const tDniNumber = '12345678';

  final tDocResponse = RepLegalResEntity(
    name: 'Juan',
    lastName: 'Pérez',
    documentEdentity: Dni(
      type: DocumentType.dni,
      number: tDniNumber,
      securityCode: '1',
    ),
    position: 'Representante Legal',
  );

  group('SendDocumentUsecase', () {
    test('retorna RepLegalResEntity cuando el documento es válido y el repo tiene éxito',
        () async {
      when(() => mockRepository.validateDocument(entity: any(named: 'entity')))
          .thenAnswer((_) async => Right(tDocResponse));

      final result = await useCase.call(
        type: DocumentType.dni,
        number: tDniNumber,
        sesionId: tSessionId,
      );

      expect(result, Right(tDocResponse));
      verify(() => mockRepository.validateDocument(entity: any(named: 'entity')))
          .called(1);
    });

    test('retorna Left cuando el número de documento no cumple formato DNI (8 dígitos)',
        () async {
      final result = await useCase.call(
        type: DocumentType.dni,
        number: '123',
        sesionId: tSessionId,
      );

      expect(result.isLeft(), true);
      verifyNever(() => mockRepository.validateDocument(entity: any(named: 'entity')));
    });

    test('retorna Left cuando sesionId está vacío', () async {
      final result = await useCase.call(
        type: DocumentType.dni,
        number: tDniNumber,
        sesionId: '',
      );

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'El ID de sesión no puede estar vacío'),
        (_) => throw StateError('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.validateDocument(entity: any(named: 'entity')));
    });

    test('retorna Left cuando el repositorio falla', () async {
      when(() => mockRepository.validateDocument(entity: any(named: 'entity')))
          .thenAnswer((_) async =>
              const Left(ValidationException('Documento no válido')));

      final result = await useCase.call(
        type: DocumentType.dni,
        number: tDniNumber,
        sesionId: tSessionId,
      );

      expect(
        result,
        const Left(ValidationException('Documento no válido')),
      );
      verify(() => mockRepository.validateDocument(entity: any(named: 'entity')))
          .called(1);
    });
  });
}
