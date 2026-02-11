// --- PRESENTACIÓN: CHANGE NOTIFIER ---
// Sigue el mismo patrón que RegisterFormNotifier

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:partners/features/issue_points/domain/domain.dart';

class IssuePointsFormNotifier extends ChangeNotifier {
  // Configuración del formulario (desde Domain)
  final IssuePointsFormConfig _config = IssuePointsConfigFactory.getConfig();

  // Controllers
  final TextEditingController voucherAmountController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Estados
  final String userName;
  String? _imagePath;

  // Errores
  String? _voucherAmountError;
  String? _pointsError;
  String? _descriptionError;

  // Debouncers
  Timer? _voucherAmountDebounce;
  Timer? _descriptionDebounce;

  IssuePointsFormNotifier({required this.userName}) {
    // Listener para calcular puntos automáticamente
    voucherAmountController.addListener(() {
      _calculatePoints();
      validateVoucherAmount(voucherAmountController.text);
    });

    descriptionController.addListener(() {
      validateDescription(descriptionController.text);
    });
  }

  // Getters de configuración (desde Domain)
  IssuePointsFieldDefinition get voucherAmountField => _config.voucherAmountField;
  IssuePointsFieldDefinition get pointsField => _config.pointsField;
  IssuePointsFieldDefinition get descriptionField => _config.descriptionField;
  IssuePointsFieldDefinition get userNameField => _config.userNameField;

  // Getters de estado
  String? get imagePath => _imagePath;
  String? get voucherAmountError => _voucherAmountError;
  String? get pointsError => _pointsError;
  String? get descriptionError => _descriptionError;

  // Getter para saber si el formulario está completo
  bool get isFormComplete {
    return voucherAmountController.text.isNotEmpty &&
           pointsController.text.isNotEmpty &&
           descriptionController.text.isNotEmpty &&
           _voucherAmountError == null &&
           _pointsError == null &&
           _descriptionError == null;
  }

  // Validación con debouncer
  void validateVoucherAmount(String value) {
    if (_voucherAmountDebounce?.isActive ?? false) {
      _voucherAmountDebounce!.cancel();
    }

    _voucherAmountDebounce = Timer(const Duration(milliseconds: 500), () {
      final validator = IssuePointsConfigFactory.getVoucherAmountValidator();
      if (!validator.validate(value)) {
        _voucherAmountError = validator.getErrorMessage();
        _pointsError = null;
        pointsController.clear();
      } else {
        _voucherAmountError = null;
      }
      notifyListeners();
    });
  }

  void validateDescription(String value) {
    if (_descriptionDebounce?.isActive ?? false) {
      _descriptionDebounce!.cancel();
    }

    _descriptionDebounce = Timer(const Duration(milliseconds: 500), () {
      final validator = IssuePointsConfigFactory.getDescriptionValidator();
      if (!validator.validate(value)) {
        _descriptionError = validator.getErrorMessage();
      } else {
        _descriptionError = null;
      }
      notifyListeners();
    });
  }

  // Calcular puntos basado en monto (1 punto = 1 sol)
  void _calculatePoints() {
    final amount = double.tryParse(voucherAmountController.text) ?? 0;
    if (amount > 0) {
      pointsController.text = amount.toStringAsFixed(0);
      // Validar puntos calculados
      final validator = IssuePointsConfigFactory.getPointsValidator();
      if (!validator.validate(pointsController.text)) {
        _pointsError = validator.getErrorMessage();
      } else {
        _pointsError = null;
      }
    } else {
      pointsController.clear();
      _pointsError = null;
    }
  }

  // Gestión de imagen
  void setImagePath(String? path) {
    _imagePath = path;
    notifyListeners();
  }

  void clearImage() {
    _imagePath = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _voucherAmountDebounce?.cancel();
    _descriptionDebounce?.cancel();
    voucherAmountController.dispose();
    pointsController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
