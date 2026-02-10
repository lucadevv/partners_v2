import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/managers/auth/auth_manager.dart';
import 'package:partners/core/models/user_model.dart';
import 'package:partners/core/models/user_role.dart';
import 'package:partners/core/services/database/flags/flags_factory.dart';
import 'package:partners/core/services/database/flags/session_id_flug.dart';
import 'package:partners/core/services/role_service.dart';
import 'package:partners/core/utils/conts/prefers_keys.dart';
import 'package:partners/features/auth/validation/domain/use_case/complete_password_usecase.dart';
import 'package:partners/main.dart';

part 'password_validation_state.dart';

class PasswordValidationCubit extends Cubit<PasswordValidationState> {
  final CompletePasswordUsecase _completePasswordUsecase;
  final AuthManager _authManager;
  final RoleService _roleService;
  final SessionIdFlug _sessionFlug = FlagsFactory.createSessionIdFlug();

  PasswordValidationCubit({
    required CompletePasswordUsecase completePasswordUsecase,
    required AuthManager authManager,
  })  : _completePasswordUsecase = completePasswordUsecase,
        _authManager = authManager,
        _roleService = getIt<RoleService>(),
        super(PasswordValidationState.initial());

  Future<void> completePassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    if (state.status == PasswordValidationStatus.loading) return;
    
    final sessionId = _sessionFlug.getFlag(PrefersKeys.sessionId);
    if (sessionId == null || sessionId.isEmpty) {
      emit(
        state.copyWith(
          status: PasswordValidationStatus.failure,
          errorMessage: 'Session ID no encontrado',
        ),
      );
      return;
    }

    emit(state.copyWith(status: PasswordValidationStatus.loading));

    final response = await _completePasswordUsecase.call(
      sessionId: sessionId,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    if (isClosed) return;

    response.fold(
      (failure) {
        emit(
          state.copyWith(
            status: PasswordValidationStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (passwordRes) async {
        try {
          // Por defecto, al completar el registro, el usuario es dueño del negocio
          // Esto puede cambiar cuando el backend devuelva el rol real
          final defaultUser = UserModel(
            id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
            email: '', // Se actualizará cuando tengamos la info del usuario
            name: 'Usuario Registrado',
            role: UserRole.businessOwner, // Por defecto dueño del negocio
          );
          
          await _authManager.login(
            passwordRes.accessToken,
            passwordRes.refreshToken,
            isCompleteData: true,
            user: defaultUser,
          );
          
          // Establecer usuario y rol en RoleService
          _roleService.setUser(defaultUser);
          
          if (!isClosed) {
            emit(state.copyWith(status: PasswordValidationStatus.success));
          }
        } catch (e) {
          if (!isClosed) {
            emit(
              state.copyWith(
                status: PasswordValidationStatus.failure,
                errorMessage: 'Error al guardar tokens: $e',
              ),
            );
          }
        }
      },
    );
  }

  Future<void> resetState() async {
    emit(PasswordValidationState.initial());
  }
}
