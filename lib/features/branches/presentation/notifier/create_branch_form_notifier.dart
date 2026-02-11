// --- PRESENTACIÓN: CHANGE NOTIFIER ---
// Sigue el mismo patrón que RegisterFormNotifier

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:partners/features/branches/domain/domain.dart';

class CreateBranchFormNotifier extends ChangeNotifier {
  // Configuración del formulario (desde Domain)
  final BranchFormConfig _config = BranchConfigFactory.getConfig();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Estados
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedSchedule;
  String? _imagePath;

  // Errores
  String? _nameError;
  String? _phoneError;
  String? _addressError;

  // Debouncers
  Timer? _nameDebounce;
  Timer? _phoneDebounce;
  Timer? _addressDebounce;

  CreateBranchFormNotifier() {
    // Listeners para validación automática
    nameController.addListener(() {
      validateName(nameController.text);
    });

    phoneController.addListener(() {
      validatePhone(phoneController.text);
    });

    addressController.addListener(() {
      validateAddress(addressController.text);
    });
  }

  // Getters de configuración (desde Domain)
  BranchFieldDefinition get nameField => _config.nameField;
  BranchFieldDefinition get phoneField => _config.phoneField;
  BranchFieldDefinition get addressField => _config.addressField;

  // Getters de estado
  String? get selectedCategory => _selectedCategory;
  String? get selectedSubCategory => _selectedSubCategory;
  String? get selectedSchedule => _selectedSchedule;
  String? get imagePath => _imagePath;
  String? get nameError => _nameError;
  String? get phoneError => _phoneError;
  String? get addressError => _addressError;

  // Getter para saber si el formulario está completo
  bool get isFormComplete {
    return nameController.text.isNotEmpty &&
           phoneController.text.isNotEmpty &&
           addressController.text.isNotEmpty &&
           _selectedCategory != null &&
           _selectedSubCategory != null &&
           _selectedSchedule != null &&
           _nameError == null &&
           _phoneError == null &&
           _addressError == null;
  }

  // Validación con debouncer. Si el campo está vacío, se quita el error.
  void validateName(String value) {
    if (_nameDebounce?.isActive ?? false) {
      _nameDebounce!.cancel();
    }

    if (value.trim().isEmpty) {
      _nameError = null;
      notifyListeners();
      return;
    }

    _nameDebounce = Timer(const Duration(milliseconds: 500), () {
      final validator = BranchConfigFactory.getNameValidator();
      if (!validator.validate(value)) {
        _nameError = validator.getErrorMessage();
      } else {
        _nameError = null;
      }
      notifyListeners();
    });
  }

  void validatePhone(String value) {
    if (_phoneDebounce?.isActive ?? false) {
      _phoneDebounce!.cancel();
    }

    if (value.trim().isEmpty) {
      _phoneError = null;
      notifyListeners();
      return;
    }

    _phoneDebounce = Timer(const Duration(milliseconds: 500), () {
      final validator = BranchConfigFactory.getPhoneValidator();
      if (!validator.validate(value)) {
        _phoneError = validator.getErrorMessage();
      } else {
        _phoneError = null;
      }
      notifyListeners();
    });
  }

  void validateAddress(String value) {
    if (_addressDebounce?.isActive ?? false) {
      _addressDebounce!.cancel();
    }

    if (value.trim().isEmpty) {
      _addressError = null;
      notifyListeners();
      return;
    }

    _addressDebounce = Timer(const Duration(milliseconds: 500), () {
      final validator = BranchConfigFactory.getAddressValidator();
      if (!validator.validate(value)) {
        _addressError = validator.getErrorMessage();
      } else {
        _addressError = null;
      }
      notifyListeners();
    });
  }

  // Setters para selecciones
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSubCategory(String? subCategory) {
    _selectedSubCategory = subCategory;
    notifyListeners();
  }

  void setSchedule(String? schedule) {
    _selectedSchedule = schedule;
    notifyListeners();
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
    _nameDebounce?.cancel();
    _phoneDebounce?.cancel();
    _addressDebounce?.cancel();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
