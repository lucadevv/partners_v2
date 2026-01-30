class StartRegisterResModel {
  final String? message;
  final String? sessionId;
  final String? nextStep;

  StartRegisterResModel({this.message, this.sessionId, this.nextStep});

  StartRegisterResModel copyWith({
    String? message,
    String? sessionId,
    String? nextStep,
  }) => StartRegisterResModel(
    message: message ?? this.message,
    sessionId: sessionId ?? this.sessionId,
    nextStep: nextStep ?? this.nextStep,
  );

  factory StartRegisterResModel.fromJson(Map<String, dynamic> json) =>
      StartRegisterResModel(
        message: json["message"],
        sessionId: json["session_id"],
        nextStep: json["next_step"],
      );
}
