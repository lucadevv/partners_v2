class StepsResModel {
  final String? nextStep;
  final CompletedStepsModel? completedSteps;

  StepsResModel({this.nextStep, this.completedSteps});

  StepsResModel copyWith({
    String? nextStep,
    CompletedStepsModel? completedSteps,
  }) => StepsResModel(
    nextStep: nextStep ?? this.nextStep,
    completedSteps: completedSteps ?? this.completedSteps,
  );

  factory StepsResModel.fromJson(Map<String, dynamic> json) => StepsResModel(
    nextStep: json["next_step"],
    completedSteps: json["completed_steps"] == null
        ? null
        : CompletedStepsModel.fromJson(json["completed_steps"]),
  );

  Map<String, dynamic> toJson() => {
    "next_step": nextStep,
    "completed_steps": completedSteps?.toJson(),
  };
}

class CompletedStepsModel {
  final bool? lookupRuc;
  final bool? lookupDocument;
  final bool? start;
  final bool? emailVerification;
  final bool? whatsappVerification;
  final bool? businessVerification;
  final bool? identityVerification;
  final bool? passwordCreation;

  CompletedStepsModel({
    this.lookupRuc,
    this.lookupDocument,
    this.start,
    this.emailVerification,
    this.whatsappVerification,
    this.businessVerification,
    this.identityVerification,
    this.passwordCreation,
  });

  CompletedStepsModel copyWith({
    bool? lookupRuc,
    bool? lookupDocument,
    bool? start,
    bool? emailVerification,
    bool? whatsappVerification,
    bool? businessVerification,
    bool? identityVerification,
    bool? passwordCreation,
  }) => CompletedStepsModel(
    lookupRuc: lookupRuc ?? this.lookupRuc,
    lookupDocument: lookupDocument ?? this.lookupDocument,
    start: start ?? this.start,
    emailVerification: emailVerification ?? this.emailVerification,
    whatsappVerification: whatsappVerification ?? this.whatsappVerification,
    businessVerification: businessVerification ?? this.businessVerification,
    identityVerification: identityVerification ?? this.identityVerification,
    passwordCreation: passwordCreation ?? this.passwordCreation,
  );

  factory CompletedStepsModel.fromJson(Map<String, dynamic> json) =>
      CompletedStepsModel(
        lookupRuc: json["lookup_ruc"],
        lookupDocument: json["lookup_document"],
        start: json["start"],
        emailVerification: json["email_verification"],
        whatsappVerification: json["whatsapp_verification"],
        businessVerification: json["business_verification"],
        identityVerification: json["identity_verification"],
        passwordCreation: json["password_creation"],
      );

  Map<String, dynamic> toJson() => {
    "lookup_ruc": lookupRuc,
    "lookup_document": lookupDocument,
    "start": start,
    "email_verification": emailVerification,
    "whatsapp_verification": whatsappVerification,
    "business_verification": businessVerification,
    "identity_verification": identityVerification,
    "password_creation": passwordCreation,
  };
}
