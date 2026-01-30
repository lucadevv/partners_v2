import 'package:flutter/material.dart';
import 'package:partners/features/auth/register/domain/forms/form_config.dart';
import 'package:partners/features/auth/validation/domain/factories/email_factory.dart';
import 'package:partners/features/auth/validation/domain/validators/validator.dart';
import 'package:partners/features/auth/validation/presentation/cubit/email/email_validation_cubit.dart';

enum EmailSteps { email, verification }

class EmailFromNotifier extends ChangeNotifier {
  final EmailValidationCubit cubit;
  String? _emailError;
  EmailSteps _currentStep = EmailSteps.email;
  List<FieldDefinition> get emailFactory =>
      EmailFactory.getConfig(_currentStep);

  late final TextEditingController _emailController;
  TextEditingController get emailController => _emailController;

  late final List<TextEditingController> _otpControllers;
  List<TextEditingController> get otpControllers => _otpControllers;

  EmailFromNotifier({required this.cubit}) {
    _emailController = TextEditingController();

    _otpControllers = List.generate(5, (index) {
      final controller = TextEditingController();

      controller.addListener(() {
        notifyListeners();
      });
      return controller;
    });

    _emailController.addListener(() {
      setEmail(_emailController.text);
    });
  }

  int get otpLength => _otpControllers.length;
  String? get emailError => _emailError;
  EmailSteps get currentStep => _currentStep;
  String? get email => _emailController.text;

  bool get isFormComplete {
    if (_currentStep == EmailSteps.email) {
      return _emailError == null &&
          emailFactory.isNotEmpty &&
          _emailController.text.isNotEmpty;
    } else if (_currentStep == EmailSteps.verification) {
      for (var controller in _otpControllers) {
        if (controller.text.isEmpty) {
          return false;
        }
      }
      return true;
    }

    return false;
  }

  void goToNextStep() {
    if (_currentStep == EmailSteps.email) {
      _emailError = null;

      _currentStep = EmailSteps.verification;
      notifyListeners();
    }
  }

  void setEmail(String value) {
    EmailValidatorStrategy validator = EmailValidatorStrategy();
    if (!validator.validate(value)) {
      _emailError = validator.getErrorMessage();
    } else {
      _emailError = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _emailController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
