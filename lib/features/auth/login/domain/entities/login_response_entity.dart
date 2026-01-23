import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final bool isCompleteData;

  const LoginResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.isCompleteData,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, isCompleteData];
}
