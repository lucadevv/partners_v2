import 'package:equatable/equatable.dart';

class StartRegisterResEntity extends Equatable {
  final String message;
  final String sessionId;
  final String nextStep;

  const StartRegisterResEntity({
    required this.message,
    required this.sessionId,
    required this.nextStep,
  });

  StartRegisterResEntity copyWith({
    String? message,
    String? sessionId,
    String? nextStep,
  }) => StartRegisterResEntity(
    message: message ?? this.message,
    sessionId: sessionId ?? this.sessionId,
    nextStep: nextStep ?? this.nextStep,
  );

  factory StartRegisterResEntity.empty() =>
      StartRegisterResEntity(message: '', sessionId: '', nextStep: '');

  @override
  List<Object?> get props => [message, sessionId, nextStep];
}
