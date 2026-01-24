import 'package:flutter/material.dart';

/// Estados de validación para cada step de negocio
enum BusinessValidationStep {
  email,
  whatsapp,
  business,
  identity,
  password,
}

/// Estado de cada step individual
enum BusinessStepStatus {
  pending,
  active,
  completed,
}

/// ChangeNotifier para manejar el flujo de validación de negocio
class BusinessValidationFormNotifier extends ChangeNotifier {
  BusinessValidationStep _currentStep = BusinessValidationStep.email;
  Map<BusinessValidationStep, BusinessStepStatus> _stepStatuses = {
    BusinessValidationStep.email: BusinessStepStatus.active,
    BusinessValidationStep.whatsapp: BusinessStepStatus.pending,
    BusinessValidationStep.business: BusinessStepStatus.pending,
    BusinessValidationStep.identity: BusinessStepStatus.pending,
    BusinessValidationStep.password: BusinessStepStatus.pending,
  };

  bool _isCompleting = false;

  // Getters
  BusinessValidationStep get currentStep => _currentStep;
  Map<BusinessValidationStep, BusinessStepStatus> get stepStatuses => _stepStatuses;
  bool get isCompleting => _isCompleting;

  /// Verifica si un step está completado
  bool isStepCompleted(BusinessValidationStep step) {
    return _stepStatuses[step] == BusinessStepStatus.completed;
  }

  /// Verifica si un step está activo
  bool isStepActive(BusinessValidationStep step) {
    return _stepStatuses[step] == BusinessStepStatus.active;
  }

  /// Verifica si todos los steps están completados
  bool get allStepsCompleted {
    return _stepStatuses.values.every((status) => status == BusinessStepStatus.completed);
  }

  /// Completa el step actual y avanza al siguiente
  void completeCurrentStep() {
    _stepStatuses[_currentStep] = BusinessStepStatus.completed;

    // Determinar el siguiente step
    switch (_currentStep) {
      case BusinessValidationStep.email:
        _currentStep = BusinessValidationStep.whatsapp;
        _stepStatuses[BusinessValidationStep.whatsapp] = BusinessStepStatus.active;
        break;
      case BusinessValidationStep.whatsapp:
        _currentStep = BusinessValidationStep.business;
        _stepStatuses[BusinessValidationStep.business] = BusinessStepStatus.active;
        break;
      case BusinessValidationStep.business:
        _currentStep = BusinessValidationStep.identity;
        _stepStatuses[BusinessValidationStep.identity] = BusinessStepStatus.active;
        break;
      case BusinessValidationStep.identity:
        _currentStep = BusinessValidationStep.password;
        _stepStatuses[BusinessValidationStep.password] = BusinessStepStatus.active;
        break;
      case BusinessValidationStep.password:
        // Último step completado
        _isCompleting = true;
        break;
    }

    notifyListeners();
  }

  /// Retrocede al step anterior
  void goToPreviousStep() {
    switch (_currentStep) {
      case BusinessValidationStep.email:
        // Ya estamos en el primer step, no se puede retroceder más
        break;
      case BusinessValidationStep.whatsapp:
        _stepStatuses[BusinessValidationStep.whatsapp] = BusinessStepStatus.pending;
        _currentStep = BusinessValidationStep.email;
        _stepStatuses[BusinessValidationStep.email] = BusinessStepStatus.active;
        break;
      case BusinessValidationStep.business:
        _stepStatuses[BusinessValidationStep.business] = BusinessStepStatus.pending;
        _currentStep = BusinessValidationStep.whatsapp;
        _stepStatuses[BusinessValidationStep.whatsapp] = BusinessStepStatus.active;
        break;
      case BusinessValidationStep.identity:
        _stepStatuses[BusinessValidationStep.identity] = BusinessStepStatus.pending;
        _currentStep = BusinessValidationStep.business;
        _stepStatuses[BusinessValidationStep.business] = BusinessStepStatus.active;
        break;
      case BusinessValidationStep.password:
        _stepStatuses[BusinessValidationStep.password] = BusinessStepStatus.pending;
        _currentStep = BusinessValidationStep.identity;
        _stepStatuses[BusinessValidationStep.identity] = BusinessStepStatus.active;
        break;
    }

    notifyListeners();
  }

  /// Resetea todo el flujo de validación
  void reset() {
    _currentStep = BusinessValidationStep.email;
    _stepStatuses = {
      BusinessValidationStep.email: BusinessStepStatus.active,
      BusinessValidationStep.whatsapp: BusinessStepStatus.pending,
      BusinessValidationStep.business: BusinessStepStatus.pending,
      BusinessValidationStep.identity: BusinessStepStatus.pending,
      BusinessValidationStep.password: BusinessStepStatus.pending,
    };
    _isCompleting = false;
    notifyListeners();
  }

  /// Obtiene el texto del step según su estado
  String getStepText(BusinessValidationStep step, BusinessStepStatus status) {
    if (status == BusinessStepStatus.completed) {
      switch (step) {
        case BusinessValidationStep.email:
          return 'Su email fue validado';
        case BusinessValidationStep.whatsapp:
          return 'Su WhatsApp fue validado';
        case BusinessValidationStep.business:
          return 'Su negocio fue validado';
        case BusinessValidationStep.identity:
          return 'Su identidad fue validada';
        case BusinessValidationStep.password:
          return 'Su contraseña fue creada';
      }
    } else {
      switch (step) {
        case BusinessValidationStep.email:
          return 'Validemos su email';
        case BusinessValidationStep.whatsapp:
          return 'Validemos su WhatsApp';
        case BusinessValidationStep.business:
          return 'Validemos su negocio';
        case BusinessValidationStep.identity:
          return 'Validemos su identidad';
        case BusinessValidationStep.password:
          return 'Cree una contraseña segura';
      }
    }
  }
}
