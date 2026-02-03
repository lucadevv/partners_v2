import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/validation/domain/entities/steps_res_entity.dart';
import 'package:partners/features/auth/validation/presentation/widgets/business_validation_widget.dart';
import 'package:partners/features/auth/validation/presentation/widgets/email_validation_widget.dart';
import 'package:partners/features/auth/validation/presentation/widgets/password_validation_widget.dart';
import 'package:partners/features/auth/validation/presentation/widgets/whatsapp_validation_widget.dart';

abstract class ItemValidation extends Equatable {
  final String label;
  final IconData icon;
  final ItemValidationState state;
  final String? nextStep;
  const ItemValidation({
    required this.label,
    required this.icon,
    required this.state,
    this.nextStep,
  });

  ItemValidationState validation(bool isValid, String nextStep);
  ItemValidation copyWith({ItemValidationState? state});
  Widget buildWidget();
  bool isValid(StepsResEntity stepsEntity);

  @override
  List<Object?> get props => [label, icon, state, nextStep];
}

class EmailItemValidation extends ItemValidation {
  const EmailItemValidation({super.state = ItemValidationState.initial})
    : super(
        label: 'Validemos su email',
        icon: Icons.email,
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
  Widget buildWidget() => const EmailValidationWidget();

  @override
  bool isValid(StepsResEntity stepsEntity) {
    return stepsEntity.completedSteps.emailVerification;
  }
}

class PhoneItemValidation extends ItemValidation {
  const PhoneItemValidation({super.state = ItemValidationState.initial})
    : super(
        label: 'Validemos su whatsapp',
        icon: Icons.phone,
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
  Widget buildWidget() => const WhatsappValidationWidget();

  @override
  bool isValid(StepsResEntity stepsEntity) {
    return stepsEntity.completedSteps.whatsappVerification;
  }
}

class PasswordItemValidation extends ItemValidation {
  const PasswordItemValidation({super.state = ItemValidationState.initial})
    : super(
        label: 'Cree una contraseña segura',
        icon: Icons.lock,
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
  Widget buildWidget() => const PasswordValidationWidget();

  @override
  bool isValid(StepsResEntity stepsEntity) {
    return stepsEntity.completedSteps.passwordCreation;
  }
}

class BusinessItemValidation extends ItemValidation {
  const BusinessItemValidation({super.state = ItemValidationState.initial})
    : super(
        label: 'Validemos su negocio',
        icon: Icons.business,

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
  Widget buildWidget() => const BusinessValidationWidget();

  @override
  bool isValid(StepsResEntity stepsEntity) {
    return stepsEntity.completedSteps.businessVerification;
  }
}

class IdentityItemValidation extends ItemValidation {
  const IdentityItemValidation({super.state = ItemValidationState.initial})
    : super(
        label: 'Validemos su identidad',
        icon: Icons.badge,

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
  Widget buildWidget() => const SizedBox.shrink();

  @override
  bool isValid(StepsResEntity stepsEntity) {
    return stepsEntity.completedSteps.identityVerification;
  }
}
