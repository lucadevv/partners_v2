import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partners/core/models/user_model.dart';
import 'package:partners/core/models/user_role.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/login/domain/entities/login_entity.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';
import 'package:partners/features/auth/login/domain/use_case/login_usecase.dart';
import 'package:partners/features/auth/login/presentation/cubit/login_cubit.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

void main() {
  late MockLoginUsecase mockUsecase;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  final tUser = const UserModel(
    id: '1',
    email: tEmail,
    name: 'Test User',
    role: UserRole.waiterCashier,
  );
  late LoginResponseEntity tResponse;

  setUpAll(() {
    registerFallbackValue(
      const LoginEntity(email: tEmail, password: tPassword),
    );
    tResponse = LoginResponseEntity(
      accessToken: 'token',
      refreshToken: 'refresh',
      user: tUser,
    );
  });

  setUp(() {
    mockUsecase = MockLoginUsecase();
  });

  group('LoginCubit', () {
    test('estado inicial es LoginState con status initial', () {
      final cubit = LoginCubit(loginUsecase: mockUsecase);
      expect(cubit.state, const LoginState(status: LoginStatus.initial));
      cubit.close();
    });

    blocTest<LoginCubit, LoginState>(
      'emite [loading, success] cuando login tiene éxito',
      build: () {
        when(
          () => mockUsecase.login(any()),
        ).thenAnswer((_) async => Right(tResponse));
        return LoginCubit(loginUsecase: mockUsecase);
      },
      act: (cubit) => cubit.login(email: tEmail, password: tPassword),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        LoginState(
          status: LoginStatus.success,
          responseEntity: tResponse,
          errorMessage: null,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emite [loading, failure] cuando el use case retorna Left',
      build: () {
        when(() => mockUsecase.login(any())).thenAnswer(
          (_) async =>
              const Left(ValidationException('Credenciales inválidas')),
        );
        return LoginCubit(loginUsecase: mockUsecase);
      },
      act: (cubit) => cubit.login(email: tEmail, password: tPassword),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        const LoginState(
          status: LoginStatus.failure,
          errorMessage: 'Credenciales inválidas',
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'no llama al use case dos veces si ya está en loading',
      build: () {
        when(() => mockUsecase.login(any())).thenAnswer(
          (_) => Completer<Either<AppException, LoginResponseEntity>>().future,
        );
        return LoginCubit(loginUsecase: mockUsecase);
      },
      act: (cubit) {
        cubit.login(email: tEmail, password: tPassword);
        cubit.login(email: tEmail, password: tPassword);
      },
      expect: () => [const LoginState(status: LoginStatus.loading)],
      verify: (_) {
        verify(() => mockUsecase.login(any())).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'reset emite estado inicial',
      build: () {
        when(
          () => mockUsecase.login(any()),
        ).thenAnswer((_) async => Right(tResponse));
        return LoginCubit(loginUsecase: mockUsecase);
      },
      seed: () => const LoginState(
        status: LoginStatus.failure,
        errorMessage: 'Error previo',
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [
        const LoginState(
          status: LoginStatus.initial,
          errorMessage: null,
          responseEntity: null,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emite failure con mensaje cuando el use case retorna Usuario no encontrado',
      build: () {
        when(() => mockUsecase.login(any())).thenAnswer(
          (_) async => const Left(
            ValidationException('Usuario no encontrado'),
          ),
        );
        return LoginCubit(loginUsecase: mockUsecase);
      },
      act: (cubit) => cubit.login(email: tEmail, password: tPassword),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        const LoginState(
          status: LoginStatus.failure,
          errorMessage: 'Usuario no encontrado',
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emite failure con mensaje cuando el use case retorna Contraseña incorrecta',
      build: () {
        when(() => mockUsecase.login(any())).thenAnswer(
          (_) async => const Left(
            ValidationException('Contraseña incorrecta'),
          ),
        );
        return LoginCubit(loginUsecase: mockUsecase);
      },
      act: (cubit) => cubit.login(email: tEmail, password: tPassword),
      expect: () => [
        const LoginState(status: LoginStatus.loading),
        const LoginState(
          status: LoginStatus.failure,
          errorMessage: 'Contraseña incorrecta',
        ),
      ],
    );
  });
}
