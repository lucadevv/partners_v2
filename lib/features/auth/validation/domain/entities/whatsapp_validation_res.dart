class WhatsappValidationRes {
  final String message;
  final String debugOtp;

  WhatsappValidationRes({
    required this.message,
    required this.debugOtp,
  });

  WhatsappValidationRes copyWith({
    String? message,
    String? debugOtp,
  }) =>
      WhatsappValidationRes(
        message: message ?? this.message,
        debugOtp: debugOtp ?? this.debugOtp,
      );

  factory WhatsappValidationRes.fromJson(Map<String, dynamic> json) =>
      WhatsappValidationRes(
        message: json["message"] ?? '',
        debugOtp: json["debug_otp"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "debug_otp": debugOtp,
      };
}
