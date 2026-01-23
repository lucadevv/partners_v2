import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';
import 'package:partners/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:partners/features/auth/register/domain/entities/register_entity.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';

part 'orquestor_auth_state.dart';

/// SOLID: Single Responsibility Principle (SRP)
/// 
/// Este cubit tiene una única responsabilidad: orquestar la carga de datos
/// de los cubits de autenticación (registro y login).
/// No carga datos directamente, solo coordina cuando los cubits deben cargar
/// sus propios datos, manteniendo una separación clara de responsabilidades.
class OrquestorAuthCubit extends Cubit<OrquestorAuthState> {
  final RegisterCubit _registerCubit;
  final LoginCubit _loginCubit;
  final AuthManager _authManager;

  StreamSubscription? _registerSubscription;
  StreamSubscription? _loginSubscription;

  OrquestorAuthCubit({
    required RegisterCubit registerCubit,
    required LoginCubit loginCubit,
    required AuthManager authManager,
  })  : _registerCubit = registerCubit,
        _loginCubit = loginCubit,
        _authManager = authManager,
        super(OrquestorAuthState.initial()) {
    _startListening();
  }

  void _startListening() {
    _registerSubscription = _registerCubit.stream.listen((registerState) {
      emit(state.copyWith(registerState: registerState));
    });

    _loginSubscription = _loginCubit.stream.listen((loginState) async {
      emit(state.copyWith(loginState: loginState));

      // Manejar efectos cuando el login es exitoso
      if (loginState.status == LoginStatus.success && loginState.responseEntity != null) {
        await _handleLoginSuccess(loginState.responseEntity!);
      }
    });
  }

  Future<void> _handleLoginSuccess(LoginResponseEntity response) async {
    // Guardar tokens en AuthManager
    await _authManager.login(
      response.accessToken,
      response.refreshToken,
      isCompleteData: response.isCompleteData,
    );

    // Emitir effect según el estado de datos completos
    if (response.isCompleteData) {
      emit(state.copyWith(effect: const NavigateToDashboardEffect()));
    } else {
      emit(state.copyWith(effect: const NavigateToValidationFromLoginEffect()));
    }
  }

  Future<void> validateComerce({
    required RegisterEntity entity,
  }) async {
    emit(state.copyWith(effect: const ValidateComerceEffect()));

    try {
      await _registerCubit.validateComerce(entity: entity);

      await Future.delayed(const Duration(milliseconds: 100));

      emit(state.copyWith(effect: null));
    } catch (e) {
      emit(state.copyWith(effect: null));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Reiniciar estado de login antes de iniciar
    _loginCubit.reset();
    
    // Llamar al login del cubit
    await _loginCubit.login(email: email, password: password);
  }

  /// Limpia el effect actual
  void clearEffect() {
    if (state.effect != null) {
      emit(state.copyWith(effect: null));
    }
  }

  /// Navega a la pantalla de éxito del documento
  void navigateToDocumentSuccess() {
    emit(state.copyWith(effect: const NavigateToDocumentSuccessEffect()));
  }

  /// Reinicia el estado de login
  void resetLoginState() {
    _loginCubit.reset();
    emit(state.copyWith(
      loginState: LoginState.initial(),
      effect: null,
    ));
  }

  /// Reinicia el estado de registro
  void resetRegisterState() {
    _registerCubit.reset();
    emit(state.copyWith(
      registerState: RegisterState.initial(),
      effect: null,
    ));
  }

  @override
  Future<void> close() {
    _registerSubscription?.cancel();
    _loginSubscription?.cancel();
    return super.close();
  }
}
