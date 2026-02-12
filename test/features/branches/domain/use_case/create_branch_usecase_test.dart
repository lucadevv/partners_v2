import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/branches/domain/entities/create_branch_params.dart';
import 'package:partners/features/branches/domain/repository/branches_repository.dart';
import 'package:partners/features/branches/domain/use_case/create_branch_usecase.dart';

class MockBranchesRepository extends Mock implements BranchesRepository {}

/// Parámetros válidos mínimos para crear sucursal.
CreateBranchParams validParams() {
  return const CreateBranchParams(
    subcategoryId: 'sub-1',
    name: 'Sucursal Centro',
    address: 'Av. Principal 123',
    latitude: -12.0464,
    longitude: -77.0428,
    phoneContacts: '999888777',
    logoPath: '/path/logo.jpg',
    monday: true,
    tuesday: true,
    wednesday: true,
    thursday: true,
    friday: true,
    saturday: false,
    sunday: false,
    startTime: '09:00',
    endTime: '18:00',
  );
}

void main() {
  late CreateBranchUseCase useCase;
  late MockBranchesRepository mockRepository;

  setUp(() {
    mockRepository = MockBranchesRepository();
    useCase = CreateBranchUseCase(repository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(validParams());
  });

  group('CreateBranchUseCase', () {
    test('retorna Right(mensaje) cuando el repositorio crea la sucursal con éxito',
        () async {
      const message = 'Sucursal creada con éxito';
      when(() => mockRepository.createBranch(any()))
          .thenAnswer((_) async => const Right(message));

      final result = await useCase.call(validParams());

      expect(result, const Right(message));
      verify(() => mockRepository.createBranch(validParams())).called(1);
    });

    test('retorna Left(ValidationException) cuando el repositorio falla', () async {
      const failure = ValidationException('Error del servidor');
      when(() => mockRepository.createBranch(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase.call(validParams());

      expect(result, const Left(failure));
      verify(() => mockRepository.createBranch(validParams())).called(1);
    });

    test('retorna Left cuando subcategoryId está vacío', () async {
      final params = CreateBranchParams(
        subcategoryId: '   ',
        name: validParams().name,
        address: validParams().address,
        latitude: validParams().latitude,
        longitude: validParams().longitude,
        phoneContacts: validParams().phoneContacts,
        logoPath: validParams().logoPath,
        monday: validParams().monday,
        tuesday: validParams().tuesday,
        wednesday: validParams().wednesday,
        thursday: validParams().thursday,
        friday: validParams().friday,
        saturday: validParams().saturday,
        sunday: validParams().sunday,
        startTime: validParams().startTime,
        endTime: validParams().endTime,
      );

      final result = await useCase.call(params);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Debe seleccionar una subcategoría'),
        (_) => fail('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.createBranch(any()));
    });

    test('retorna Left cuando el nombre está vacío', () async {
      final params = CreateBranchParams(
        subcategoryId: validParams().subcategoryId,
        name: '   ',
        address: validParams().address,
        latitude: validParams().latitude,
        longitude: validParams().longitude,
        phoneContacts: validParams().phoneContacts,
        logoPath: validParams().logoPath,
        monday: validParams().monday,
        tuesday: validParams().tuesday,
        wednesday: validParams().wednesday,
        thursday: validParams().thursday,
        friday: validParams().friday,
        saturday: validParams().saturday,
        sunday: validParams().sunday,
        startTime: validParams().startTime,
        endTime: validParams().endTime,
      );

      final result = await useCase.call(params);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'El nombre es requerido'),
        (_) => fail('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.createBranch(any()));
    });

    test('retorna Left cuando el nombre tiene menos de 2 caracteres', () async {
      final params = CreateBranchParams(
        subcategoryId: validParams().subcategoryId,
        name: 'A',
        address: validParams().address,
        latitude: validParams().latitude,
        longitude: validParams().longitude,
        phoneContacts: validParams().phoneContacts,
        logoPath: validParams().logoPath,
        monday: validParams().monday,
        tuesday: validParams().tuesday,
        wednesday: validParams().wednesday,
        thursday: validParams().thursday,
        friday: validParams().friday,
        saturday: validParams().saturday,
        sunday: validParams().sunday,
        startTime: validParams().startTime,
        endTime: validParams().endTime,
      );

      final result = await useCase.call(params);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'El nombre debe tener al menos 2 caracteres'),
        (_) => fail('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.createBranch(any()));
    });

    test('retorna Left cuando la dirección está vacía', () async {
      final params = CreateBranchParams(
        subcategoryId: validParams().subcategoryId,
        name: validParams().name,
        address: '   ',
        latitude: validParams().latitude,
        longitude: validParams().longitude,
        phoneContacts: validParams().phoneContacts,
        logoPath: validParams().logoPath,
        monday: validParams().monday,
        tuesday: validParams().tuesday,
        wednesday: validParams().wednesday,
        thursday: validParams().thursday,
        friday: validParams().friday,
        saturday: validParams().saturday,
        sunday: validParams().sunday,
        startTime: validParams().startTime,
        endTime: validParams().endTime,
      );

      final result = await useCase.call(params);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'La dirección es requerida'),
        (_) => fail('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.createBranch(any()));
    });

    test('retorna Left cuando la latitud es inválida (< -90)', () async {
      final params = CreateBranchParams(
        subcategoryId: validParams().subcategoryId,
        name: validParams().name,
        address: validParams().address,
        latitude: -91,
        longitude: validParams().longitude,
        phoneContacts: validParams().phoneContacts,
        logoPath: validParams().logoPath,
        monday: validParams().monday,
        tuesday: validParams().tuesday,
        wednesday: validParams().wednesday,
        thursday: validParams().thursday,
        friday: validParams().friday,
        saturday: validParams().saturday,
        sunday: validParams().sunday,
        startTime: validParams().startTime,
        endTime: validParams().endTime,
      );

      final result = await useCase.call(params);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Latitud inválida'),
        (_) => fail('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.createBranch(any()));
    });

    test('retorna Left cuando la longitud es inválida (> 180)', () async {
      final params = CreateBranchParams(
        subcategoryId: validParams().subcategoryId,
        name: validParams().name,
        address: validParams().address,
        latitude: validParams().latitude,
        longitude: 181,
        phoneContacts: validParams().phoneContacts,
        logoPath: validParams().logoPath,
        monday: validParams().monday,
        tuesday: validParams().tuesday,
        wednesday: validParams().wednesday,
        thursday: validParams().thursday,
        friday: validParams().friday,
        saturday: validParams().saturday,
        sunday: validParams().sunday,
        startTime: validParams().startTime,
        endTime: validParams().endTime,
      );

      final result = await useCase.call(params);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'Longitud inválida'),
        (_) => fail('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.createBranch(any()));
    });

    test('retorna Left cuando el teléfono está vacío', () async {
      final params = CreateBranchParams(
        subcategoryId: validParams().subcategoryId,
        name: validParams().name,
        address: validParams().address,
        latitude: validParams().latitude,
        longitude: validParams().longitude,
        phoneContacts: '   ',
        logoPath: validParams().logoPath,
        monday: validParams().monday,
        tuesday: validParams().tuesday,
        wednesday: validParams().wednesday,
        thursday: validParams().thursday,
        friday: validParams().friday,
        saturday: validParams().saturday,
        sunday: validParams().sunday,
        startTime: validParams().startTime,
        endTime: validParams().endTime,
      );

      final result = await useCase.call(params);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.message, 'El teléfono es requerido'),
        (_) => fail('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.createBranch(any()));
    });

    test('retorna Left cuando no hay horario de inicio o fin', () async {
      final params = CreateBranchParams(
        subcategoryId: validParams().subcategoryId,
        name: validParams().name,
        address: validParams().address,
        latitude: validParams().latitude,
        longitude: validParams().longitude,
        phoneContacts: validParams().phoneContacts,
        logoPath: validParams().logoPath,
        monday: validParams().monday,
        tuesday: validParams().tuesday,
        wednesday: validParams().wednesday,
        thursday: validParams().thursday,
        friday: validParams().friday,
        saturday: validParams().saturday,
        sunday: validParams().sunday,
        startTime: '',
        endTime: '18:00',
      );

      final result = await useCase.call(params);

      expect(result.isLeft(), true);
      result.fold(
        (l) =>
            expect(l.message, 'Debe configurar horario de inicio y fin'),
        (_) => fail('Se esperaba Left'),
      );
      verifyNever(() => mockRepository.createBranch(any()));
    });
  });
}
