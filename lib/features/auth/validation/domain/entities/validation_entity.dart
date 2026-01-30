import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/utils/enums/enums.dart';

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
}
