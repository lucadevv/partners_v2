import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/features/auth/register/domain/entities/register_entity.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';

part 'orquestor_auth_state.dart';

/// SOLID: Single Responsibility Principle (SRP)
/// 
/// Este cubit tiene una única responsabilidad: orquestar la carga de datos
/// del cubit de registro.
/// No carga datos directamente, solo coordina cuando el cubit debe cargar
/// sus propios datos, manteniendo una separación clara de responsabilidades.
class OrquestorAuthCubit extends Cubit<OrquestorAuthState> {
  final RegisterCubit _registerCubit;

  StreamSubscription? _registerSubscription;

  OrquestorAuthCubit({
    required RegisterCubit registerCubit,
  }) : _registerCubit = registerCubit,
       super(OrquestorAuthState.initial()) {
    _startListening();
  }

  void _startListening() {
    _registerSubscription = _registerCubit.stream.listen((
      registerState,
    ) {
      emit(state.copyWith(registerState: registerState));
    });
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

  /// Limpia el effect actual
  void clearEffect() {
    if (state.effect != null) {
      emit(state.copyWith(effect: null));
    }
  }

  @override
  Future<void> close() {
    _registerSubscription?.cancel();
    return super.close();
  }
}
