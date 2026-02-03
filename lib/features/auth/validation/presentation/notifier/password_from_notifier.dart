import 'package:flutter/material.dart';
import 'package:partners/features/auth/register/domain/forms/form_config.dart';
import 'package:partners/features/auth/validation/domain/factories/password_factory.dart';
import 'package:partners/features/auth/validation/domain/validators/password_validator.dart';
import 'package:partners/features/auth/validation/presentation/cubit/password/password_validation_cubit.dart';

enum PasswordSteps { createPassword, confirmPassword }

class PasswordFromNotifier extends ChangeNotifier {
  final PasswordValidationCubit cubit;
  String? _passwordError;
  String? _passwordConfirmationError;
  PasswordSteps _currentStep = PasswordSteps.createPassword;
  List<FieldDefinition> get passwordFactory =>
      PasswordFactory.getConfig(_currentStep);

  late final TextEditingController _passwordController;
  TextEditingController get passwordController => _passwordController;

  late final TextEditingController _passwordConfirmationController;
  TextEditingController get passwordConfirmationController =>
      _passwordConfirmationController;

  PasswordFromNotifier({required this.cubit}) {
    _passwordController = TextEditingController();
    _passwordConfirmationController = TextEditingController();

    _passwordController.addListener(() {
      setPassword(_passwordController.text);
    });

    _passwordConfirmationController.addListener(() {
      setPasswordConfirmation(_passwordConfirmationController.text);
    });
  }

  PasswordSteps get currentStep => _currentStep;
  String? get passwordError => _passwordError;
  String? get passwordConfirmationError => _passwordConfirmationError;
  String? get password => _passwordController.text;
  String? get passwordConfirmation => _passwordConfirmationController.text;

  bool get isFormComplete {
    if (_currentStep == PasswordSteps.createPassword) {
      return _passwordError == null &&
          passwordFactory.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    } else if (_currentStep == PasswordSteps.confirmPassword) {
      return _passwordError == null &&
          _passwordConfirmationError == null &&
          _passwordController.text.isNotEmpty &&
          _passwordConfirmationController.text.isNotEmpty;
    }

    return false;
  }

  void goToNextStep() {
    if (_currentStep == PasswordSteps.createPassword) {
      _passwordError = null;
      _currentStep = PasswordSteps.confirmPassword;
      notifyListeners();
    }
  }

  void setPassword(String value) {
    PasswordValidatorStrategy validator = PasswordValidatorStrategy();
    if (!validator.validate(value)) {
      _passwordError = validator.getErrorMessage();
    } else {
      _passwordError = null;
      if (_currentStep == PasswordSteps.confirmPassword &&
          _passwordConfirmationController.text.isNotEmpty) {
        setPasswordConfirmation(_passwordConfirmationController.text);
      }
    }
    notifyListeners();
  }

  void setPasswordConfirmation(String value) {
    if (value.isEmpty) {
      _passwordConfirmationError = null;
    } else if (value != _passwordController.text) {
      _passwordConfirmationError = "Las contraseñas no coinciden";
    } else {
      _passwordConfirmationError = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }
}
