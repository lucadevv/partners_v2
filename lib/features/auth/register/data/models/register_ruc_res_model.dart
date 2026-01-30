class RegisterRucResModel {
  final bool? success;
  final bool? isExists;
  final String? sessionId;
  final Data? data;

  RegisterRucResModel({this.success, this.isExists, this.sessionId, this.data});

  RegisterRucResModel copyWith({
    bool? success,
    bool? isExists,
    String? sessionId,
    Data? data,
  }) => RegisterRucResModel(
    success: success ?? this.success,
    isExists: isExists ?? this.isExists,
    sessionId: sessionId ?? this.sessionId,
    data: data ?? this.data,
  );

  factory RegisterRucResModel.fromJson(Map<String, dynamic> json) =>
      RegisterRucResModel(
        success: json["success"],
        isExists: json["is_exists"],
        sessionId: json["session_id"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "is_exists": isExists,
    "session_id": sessionId,
    "data": data?.toJson(),
  };
}

class Data {
  final String? ruc;
  final String? socialReason;

  Data({this.ruc, this.socialReason});

  Data copyWith({String? ruc, String? socialReason}) => Data(
    ruc: ruc ?? this.ruc,
    socialReason: socialReason ?? this.socialReason,
  );

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(ruc: json["ruc"], socialReason: json["social_reason"]);

  Map<String, dynamic> toJson() => {"ruc": ruc, "social_reason": socialReason};
}
