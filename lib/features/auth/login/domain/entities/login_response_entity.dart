import 'package:equatable/equatable.dart';
import 'package:partners/core/models/user_model.dart';

class LoginResponseEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const LoginResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}
