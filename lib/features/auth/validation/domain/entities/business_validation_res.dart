class BusinessValidationRes {
  final String message;
  final String nextStep;

  BusinessValidationRes({
    required this.message,
    required this.nextStep,
  });

  BusinessValidationRes copyWith({
    String? message,
    String? nextStep,
  }) =>
      BusinessValidationRes(
        message: message ?? this.message,
        nextStep: nextStep ?? this.nextStep,
      );

  factory BusinessValidationRes.fromJson(Map<String, dynamic> json) =>
      BusinessValidationRes(
        message: json["message"] ?? '',
        nextStep: json["next_step"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "next_step": nextStep,
      };
}
