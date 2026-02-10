import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/cubit/strategies/business_navigation_strategy.dart';
import 'package:partners/features/auth/cubit/strategies/navigation_strategy.dart';
import 'package:partners/features/auth/cubit/strategies/validation_navigation_strategy.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';
import 'package:partners/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_state.dart';
import 'package:partners/main.dart';

part 'orquestor_auth_state.dart';

class OrquestorAuthCubit extends Cubit<OrquestorAuthState> {
  final RegisterCubit _registerCubit;
  final LoginCubit _loginCubit;
  final AuthManager _authManager;
  final RoleService _roleService;
  final List<NavigationStrategy> _navigationStrategies = [
    BusinessNavigationStrategy(),
    ValidationNavigationStrategy(),
  ];

  StreamSubscription? _registerSubscription;
  StreamSubscription? _loginSubscription;

  OrquestorAuthCubit({
    required RegisterCubit registerCubit,
    required LoginCubit loginCubit,
    required AuthManager authManager,
  }) : _registerCubit = registerCubit,
       _loginCubit = loginCubit,
       _authManager = authManager,
       _roleService = getIt<RoleService>(),
       super(OrquestorAuthState.initial()) {
    _startListening();
  }

  void _startListening() {
    _registerSubscription = _registerCubit.stream.listen((registerState) {
      if (state.registerState != registerState) {
        emit(state.copyWith(registerState: registerState));
      }
    });

    _loginSubscription = _loginCubit.stream.listen((loginState) async {
      if (state.loginState != loginState) {
        emit(state.copyWith(loginState: loginState));
        
        // Procesar login exitoso y establecer rol del usuario
        if (loginState.status == LoginStatus.success && 
            loginState.responseEntity != null) {
          await _handleLoginSuccess(loginState.responseEntity!);
        }
      }
    });
  }

  /// Maneja el login exitoso: guarda tokens y establece el rol del usuario
  Future<void> _handleLoginSuccess(LoginResponseEntity responseEntity) async {
    try {
      // Guardar tokens en AuthManager
      await _authManager.login(
        responseEntity.accessToken,
        responseEntity.refreshToken,
        isCompleteData: responseEntity.isCompleteData,
        user: responseEntity.user,
      );
      
      // Establecer usuario y rol en RoleService
      _roleService.setUser(responseEntity.user);
      
      // Emitir efecto de navegación para que la UI navegue
      emit(state.copyWith(
        effect: NavigationLoginSuccessEffect(
          isCompleteData: responseEntity.isCompleteData,
        ),
      ));
    } catch (e) {
      // Error al procesar login - ya está manejado en el estado
    }
  }

  /// Inicia el proceso de login
  void login({required String email, required String password}) {
    _loginCubit.login(email: email, password: password);
  }

  Future<void> navigationStartValidationPage(RucType type) async {
    await _registerCubit.submitStart(type).then((_) {
      final registerState = _registerCubit.state;
      if (registerState.sendStartStatus == RegisterStatus.success) {
        final strategy = _navigationStrategies.firstWhere(
          (s) => s.canHandle(type),
          orElse: () => ValidationNavigationStrategy(),
        );
        emit(state.copyWith(effect: strategy.getEffect()));
      } else if (registerState.sendStartStatus == RegisterStatus.failure) {
        return;
      }
    });
  }

  void reset() {
    emit(OrquestorAuthState.initial());
  }

  @override
  Future<void> close() {
    _registerSubscription?.cancel();
    _loginSubscription?.cancel();
    return super.close();
  }
}
