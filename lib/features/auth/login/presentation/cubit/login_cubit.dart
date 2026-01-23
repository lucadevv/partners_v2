import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:partners/core/cubit/base_cubit_mixin.dart';
import 'package:partners/features/auth/login/domain/entities/login_entity.dart';
import 'package:partners/features/auth/login/domain/entities/login_response_entity.dart';
import 'package:partners/features/auth/login/domain/use_case/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> with BaseCubitMixin {
  final LoginUsecase _loginUsecase;

  LoginCubit({
    required LoginUsecase loginUsecase,
  })  : _loginUsecase = loginUsecase,
        super(const LoginState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (state.status == LoginStatus.loading) {
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    final entity = LoginEntity(
      email: email,
      password: password,
    );

    final response = await _loginUsecase.login(entity);

    response.fold(
      (failure) {
        String errorMessage = getErrorMessage(failure);
        emit(
          state.copyWith(
            status: LoginStatus.failure,
            errorMessage: errorMessage,
          ),
        );
      },
      (responseEntity) {
        emit(
          state.copyWith(
            status: LoginStatus.success,
            responseEntity: responseEntity,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void reset() {
    emit(const LoginState());
  }
}
