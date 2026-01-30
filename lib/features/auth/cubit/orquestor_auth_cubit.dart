import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/login/presentation/cubit/login_cubit.dart';

import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_state.dart';

part 'orquestor_auth_state.dart';

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
  }) : _registerCubit = registerCubit,
       _loginCubit = loginCubit,
       _authManager = authManager,
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
      }
    });
  }

  Future<void> navigationStartValidationPage(RucType type) async {
    await _registerCubit.submitStart(type).then((_) {
      final registerState = _registerCubit.state;
      if (registerState.sendStartStatus == RegisterStatus.success) {
        if (type == RucType.ruc20) {
          emit(state.copyWith(effect: const NavigationBussinesEffect()));
        } else {
          emit(state.copyWith(effect: const NavigationValidateEffect()));
        }
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
