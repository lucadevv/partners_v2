import 'package:equatable/equatable.dart';
import 'package:partners/core/models/user_model.dart';

class LoginResponseEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final bool isCompleteData;
  final UserModel user; // Información del usuario con su rol

  const LoginResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.isCompleteData,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, isCompleteData, user];
}
