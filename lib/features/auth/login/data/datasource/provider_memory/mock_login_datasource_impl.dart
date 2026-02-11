import 'package:dartz/dartz.dart';
import 'package:partners/core/models/user_model.dart';
import 'package:partners/core/models/user_role.dart';
import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/features/auth/login/data/datasource/login_datasource.dart';
import 'package:partners/features/auth/login/data/models/login_response_model.dart';
import 'package:partners/features/auth/login/domain/entities/login_entity.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';

class MockLoginDatasourceImpl implements LoginDatasource {
  // Mock data para diferentes usuarios con roles
  final Map<String, Map<String, LoginResponseModel>> _mockData = {
    // ===== DUEÑO DEL NEGOCIO (Business Owner) =====
    'owner@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_owner',
        refreshToken: 'mock_refresh_token_owner',
        user: const UserModel(
          id: '1',
          email: 'owner@example.com',
          name: 'Dueño del Negocio',
          role: UserRole.businessOwner,
        ),
      ),
    },
    'dueno@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_dueno',
        refreshToken: 'mock_refresh_token_dueno',
        user: const UserModel(
          id: '2',
          email: 'dueno@example.com',
          name: 'Juan Pérez - Dueño',
          role: UserRole.businessOwner,
        ),
      ),
    },
    
    // ===== ADMINISTRADOR (Administrator) =====
    'admin@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_admin',
        refreshToken: 'mock_refresh_token_admin',
        user: const UserModel(
          id: '3',
          email: 'admin@example.com',
          name: 'Administrador Sucursal',
          role: UserRole.administrator,
          branchId: 'branch_001', // ID de sucursal que administra
        ),
      ),
    },
    'administrador@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_administrador',
        refreshToken: 'mock_refresh_token_administrador',
        user: const UserModel(
          id: '4',
          email: 'administrador@example.com',
          name: 'María García - Administradora',
          role: UserRole.administrator,
          branchId: 'branch_002',
        ),
      ),
    },
    
    // ===== MESERO/CAJERA (Waiter/Cashier) =====
    'waiter@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_waiter',
        refreshToken: 'mock_refresh_token_waiter',
        user: const UserModel(
          id: '5',
          email: 'waiter@example.com',
          name: 'Mesero/Cajera',
          role: UserRole.waiterCashier,
          branchId: 'branch_001',
        ),
      ),
    },
    'cajera@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_cajera',
        refreshToken: 'mock_refresh_token_cajera',
        user: const UserModel(
          id: '6',
          email: 'cajera@example.com',
          name: 'Ana López - Cajera',
          role: UserRole.waiterCashier,
          branchId: 'branch_001',
        ),
      ),
    },
    'mesero@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_mesero',
        refreshToken: 'mock_refresh_token_mesero',
        user: const UserModel(
          id: '7',
          email: 'mesero@example.com',
          name: 'Carlos Rodríguez - Mesero',
          role: UserRole.waiterCashier,
          branchId: 'branch_002',
        ),
      ),
    },
    
    // ===== USUARIOS CON DATOS INCOMPLETOS (para testing) =====
    'incompleto@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_incompleto',
        refreshToken: 'mock_refresh_token_incompleto',
        user: const UserModel(
          id: '8',
          email: 'incompleto@example.com',
          name: 'Usuario Incompleto',
          role: UserRole.waiterCashier,
        ),
      ),
    },
    
    // ===== USUARIOS LEGACY (mantener compatibilidad) =====
    'usuario1@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_usuario1',
        refreshToken: 'mock_refresh_token_usuario1',
        user: const UserModel(
          id: '9',
          email: 'usuario1@example.com',
          name: 'Usuario 1',
          role: UserRole.waiterCashier, // Por defecto mesero/cajera
        ),
      ),
    },
    'completo@example.com': {
      'password123': LoginResponseModel(
        accessToken: 'mock_access_token_completo',
        refreshToken: 'mock_refresh_token_completo',
        user: const UserModel(
          id: '10',
          email: 'completo@example.com',
          name: 'Usuario Completo',
          role: UserRole.administrator,
        ),
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
