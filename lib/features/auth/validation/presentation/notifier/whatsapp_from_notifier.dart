import 'package:flutter/material.dart';
import 'package:partners/features/auth/register/domain/forms/form_config.dart';
import 'package:partners/features/auth/validation/domain/factories/whatsapp_factory.dart';
import 'package:partners/features/auth/validation/domain/validators/validator.dart';
import 'package:partners/features/auth/validation/presentation/cubit/whatsapp/whatsapp_validation_cubit.dart';

enum WhatsappSteps { phone, verification }

class WhatsappFromNotifier extends ChangeNotifier {
  final WhatsappValidationCubit cubit;
  String? _phoneError;
  WhatsappSteps _currentStep = WhatsappSteps.phone;
  List<FieldDefinition> get whatsappFactory =>
      WhatsappFactory.getConfig(_currentStep);

  late final TextEditingController _phoneController;
  TextEditingController get phoneController => _phoneController;

  late final List<TextEditingController> _otpControllers;
  List<TextEditingController> get otpControllers => _otpControllers;

  WhatsappFromNotifier({required this.cubit}) {
    _phoneController = TextEditingController();

    _otpControllers = List.generate(5, (index) {
      final controller = TextEditingController();

      controller.addListener(() {
        notifyListeners();
      });
      return controller;
    });

    _phoneController.addListener(() {
      setPhone(_phoneController.text);
    });
  }

  int get otpLength => _otpControllers.length;
  String? get phoneError => _phoneError;
  WhatsappSteps get currentStep => _currentStep;
  String? get phone => _phoneController.text;

  bool get isFormComplete {
    if (_currentStep == WhatsappSteps.phone) {
      return _phoneError == null &&
          whatsappFactory.isNotEmpty &&
          _phoneController.text.isNotEmpty;
    } else if (_currentStep == WhatsappSteps.verification) {
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
    if (_currentStep == WhatsappSteps.phone) {
      _phoneError = null;

      _currentStep = WhatsappSteps.verification;
      notifyListeners();
    }
  }

  void setPhone(String value) {
    PhoneValidatorStrategy validator = PhoneValidatorStrategy();
    if (!validator.validate(value)) {
      _phoneError = validator.getErrorMessage();
    } else {
      _phoneError = null;
    }
    notifyListeners();
  }

  void initNotifier() {
    _phoneError = null;
    _phoneController.clear();
    _currentStep = WhatsappSteps.phone;
    for (var controller in _otpControllers) {
      controller.clear();
    }
    cubit.initialState();
    notifyListeners();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
