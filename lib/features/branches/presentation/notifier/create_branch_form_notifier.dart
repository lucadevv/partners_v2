// --- PRESENTACIÓN: CHANGE NOTIFIER ---
// Sigue el mismo patrón que RegisterFormNotifier

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:partners/features/branches/domain/domain.dart';

class CreateBranchFormNotifier extends ChangeNotifier {
  // Configuración del formulario (desde Domain)
  final BranchFormConfig _config = BranchConfigFactory.getConfig();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Estados (categoría/subcategoría desde backend)
  CategoryEntity? _selectedCategory;
  SubcategoryEntity? _selectedSubCategory;
  String? _selectedSchedule;
  String? _imagePath;

  // Ubicación (mapa)
  double? _latitude;
  double? _longitude;

  // Horario estructurado para API (días UI: Lunes, Martes...; start/end ej. 09:00)
  List<String> _scheduleDays = const [];
  String? _scheduleStartTime;
  String? _scheduleEndTime;

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

  // Getters de estado (nombre para mostrar en UI; entidad para subcategorías e ID)
  String? get selectedCategory => _selectedCategory?.name;
  String? get selectedSubCategory => _selectedSubCategory?.name;
  CategoryEntity? get selectedCategoryEntity => _selectedCategory;
  SubcategoryEntity? get selectedSubcategoryEntity => _selectedSubCategory;
  /// Subcategorías para la categoría seleccionada. Vacío si el backend no las envía (ej. /options/categories solo devuelve id/name).
  List<SubcategoryEntity> get subcategoriesForSelectedCategory =>
      const <SubcategoryEntity>[];
  String? get selectedSchedule => _selectedSchedule;
  String? get imagePath => _imagePath;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  List<String> get scheduleDays => List.unmodifiable(_scheduleDays);
  String? get scheduleStartTime => _scheduleStartTime;
  String? get scheduleEndTime => _scheduleEndTime;
  String? get nameError => _nameError;
  String? get phoneError => _phoneError;
  String? get addressError => _addressError;

  /// Indica si hay horario configurado (días + inicio/fin) para enviar al backend.
  bool get hasScheduleData =>
      _scheduleDays.isNotEmpty &&
      _scheduleStartTime != null &&
      _scheduleStartTime!.isNotEmpty &&
      _scheduleEndTime != null &&
      _scheduleEndTime!.isNotEmpty;

  /// Imagen de banner seleccionada (obligatoria para enviar).
  bool get hasValidImage =>
      _imagePath != null &&
      _imagePath!.isNotEmpty &&
      _imagePath != 'placeholder';

  // Getter para saber si el formulario está completo y sin errores
  bool get isFormComplete {
    final hasSubcategories = subcategoriesForSelectedCategory.isNotEmpty;
    return nameController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty &&
        _selectedCategory != null &&
        (!hasSubcategories || _selectedSubCategory != null) &&
        _selectedSchedule != null &&
        hasScheduleData &&
        hasValidImage &&
        _latitude != null &&
        _longitude != null &&
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

  // Setters para selecciones (desde bottom sheet API)
  void setCategory(CategoryEntity? category) {
    _selectedCategory = category;
    _selectedSubCategory = null;
    notifyListeners();
  }

  void setSubCategory(SubcategoryEntity? subCategory) {
    _selectedSubCategory = subCategory;
    notifyListeners();
  }

  void setSchedule(String? schedule) {
    _selectedSchedule = schedule;
    notifyListeners();
  }

  /// Guarda el horario estructurado (días de la UI + hora inicio/fin) para el API.
  void setScheduleData(List<String> days, String startTime, String endTime) {
    _scheduleDays = List.from(days);
    _scheduleStartTime = startTime;
    _scheduleEndTime = endTime;
    notifyListeners();
  }

  void setLatLng(double? lat, double? lng) {
    _latitude = lat;
    _longitude = lng;
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

  /// Limpia todo el formulario (campos, selecciones, imagen, ubicación, horario, errores).
  /// Se llama tras crear sucursal con éxito para poder crear otra.
  void reset() {
    _nameDebounce?.cancel();
    _phoneDebounce?.cancel();
    _addressDebounce?.cancel();
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    _selectedCategory = null;
    _selectedSubCategory = null;
    _selectedSchedule = null;
    _scheduleDays = [];
    _scheduleStartTime = null;
    _scheduleEndTime = null;
    _imagePath = null;
    _latitude = null;
    _longitude = null;
    _nameError = null;
    _phoneError = null;
    _addressError = null;
    notifyListeners();
  }

  /// Ejecuta todas las validaciones de inmediato (sin debounce). Útil al enviar.
  void validateAll() {
    _nameDebounce?.cancel();
    _phoneDebounce?.cancel();
    _addressDebounce?.cancel();
    _runNameValidation(nameController.text);
    _runPhoneValidation(phoneController.text);
    _runAddressValidation(addressController.text);
    notifyListeners();
  }

  void _runNameValidation(String value) {
    if (value.trim().isEmpty) {
      _nameError = null;
      return;
    }
    final validator = BranchConfigFactory.getNameValidator();
    _nameError = validator.validate(value) ? null : validator.getErrorMessage();
  }

  void _runPhoneValidation(String value) {
    if (value.trim().isEmpty) {
      _phoneError = null;
      return;
    }
    final validator = BranchConfigFactory.getPhoneValidator();
    _phoneError = validator.validate(value) ? null : validator.getErrorMessage();
  }

  void _runAddressValidation(String value) {
    if (value.trim().isEmpty) {
      _addressError = null;
      return;
    }
    final validator = BranchConfigFactory.getAddressValidator();
    _addressError = validator.validate(value) ? null : validator.getErrorMessage();
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
