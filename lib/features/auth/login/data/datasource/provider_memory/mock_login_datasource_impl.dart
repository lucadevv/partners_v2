import 'package:dartz/dartz.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/login/data/datasource/login_datasource.dart';
import 'package:partners/features/auth/login/data/models/login_response_model.dart';
import 'package:partners/features/auth/login/domain/entities/login_entity.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';

class MockLoginDatasourceImpl implements LoginDatasource {
  // Mock data para diferentes usuarios
  final Map<String, Map<String, LoginResponseModel>> _mockData = {
    // Usuarios con datos completos
    'usuario1@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_usuario1',
        refreshToken: 'mock_refresh_token_usuario1',
        isCompleteData: true,
      ),
    },
    'completo@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_completo',
        refreshToken: 'mock_refresh_token_completo',
        isCompleteData: true,
      ),
    },
    // Usuarios con datos incompletos
    'usuario2@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_usuario2',
        refreshToken: 'mock_refresh_token_usuario2',
        isCompleteData: false,
      ),
    },
    'incompleto@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_incompleto',
        refreshToken: 'mock_refresh_token_incompleto',
        isCompleteData: false,
      ),
    },
  };

  @override
  Future<Either<AppException, LoginResponseEntity>> login(
    LoginEntity entity,
  ) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 800));

    // Validar que el email y password no estén vacíos
    if (entity.email.isEmpty || entity.password.isEmpty) {
      return Left(
        ValidationException('Email y contraseña son requeridos'),
      );
    }

    // Validar formato de email básico
    if (!entity.email.contains('@')) {
      return Left(
        ValidationException('El formato del email no es válido'),
      );
    }

    // Buscar en mock data
    final userData = _mockData[entity.email.toLowerCase()];
    if (userData == null) {
      return Left(
        ValidationException('Usuario no encontrado'),
      );
    }

    final loginResponse = userData[entity.password];
    if (loginResponse == null) {
      return Left(
        ValidationException('Contraseña incorrecta'),
      );
    }

    // Retornar respuesta exitosa
    return Right(loginResponse.toEntity());
  }
}
