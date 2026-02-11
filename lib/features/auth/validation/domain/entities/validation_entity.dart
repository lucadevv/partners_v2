import 'package:equatable/equatable.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/validation/domain/entities/steps_res_entity.dart';

abstract class ItemValidation extends Equatable {
  final String label;
  final String iconName; // Nombre del icono (Domain Layer - sin dependencia de Material)
  final ItemValidationState state;
  final String? nextStep;
  const ItemValidation({
    required this.label,
    required this.iconName,
    required this.state,
    this.nextStep,
  });

  ItemValidationState validation(bool isValid, String nextStep);
  ItemValidation copyWith({ItemValidationState? state});
  bool isValid(StepsResEntity stepsEntity);
  String get widgetType; // Tipo de widget para construir en Presentation

  @override
  List<Object?> get props => [label, iconName, state, nextStep];
}

class EmailItemValidation extends ItemValidation {
  const EmailItemValidation({super.state = ItemValidationState.initial})
    : super(
        label: 'Validemos su email',
        iconName: 'email',
        nextStep: 'email_verification',
      );

  @override
  ItemValidationState validation(bool isValid, String nextStep) {
    if (isValid) {
      return ItemValidationState.completed;
    } else {
      if (this.nextStep == nextStep) {
        return ItemValidationState.pending;
      } else {
        return ItemValidationState.initial;
      }
    }
  }

  @override
  EmailItemValidation copyWith({ItemValidationState? state}) {
    return EmailItemValidation(state: state ?? this.state);
  }

  @override
  String get widgetType => 'email';

  @override
  bool isValid(StepsResEntity stepsEntity) {
    return stepsEntity.completedSteps.emailVerification;
  }
}

class PhoneItemValidation extends ItemValidation {
  const PhoneItemValidation({super.state = ItemValidationState.initial})
    : super(
        label: 'Validemos su whatsapp',
        iconName: 'phone',
        nextStep: 'whatsapp_verification',
      );

  @override
  ItemValidationState validation(bool isValid, String nextStep) {
    if (isValid) {
      return ItemValidationState.completed;
    } else {
      if (this.nextStep == nextStep) {
        return ItemValidationState.pending;
      } else {
        return ItemValidationState.initial;
      }
    }
  }

  @override
  PhoneItemValidation copyWith({ItemValidationState? state}) {
    return PhoneItemValidation(state: state ?? this.state);
  }

  @override
  String get widgetType => 'whatsapp';

  @override
  bool isValid(StepsResEntity stepsEntity) {
    return stepsEntity.completedSteps.whatsappVerification;
  }
}

class PasswordItemValidation extends ItemValidation {
  const PasswordItemValidation({super.state = ItemValidationState.initial})
    : super(
        label: 'Cree una contraseña segura',
        iconName: 'lock',
        nextStep: 'password_creation',
      );

  @override
  ItemValidationState validation(bool isValid, String nextStep) {
    if (isValid) {
      return ItemValidationState.completed;
    } else {
      if (this.nextStep == nextStep) {
        return ItemValidationState.pending;
      } else {
        return ItemValidationState.initial;
      }
    }
  }

  @override
  PasswordItemValidation copyWith({ItemValidationState? state}) {
    return PasswordItemValidation(state: state ?? this.state);
  }

  @override
  String get widgetType => 'password';

  @override
  bool isValid(StepsResEntity stepsEntity) {
    return stepsEntity.completedSteps.passwordCreation;
  }
}

class BusinessItemValidation extends ItemValidation {
  const BusinessItemValidation({super.state = ItemValidationState.initial})
    : super(
        label: 'Validemos su negocio',
        iconName: 'business',
        nextStep: 'business_verification',
      );

  @override
  ItemValidationState validation(bool isValid, String nextStep) {
    if (isValid) {
      return ItemValidationState.completed;
    } else {
      if (this.nextStep == nextStep) {
        return ItemValidationState.pending;
      } else {
        return ItemValidationState.initial;
      }
    }
  }

  @override
  BusinessItemValidation copyWith({ItemValidationState? state}) {
    return BusinessItemValidation(state: state ?? this.state);
  }

  @override
  String get widgetType => 'business';

  @override
  bool isValid(StepsResEntity stepsEntity) {
    return stepsEntity.completedSteps.businessVerification;
  }
}

class IdentityItemValidation extends ItemValidation {
  const IdentityItemValidation({super.state = ItemValidationState.initial})
    : super(
        label: 'Validemos su identidad',
        iconName: 'badge',
        nextStep: 'identity_verification',
      );

  @override
  ItemValidationState validation(bool isValid, String nextStep) {
    if (isValid) {
      return ItemValidationState.completed;
    } else {
      if (this.nextStep == nextStep) {
        return ItemValidationState.pending;
      } else {
        return ItemValidationState.initial;
      }
    }
  }

  @override
  IdentityItemValidation copyWith({ItemValidationState? state}) {
    return IdentityItemValidation(state: state ?? this.state);
  }

  @override
  String get widgetType => 'identity';

  @override
  bool isValid(StepsResEntity stepsEntity) {
    return stepsEntity.completedSteps.identityVerification;
  }
}
