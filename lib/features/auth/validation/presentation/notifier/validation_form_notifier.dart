import 'package:flutter/material.dart';

/// Estados de validación para cada step
enum ValidationStep {
  email,
  whatsapp,
  password,
  document,
}

/// Estado de cada step individual
enum StepStatus {
  pending,
  active,
  completed,
}

/// ChangeNotifier para manejar el flujo de validación
class ValidationFormNotifier extends ChangeNotifier {
  ValidationStep _currentStep = ValidationStep.email;
  Map<ValidationStep, StepStatus> _stepStatuses = {
    ValidationStep.email: StepStatus.active,
    ValidationStep.whatsapp: StepStatus.pending,
    ValidationStep.password: StepStatus.pending,
    ValidationStep.document: StepStatus.pending,
  };

  bool _isCompleting = false;

  // Getters
  ValidationStep get currentStep => _currentStep;
  Map<ValidationStep, StepStatus> get stepStatuses => _stepStatuses;
  bool get isCompleting => _isCompleting;

  /// Verifica si un step está completado
  bool isStepCompleted(ValidationStep step) {
    return _stepStatuses[step] == StepStatus.completed;
  }

  /// Verifica si un step está activo
  bool isStepActive(ValidationStep step) {
    return _stepStatuses[step] == StepStatus.active;
  }

  /// Verifica si todos los steps están completados
  bool get allStepsCompleted {
    return _stepStatuses.values.every((status) => status == StepStatus.completed);
  }

  /// Completa el step actual y avanza al siguiente
  void completeCurrentStep() {
    _stepStatuses[_currentStep] = StepStatus.completed;

    // Determinar el siguiente step
    switch (_currentStep) {
      case ValidationStep.email:
        _currentStep = ValidationStep.whatsapp;
        _stepStatuses[ValidationStep.whatsapp] = StepStatus.active;
        break;
      case ValidationStep.whatsapp:
        _currentStep = ValidationStep.password;
        _stepStatuses[ValidationStep.password] = StepStatus.active;
        break;
      case ValidationStep.password:
        _currentStep = ValidationStep.document;
        _stepStatuses[ValidationStep.document] = StepStatus.active;
        break;
      case ValidationStep.document:
        // Último step completado
        _isCompleting = true;
        break;
    }

    notifyListeners();
  }

  /// Retrocede al step anterior
  void goToPreviousStep() {
    switch (_currentStep) {
      case ValidationStep.email:
        // Ya estamos en el primer step, no se puede retroceder más
        break;
      case ValidationStep.whatsapp:
        _stepStatuses[ValidationStep.whatsapp] = StepStatus.pending;
        _currentStep = ValidationStep.email;
        _stepStatuses[ValidationStep.email] = StepStatus.active;
        break;
      case ValidationStep.password:
        _stepStatuses[ValidationStep.password] = StepStatus.pending;
        _currentStep = ValidationStep.whatsapp;
        _stepStatuses[ValidationStep.whatsapp] = StepStatus.active;
        break;
      case ValidationStep.document:
        _stepStatuses[ValidationStep.document] = StepStatus.pending;
        _currentStep = ValidationStep.password;
        _stepStatuses[ValidationStep.password] = StepStatus.active;
        break;
    }

    notifyListeners();
  }

  /// Resetea todo el flujo de validación
  void reset() {
    _currentStep = ValidationStep.email;
    _stepStatuses = {
      ValidationStep.email: StepStatus.active,
      ValidationStep.whatsapp: StepStatus.pending,
      ValidationStep.password: StepStatus.pending,
      ValidationStep.document: StepStatus.pending,
    };
    _isCompleting = false;
    notifyListeners();
  }

  /// Obtiene el texto del step según su estado
  String getStepText(ValidationStep step, StepStatus status) {
    if (status == StepStatus.completed) {
      switch (step) {
        case ValidationStep.email:
          return 'Su email fue validado';
        case ValidationStep.whatsapp:
          return 'Su WhatsApp fue validado';
        case ValidationStep.password:
          return 'Su contraseña fue creada';
        case ValidationStep.document:
          return 'Su documento fue validado';
      }
    } else {
      switch (step) {
        case ValidationStep.email:
          return 'Validemos su email';
        case ValidationStep.whatsapp:
          return 'Validemos su WhatsApp';
        case ValidationStep.password:
          return 'Cree su contraseña';
        case ValidationStep.document:
          return 'Validemos su identidad';
      }
    }
  }
}
