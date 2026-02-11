import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/core/models/user_model.dart';
import 'package:partners/core/models/user_role.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/login/domain/entities/login_entity.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';
import 'package:partners/features/auth/login/domain/repository/login_repository.dart';
import 'package:partners/features/auth/login/domain/use_case/login_usecase.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  late LoginUsecase useCase;
  late MockLoginRepository mockRepository;

  setUp(() {
    mockRepository = MockLoginRepository();
    useCase = LoginUsecase(repository: mockRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tEntity = const LoginEntity(email: tEmail, password: tPassword);

  final tUser = const UserModel(
    id: '1',
    email: tEmail,
    name: 'Test User',
    role: UserRole.waiterCashier,
  );
  late final LoginResponseEntity tResponse;
  setUpAll(() {
    registerFallbackValue(const LoginEntity(email: tEmail, password: tPassword));
    tResponse = LoginResponseEntity(
      accessToken: 'token',
      refreshToken: 'refresh',
      user: tUser,
    );
  });

  group('LoginUsecase', () {
    test('debería retornar LoginResponseEntity cuando el repositorio tiene éxito',
        () async {
      when(() => mockRepository.login(any()))
          .thenAnswer((_) async => Right(tResponse));

      final result = await useCase.login(tEntity);

      expect(result, Right(tResponse));
      verify(() => mockRepository.login(tEntity)).called(1);
    });

    test('debería retornar Left(AppException) cuando el repositorio falla',
        () async {
      const failure = ValidationException('Credenciales inválidas');
      when(() => mockRepository.login(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase.login(tEntity);

      expect(result, const Left(failure));
      verify(() => mockRepository.login(tEntity)).called(1);
    });

    test('debería retornar Left con mensaje Usuario no encontrado', () async {
      const failure = ValidationException('Usuario no encontrado');
      when(() => mockRepository.login(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase.login(tEntity);

      expect(result, const Left(failure));
      verify(() => mockRepository.login(tEntity)).called(1);
    });

    test('debería retornar Left con mensaje Contraseña incorrecta', () async {
      const failure = ValidationException('Contraseña incorrecta');
      when(() => mockRepository.login(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase.login(tEntity);

      expect(result, const Left(failure));
      verify(() => mockRepository.login(tEntity)).called(1);
    });
  });
}
