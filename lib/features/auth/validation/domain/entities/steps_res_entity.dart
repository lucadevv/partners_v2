class StepsResEntity {
  final String nextStep;
  final CompletedStepsEntity completedSteps;

  StepsResEntity({required this.nextStep, required this.completedSteps});

  factory StepsResEntity.empty() => StepsResEntity(
    nextStep: '',
    completedSteps: CompletedStepsEntity.empty(),
  );

  StepsResEntity copyWith({
    String? nextStep,
    CompletedStepsEntity? completedSteps,
  }) {
    return StepsResEntity(
      nextStep: nextStep ?? this.nextStep,
      completedSteps: completedSteps ?? this.completedSteps,
    );
  }

  Map<String, dynamic> toJson() => {
    "next_step": nextStep,
    "completed_steps": completedSteps.toJson(),
  };
}

class CompletedStepsEntity {
  final bool emailVerification;
  final bool whatsappVerification;
  final bool businessVerification;
  final bool identityVerification;
  final bool passwordCreation;

  CompletedStepsEntity({
    required this.emailVerification,
    required this.whatsappVerification,
    required this.businessVerification,
    required this.identityVerification,
    required this.passwordCreation,
  });

  CompletedStepsEntity copyWith({
    bool? emailVerification,
    bool? whatsappVerification,
    bool? businessVerification,
    bool? identityVerification,
    bool? passwordCreation,
  }) {
    return CompletedStepsEntity(
      emailVerification: emailVerification ?? this.emailVerification,
      whatsappVerification: whatsappVerification ?? this.whatsappVerification,
      businessVerification: businessVerification ?? this.businessVerification,
      identityVerification: identityVerification ?? this.identityVerification,
      passwordCreation: passwordCreation ?? this.passwordCreation,
    );
  }

  factory CompletedStepsEntity.empty() => CompletedStepsEntity(
    emailVerification: false,
    whatsappVerification: false,
    businessVerification: false,
    identityVerification: false,
    passwordCreation: false,
  );

  Map<String, dynamic> toJson() => {
    "email_verification": emailVerification,
    "whatsapp_verification": whatsappVerification,
    "business_verification": businessVerification,
    "identity_verification": identityVerification,
    "password_creation": passwordCreation,
  };
}
