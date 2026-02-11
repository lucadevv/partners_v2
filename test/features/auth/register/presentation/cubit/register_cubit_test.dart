import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/core/services/database/flags/session_id_storage.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/models/dni.dart';
import 'package:partners/features/auth/register/domain/entities/rep_legal_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/register_response_entity.dart';
import 'package:partners/features/auth/register/domain/entities/response/start_resgister_res_entity.dart';
import 'package:partners/features/auth/register/domain/use_case/send_document_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/send_ruc_usecase.dart';
import 'package:partners/features/auth/register/domain/use_case/start_register_usecase.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_state.dart';

class MockSendRucUsecase extends Mock implements SendRucUsecase {}

class MockSendDocumentUsecase extends Mock implements SendDocumentUsecase {}

class MockStartRegisterUsecase extends Mock implements StartRegisterUsecase {}

class MockSessionIdStorage extends Mock implements SessionIdStorage {}

void main() {
  late MockSendRucUsecase mockSendRucUsecase;
  late MockSendDocumentUsecase mockSendDocumentUsecase;
  late MockStartRegisterUsecase mockStartRegisterUsecase;
  late MockSessionIdStorage mockSessionIdStorage;

  const tRuc10 = '10123456789';
  const tSessionId = 'session-123';

  final tRucResponse = RegisterResponseEntity(
    sessionId: tSessionId,
    ruc: tRuc10,
    isExists: false,
    socialReason: 'Empresa Test',
  );

  final tDocResponse = RepLegalResEntity(
    name: 'Juan',
    lastName: 'Pérez',
    documentEdentity: Dni(
      type: DocumentType.dni,
      number: '12345678',
      securityCode: '1',
    ),
    position: 'Representante Legal',
  );

  final tStartResponse = const StartRegisterResEntity(
    message: 'OK',
    sessionId: tSessionId,
    nextStep: 'validation',
  );

  setUpAll(() {
    registerFallbackValue(RucType.ruc10);
    registerFallbackValue(DocumentType.dni);
  });

  setUp(() {
    mockSendRucUsecase = MockSendRucUsecase();
    mockSendDocumentUsecase = MockSendDocumentUsecase();
    mockStartRegisterUsecase = MockStartRegisterUsecase();
    mockSessionIdStorage = MockSessionIdStorage();
  });

  RegisterCubit buildCubit() => RegisterCubit(
        sendRucUsecase: mockSendRucUsecase,
        sendDocumentUsecase: mockSendDocumentUsecase,
        startRegisterUsecase: mockStartRegisterUsecase,
        sessionStorage: mockSessionIdStorage,
      );

  group('RegisterCubit', () {
    test('estado inicial es RegisterStateX con todos los status en initial', () {
      when(() => mockSessionIdStorage.sessionId).thenReturn(null);
      final cubit = buildCubit();
      expect(cubit.state.sendRucStatus, RegisterStatus.initial);
      expect(cubit.state.sendDocStatus, RegisterStatus.initial);
      expect(cubit.state.sendStartStatus, RegisterStatus.initial);
      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.rucData.sessionId, '');
      expect(cubit.state.rucData.ruc, '');
      expect(cubit.state.docData.name, '');
      expect(cubit.state.docData.lastName, '');
      expect(cubit.state.startRegisterResEntity.sessionId, '');
      cubit.close();
    });

    blocTest<RegisterCubit, RegisterStateX>(
      'sendRuc emite [loading, success] y guarda sessionId cuando tiene éxito',
      build: () {
        when(() => mockSendRucUsecase.call(ruc: any(named: 'ruc'), type: any(named: 'type')))
            .thenAnswer((_) async => Right(tRucResponse));
        return buildCubit();
      },
      act: (cubit) => cubit.sendRuc(ruc: tRuc10, type: RucType.ruc10),
      expect: () => [
        predicate<RegisterStateX>((s) => s.sendRucStatus == RegisterStatus.loading),
        predicate<RegisterStateX>((s) =>
            s.sendRucStatus == RegisterStatus.success &&
            s.rucData.sessionId == tSessionId &&
            s.rucData.socialReason == 'Empresa Test'),
      ],
      verify: (_) {
        verify(() => mockSessionIdStorage.saveSessionId(tSessionId)).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterStateX>(
      'sendRuc emite [loading, failure] cuando el use case retorna Left',
      build: () {
        when(() => mockSendRucUsecase.call(ruc: any(named: 'ruc'), type: any(named: 'type')))
            .thenAnswer((_) async =>
                const Left(ValidationException('Ruc no valido')));
        return buildCubit();
      },
      act: (cubit) => cubit.sendRuc(ruc: '999', type: RucType.ruc10),
      expect: () => [
        predicate<RegisterStateX>((s) => s.sendRucStatus == RegisterStatus.loading),
        predicate<RegisterStateX>((s) =>
            s.sendRucStatus == RegisterStatus.failure &&
            s.errorMessage == 'Ruc no valido'),
      ],
    );

    blocTest<RegisterCubit, RegisterStateX>(
      'sendRuc no llama al use case dos veces si ya está en loading',
      build: () {
        when(() => mockSendRucUsecase.call(ruc: any(named: 'ruc'), type: any(named: 'type')))
            .thenAnswer((_) => Completer<Either<AppException, RegisterResponseEntity>>().future);
        return buildCubit();
      },
      act: (cubit) {
        cubit.sendRuc(ruc: tRuc10, type: RucType.ruc10);
        cubit.sendRuc(ruc: tRuc10, type: RucType.ruc10);
      },
      expect: () => [
        predicate<RegisterStateX>((s) => s.sendRucStatus == RegisterStatus.loading),
      ],
      verify: (_) {
        verify(() => mockSendRucUsecase.call(ruc: tRuc10, type: RucType.ruc10)).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterStateX>(
      'sendDocumendt emite [loading, success] cuando hay sessionId y el use case tiene éxito',
      build: () {
        when(() => mockSessionIdStorage.sessionId).thenReturn(tSessionId);
        when(() => mockSendDocumentUsecase.call(
              type: any(named: 'type'),
              number: any(named: 'number'),
              sesionId: any(named: 'sesionId'),
            )).thenAnswer((_) async => Right(tDocResponse));
        return buildCubit();
      },
      act: (cubit) => cubit.sendDocumendt(
            type: DocumentType.dni,
            number: '12345678',
          ),
      expect: () => [
        predicate<RegisterStateX>((s) => s.sendDocStatus == RegisterStatus.loading),
        predicate<RegisterStateX>((s) =>
            s.sendDocStatus == RegisterStatus.success &&
            s.docData.name == 'Juan' &&
            s.docData.lastName == 'Pérez'),
      ],
    );

    blocTest<RegisterCubit, RegisterStateX>(
      'sendDocumendt emite [loading, failure] cuando el use case retorna Left',
      build: () {
        when(() => mockSessionIdStorage.sessionId).thenReturn(tSessionId);
        when(() => mockSendDocumentUsecase.call(
              type: any(named: 'type'),
              number: any(named: 'number'),
              sesionId: any(named: 'sesionId'),
            )).thenAnswer((_) async =>
            const Left(ValidationException('Documento no válido')));
        return buildCubit();
      },
      act: (cubit) => cubit.sendDocumendt(
            type: DocumentType.dni,
            number: '12345678',
          ),
      expect: () => [
        predicate<RegisterStateX>((s) => s.sendDocStatus == RegisterStatus.loading),
        predicate<RegisterStateX>((s) =>
            s.sendDocStatus == RegisterStatus.failure &&
            s.errorMessage == 'Documento no válido'),
      ],
    );

    blocTest<RegisterCubit, RegisterStateX>(
      'sendDocumendt no llama al use case dos veces si ya está en loading',
      build: () {
        when(() => mockSessionIdStorage.sessionId).thenReturn(tSessionId);
        when(() => mockSendDocumentUsecase.call(
              type: any(named: 'type'),
              number: any(named: 'number'),
              sesionId: any(named: 'sesionId'),
            )).thenAnswer((_) =>
            Completer<Either<AppException, RepLegalResEntity>>().future);
        return buildCubit();
      },
      act: (cubit) {
        cubit.sendDocumendt(type: DocumentType.dni, number: '12345678');
        cubit.sendDocumendt(type: DocumentType.dni, number: '12345678');
      },
      expect: () => [
        predicate<RegisterStateX>((s) => s.sendDocStatus == RegisterStatus.loading),
      ],
      verify: (_) {
        verify(() => mockSendDocumentUsecase.call(
              type: DocumentType.dni,
              number: '12345678',
              sesionId: tSessionId,
            )).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterStateX>(
      'submitStart emite [loading, success] cuando hay sessionId y el use case tiene éxito',
      build: () {
        when(() => mockSessionIdStorage.sessionId).thenReturn(tSessionId);
        when(() => mockStartRegisterUsecase.call(
              type: any(named: 'type'),
              sessionId: any(named: 'sessionId'),
            )).thenAnswer((_) async => Right(tStartResponse));
        return buildCubit();
      },
      act: (cubit) => cubit.submitStart(RucType.ruc10),
      expect: () => [
        predicate<RegisterStateX>((s) => s.sendStartStatus == RegisterStatus.loading),
        predicate<RegisterStateX>((s) =>
            s.sendStartStatus == RegisterStatus.success &&
            s.startRegisterResEntity.sessionId == tSessionId &&
            s.startRegisterResEntity.nextStep == 'validation'),
      ],
    );

    blocTest<RegisterCubit, RegisterStateX>(
      'submitStart emite [loading, failure] cuando el use case retorna Left',
      build: () {
        when(() => mockSessionIdStorage.sessionId).thenReturn(tSessionId);
        when(() => mockStartRegisterUsecase.call(
              type: any(named: 'type'),
              sessionId: any(named: 'sessionId'),
            )).thenAnswer((_) async =>
            const Left(ValidationException('Error al iniciar registro')));
        return buildCubit();
      },
      act: (cubit) => cubit.submitStart(RucType.ruc10),
      expect: () => [
        predicate<RegisterStateX>((s) => s.sendStartStatus == RegisterStatus.loading),
        predicate<RegisterStateX>((s) =>
            s.sendStartStatus == RegisterStatus.failure &&
            s.errorMessage == 'Error al iniciar registro'),
      ],
    );

    blocTest<RegisterCubit, RegisterStateX>(
      'submitStart no llama al use case dos veces si ya está en loading',
      build: () {
        when(() => mockSessionIdStorage.sessionId).thenReturn(tSessionId);
        when(() => mockStartRegisterUsecase.call(
              type: any(named: 'type'),
              sessionId: any(named: 'sessionId'),
            )).thenAnswer((_) =>
            Completer<Either<AppException, StartRegisterResEntity>>().future);
        return buildCubit();
      },
      act: (cubit) {
        cubit.submitStart(RucType.ruc10);
        cubit.submitStart(RucType.ruc10);
      },
      expect: () => [
        predicate<RegisterStateX>((s) => s.sendStartStatus == RegisterStatus.loading),
      ],
      verify: (_) {
        verify(() => mockStartRegisterUsecase.call(
              type: RucType.ruc10,
              sessionId: tSessionId,
            )).called(1);
      },
    );

    blocTest<RegisterCubit, RegisterStateX>(
      'reset emite estado inicial y no mantiene datos previos',
      build: () => buildCubit(),
      seed: () => RegisterStateX.initial().copyWith(
            sendRucStatus: RegisterStatus.success,
            rucData: tRucResponse,
            errorMessage: 'Error previo',
          ),
      act: (cubit) => cubit.reset(),
      expect: () => [
        predicate<RegisterStateX>((s) =>
            s.sendRucStatus == RegisterStatus.initial &&
            s.sendDocStatus == RegisterStatus.initial &&
            s.sendStartStatus == RegisterStatus.initial &&
            s.errorMessage == null &&
            s.rucData.sessionId == ''),
      ],
    );
  });
}
