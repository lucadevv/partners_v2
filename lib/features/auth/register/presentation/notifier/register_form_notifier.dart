import 'dart:async';
import 'package:flutter/material.dart';
import 'package:partners/core/utils/validations/dni_validator.dart';
import 'package:partners/core/utils/validations/ruc_validator.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_comercio.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';
import 'package:partners/features/auth/register/domain/entities/validate_ruc_entity.dart';

/// ChangeNotifier para manejar las validaciones de UI del formulario de registro
/// Separado por tipo de RUC (10, 15, 20)
class RegisterFormNotifier extends ChangeNotifier {
  // Timer para debouncer de validación de formato
  Timer? _documentDebounceTimer;
  Timer? _representanteDebounceTimer;
  
  // Timer para debouncer de llamada a cubits
  Timer? _commerceDebounceTimer;
  Timer? _documentCubitDebounceTimer;

  // Controllers compartidos
  final TextEditingController numeroDocumentoController =
      TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Controllers específicos para RUC 20
  final TextEditingController razonSocialController = TextEditingController();
  final TextEditingController numeroDocumentoRepresentanteController =
      TextEditingController();

  // Tipo de comercio actual
  TipoComercio? _tipoComercio;

  // Estados de validación - RUC 10 y 15
  String? _numeroDocumentoError;
  bool _isNombresEnabled = false;
  bool _isApellidosEnabled = false;

  // Estados de validación - RUC 20
  String? _numeroDocumentoRepresentanteError;
  bool _isRazonSocialEnabled = false;
  TipoDocumento? _tipoDocumentoRepresentante;

  // Estados de validación generales
  String? _emailError;
  String? _whatsappError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Estados de UI
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Callbacks para llamar a los cubits
  Function(ValidateRucEntity)? onValidateCommerce;
  Function(TipoDocumento, String)? onValidateDocument;

  // Getters
  TipoComercio? get tipoComercio => _tipoComercio;
  TipoDocumento? get tipoDocumentoRepresentante => _tipoDocumentoRepresentante;
  String? get numeroDocumentoError => _numeroDocumentoError;
  String? get numeroDocumentoRepresentanteError =>
      _numeroDocumentoRepresentanteError;
  String? get emailError => _emailError;
  String? get whatsappError => _whatsappError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isNombresEnabled => _isNombresEnabled;
  bool get isApellidosEnabled => _isApellidosEnabled;
  bool get isRazonSocialEnabled => _isRazonSocialEnabled;

  // ==================== MÉTODOS PARA CAMBIAR TIPO DE COMERCIO ====================

  /// Establece el tipo de comercio y reinicia el formulario correspondiente
  void setTipoComercio(TipoComercio? tipo) {
    if (_tipoComercio != tipo) {
    _tipoComercio = tipo;
      _resetFormByTipo();
    notifyListeners();
    }
  }

  /// Reinicia el formulario según el tipo de comercio
  void _resetFormByTipo() {
    switch (_tipoComercio) {
      case TipoComercio.ruc10:
        _resetRuc10();
        break;
      case TipoComercio.ruc15:
        _resetRuc15();
        break;
      case TipoComercio.ruc20:
        _resetRuc20();
        break;
      case null:
        _resetAll();
        break;
    }
  }

  // ==================== MÉTODOS PARA RUC 10 ====================

  /// Reinicia el formulario para RUC 10
  void _resetRuc10() {
    numeroDocumentoController.clear();
    nombresController.clear();
    apellidosController.clear();
    _numeroDocumentoError = null;
    _isNombresEnabled = false;
    _isApellidosEnabled = false;
    _documentDebounceTimer?.cancel();
    _commerceDebounceTimer?.cancel();
  }

  /// Valida el RUC para RUC 10
  void _validateRuc10() {
    final ruc = numeroDocumentoController.text.trim();

    if (ruc.isEmpty) {
      _numeroDocumentoError = null;
      notifyListeners();
      return;
    }

    if (!RucValidator.isValidRuc(ruc, TipoComercio.ruc10,
        tipoDocumento: TipoDocumento.dni)) {
      _numeroDocumentoError = 'El RUC debe tener 11 dígitos y empezar con 10';
      notifyListeners();
      return;
    }

    _numeroDocumentoError = null;
    notifyListeners();

    // Llamar al cubit con debouncer después de validar el formato
    // Enviar el RUC completo
    _callValidateCommerceWithDebounce(
      ValidateRucEntity(
        tipoComercio: TipoComercio.ruc10,
        ruc: ruc,
      ),
    );
  }

  /// Valida si el formulario RUC 10 está completo
  bool isRuc10Complete() {
    final ruc = numeroDocumentoController.text.trim();
    final nombres = nombresController.text.trim();
    final apellidos = apellidosController.text.trim();

    return ruc.isNotEmpty && nombres.isNotEmpty && apellidos.isNotEmpty;
  }

  /// Habilita nombres y apellidos para RUC 10
  void enableNombresApellidosRuc10(String nombres, String apellidos) {
    nombresController.text = nombres;
    apellidosController.text = apellidos;
    _isNombresEnabled = true;
    _isApellidosEnabled = true;
    notifyListeners();
  }

  // ==================== MÉTODOS PARA RUC 15 ====================

  /// Reinicia el formulario para RUC 15
  void _resetRuc15() {
    numeroDocumentoController.clear();
    nombresController.clear();
    apellidosController.clear();
    _numeroDocumentoError = null;
    _isNombresEnabled = false;
    _isApellidosEnabled = false;
    _documentDebounceTimer?.cancel();
    _commerceDebounceTimer?.cancel();
  }

  /// Valida el RUC para RUC 15
  void _validateRuc15() {
    final ruc = numeroDocumentoController.text.trim();

    if (ruc.isEmpty) {
      _numeroDocumentoError = null;
      notifyListeners();
      return;
    }

    if (!RucValidator.isValidRuc(ruc, TipoComercio.ruc15,
        tipoDocumento: TipoDocumento.dni)) {
      _numeroDocumentoError = 'El RUC debe tener 12-13 dígitos y empezar con 15';
      notifyListeners();
      return;
    }

    _numeroDocumentoError = null;
    notifyListeners();

    // Llamar al cubit con debouncer después de validar el formato
    // Enviar el RUC completo
    _callValidateCommerceWithDebounce(
      ValidateRucEntity(
        tipoComercio: TipoComercio.ruc15,
        ruc: ruc,
      ),
    );
  }

  /// Valida si el formulario RUC 15 está completo
  bool isRuc15Complete() {
    final ruc = numeroDocumentoController.text.trim();
    final nombres = nombresController.text.trim();
    final apellidos = apellidosController.text.trim();

    return ruc.isNotEmpty && nombres.isNotEmpty && apellidos.isNotEmpty;
  }

  /// Habilita nombres y apellidos para RUC 15
  void enableNombresApellidosRuc15(String nombres, String apellidos) {
    nombresController.text = nombres;
    apellidosController.text = apellidos;
    _isNombresEnabled = true;
    _isApellidosEnabled = true;
    notifyListeners();
  }

  // ==================== MÉTODOS PARA RUC 20 ====================

  /// Reinicia el formulario para RUC 20
  void _resetRuc20() {
    numeroDocumentoController.clear();
    razonSocialController.clear();
    numeroDocumentoRepresentanteController.clear();
    nombresController.clear();
    apellidosController.clear();
    _numeroDocumentoError = null;
    _numeroDocumentoRepresentanteError = null;
    _isRazonSocialEnabled = false;
    _tipoDocumentoRepresentante = null;
    _isNombresEnabled = false;
    _isApellidosEnabled = false;
    _documentDebounceTimer?.cancel();
    _representanteDebounceTimer?.cancel();
    _commerceDebounceTimer?.cancel();
    _documentCubitDebounceTimer?.cancel();
  }

  /// Establece el tipo de documento del representante para RUC 20
  void setTipoDocumentoRepresentante(TipoDocumento? tipo) {
    _tipoDocumentoRepresentante = tipo;
    notifyListeners();
  }

  /// Valida el RUC del negocio para RUC 20
  void _validateRuc20() {
    final ruc = numeroDocumentoController.text.trim();

    if (ruc.isEmpty) {
        _numeroDocumentoError = null;
        notifyListeners();
        return;
      }

    // Para RUC 20, validar como DNI o CE
    final isValid = RucValidator.isValidRuc(ruc, TipoComercio.ruc20,
            tipoDocumento: TipoDocumento.dni) ||
        RucValidator.isValidRuc(ruc, TipoComercio.ruc20,
            tipoDocumento: TipoDocumento.ce);

        if (!isValid) {
      _numeroDocumentoError = 'El RUC debe tener 12-13 dígitos y empezar con 20';
          notifyListeners();
          return;
        }

        _numeroDocumentoError = null;
        notifyListeners();

    // Llamar al cubit con debouncer después de validar el formato
    // Enviar el RUC completo
    _callValidateCommerceWithDebounce(
      ValidateRucEntity(
        tipoComercio: TipoComercio.ruc20,
        ruc: ruc,
      ),
    );
  }

  /// Valida el documento del representante para RUC 20
  void _validateRepresentanteRuc20() {
      final numero = numeroDocumentoRepresentanteController.text.trim();

      if (numero.isEmpty) {
        _numeroDocumentoRepresentanteError = null;
        notifyListeners();
        return;
      }

      if (_tipoDocumentoRepresentante == TipoDocumento.dni) {
        if (!DniValidator.isValidDni(numero)) {
          _numeroDocumentoRepresentanteError = 'El DNI debe tener 8 dígitos';
          notifyListeners();
          return;
        }
      } else if (_tipoDocumentoRepresentante == TipoDocumento.ce) {
        if (numero.length != 9 || !RegExp(r'^\d+$').hasMatch(numero)) {
          _numeroDocumentoRepresentanteError = 'El CE debe tener 9 dígitos';
          notifyListeners();
          return;
        }
      }

      _numeroDocumentoRepresentanteError = null;
      notifyListeners();

    // Llamar al cubit con debouncer después de validar el formato
    if (_tipoDocumentoRepresentante != null) {
      _callValidateDocumentWithDebounce(
        _tipoDocumentoRepresentante!,
        numero,
      );
    }
  }

  /// Valida si el formulario RUC 20 está completo
  bool isRuc20Complete() {
    final ruc = numeroDocumentoController.text.trim();
    final razonSocial = razonSocialController.text.trim();
    final tipoDocRep = _tipoDocumentoRepresentante;
    final numeroDocRep = numeroDocumentoRepresentanteController.text.trim();
    final nombresRep = nombresController.text.trim();
    final apellidosRep = apellidosController.text.trim();

    return ruc.isNotEmpty &&
        razonSocial.isNotEmpty &&
        tipoDocRep != null &&
        numeroDocRep.isNotEmpty &&
        nombresRep.isNotEmpty &&
        apellidosRep.isNotEmpty;
  }

  /// Habilita razón social para RUC 20
  void enableRazonSocialRuc20(String razonSocial) {
    razonSocialController.text = razonSocial;
    _isRazonSocialEnabled = true;
    notifyListeners();
  }

  /// Habilita nombres y apellidos del representante para RUC 20
  void enableNombresApellidosRuc20(String nombres, String apellidos) {
    nombresController.text = nombres;
    apellidosController.text = apellidos;
    _isNombresEnabled = true;
    _isApellidosEnabled = true;
    notifyListeners();
  }

  // ==================== MÉTODOS COMPARTIDOS ====================

  /// Inicializar listeners para debouncer
  void initializeDocumentListeners() {
    numeroDocumentoController.addListener(_onDocumentChanged);
    numeroDocumentoRepresentanteController.addListener(
      _onRepresentanteDocumentChanged,
    );
  }

  /// Listener para cambios en el documento principal
  void _onDocumentChanged() {
    _validateDocumentWithDebounce();
  }

  /// Listener para cambios en el documento del representante
  void _onRepresentanteDocumentChanged() {
    _validateRepresentanteDocumentWithDebounce();
  }

  /// Valida documento con debouncer según el tipo de comercio
  void _validateDocumentWithDebounce() {
    _documentDebounceTimer?.cancel();
    _documentDebounceTimer = Timer(const Duration(milliseconds: 1000), () {
      switch (_tipoComercio) {
        case TipoComercio.ruc10:
          _validateRuc10();
          break;
        case TipoComercio.ruc15:
          _validateRuc15();
          break;
        case TipoComercio.ruc20:
          _validateRuc20();
          break;
        case null:
          break;
      }
    });
  }

  /// Valida documento del representante con debouncer (solo RUC 20)
  void _validateRepresentanteDocumentWithDebounce() {
    if (_tipoComercio != TipoComercio.ruc20) return;

    _representanteDebounceTimer?.cancel();
    _representanteDebounceTimer = Timer(const Duration(milliseconds: 1000), () {
      _validateRepresentanteRuc20();
    });
  }

  /// Llama a validateComerce del cubit con debouncer
  void _callValidateCommerceWithDebounce(ValidateRucEntity entity) {
    _commerceDebounceTimer?.cancel();
    _commerceDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (onValidateCommerce != null) {
        onValidateCommerce!(entity);
      }
    });
  }

  /// Llama a validateDocument del cubit con debouncer
  void _callValidateDocumentWithDebounce(TipoDocumento type, String number) {
    _documentCubitDebounceTimer?.cancel();
    _documentCubitDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (onValidateDocument != null) {
        onValidateDocument!(type, number);
      }
    });
  }

  /// Verifica si el formulario está completo según el tipo de comercio
  bool isFormComplete() {
    switch (_tipoComercio) {
      case TipoComercio.ruc10:
        return isRuc10Complete();
      case TipoComercio.ruc15:
        return isRuc15Complete();
      case TipoComercio.ruc20:
        return isRuc20Complete();
      case null:
        return false;
    }
  }

  /// Valida todo el formulario según el tipo de comercio
  bool validateForm() {
    switch (_tipoComercio) {
      case TipoComercio.ruc10:
        return _validateFormRuc10();
      case TipoComercio.ruc15:
        return _validateFormRuc15();
      case TipoComercio.ruc20:
        return _validateFormRuc20();
      case null:
        return false;
    }
  }

  /// Valida formulario RUC 10
  bool _validateFormRuc10() {
    final ruc = numeroDocumentoController.text.trim();
    if (ruc.isEmpty) {
      _numeroDocumentoError = 'Ingrese el RUC del negocio';
      notifyListeners();
      return false;
    }

    if (!RucValidator.isValidRuc(ruc, TipoComercio.ruc10,
        tipoDocumento: TipoDocumento.dni)) {
      _numeroDocumentoError = 'El RUC debe tener 11 dígitos y empezar con 10';
      notifyListeners();
      return false;
    }

    final nombres = nombresController.text.trim();
    final apellidos = apellidosController.text.trim();
    if (nombres.isEmpty || apellidos.isEmpty) {
      notifyListeners();
      return false;
    }

    _numeroDocumentoError = null;
    notifyListeners();
    return true;
  }

  /// Valida formulario RUC 15
  bool _validateFormRuc15() {
    final ruc = numeroDocumentoController.text.trim();
    if (ruc.isEmpty) {
      _numeroDocumentoError = 'Ingrese el RUC del negocio';
      notifyListeners();
      return false;
    }

    if (!RucValidator.isValidRuc(ruc, TipoComercio.ruc15,
        tipoDocumento: TipoDocumento.dni)) {
      _numeroDocumentoError = 'El RUC debe tener 12-13 dígitos y empezar con 15';
      notifyListeners();
      return false;
    }

    final nombres = nombresController.text.trim();
    final apellidos = apellidosController.text.trim();
    if (nombres.isEmpty || apellidos.isEmpty) {
      notifyListeners();
      return false;
    }

    _numeroDocumentoError = null;
    notifyListeners();
    return true;
  }

  /// Valida formulario RUC 20
  bool _validateFormRuc20() {
    bool isValid = true;

    final ruc = numeroDocumentoController.text.trim();
    if (ruc.isEmpty) {
      _numeroDocumentoError = 'Ingrese el RUC del negocio';
      isValid = false;
    } else {
      final isValidRuc = RucValidator.isValidRuc(ruc, TipoComercio.ruc20,
              tipoDocumento: TipoDocumento.dni) ||
          RucValidator.isValidRuc(ruc, TipoComercio.ruc20,
              tipoDocumento: TipoDocumento.ce);
      if (!isValidRuc) {
        _numeroDocumentoError = 'El RUC debe tener 12-13 dígitos y empezar con 20';
        isValid = false;
      } else {
        _numeroDocumentoError = null;
      }
    }

    final razonSocial = razonSocialController.text.trim();
    if (razonSocial.isEmpty) {
      isValid = false;
    }

    if (_tipoDocumentoRepresentante == null) {
      isValid = false;
    }

    final numeroRepresentante = numeroDocumentoRepresentanteController.text.trim();
    if (numeroRepresentante.isEmpty) {
      isValid = false;
    } else if (_tipoDocumentoRepresentante != null) {
      if (_tipoDocumentoRepresentante == TipoDocumento.dni) {
        if (!DniValidator.isValidDni(numeroRepresentante)) {
          _numeroDocumentoRepresentanteError = 'El DNI debe tener 8 dígitos';
          isValid = false;
        }
      } else if (_tipoDocumentoRepresentante == TipoDocumento.ce) {
        if (numeroRepresentante.length != 9 ||
            !RegExp(r'^\d+$').hasMatch(numeroRepresentante)) {
          _numeroDocumentoRepresentanteError = 'El CE debe tener 9 dígitos';
          isValid = false;
        }
      }
    }

    final nombresRep = nombresController.text.trim();
    final apellidosRep = apellidosController.text.trim();
    if (nombresRep.isEmpty || apellidosRep.isEmpty) {
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  // ==================== MÉTODOS GENERALES ====================

  /// Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  /// Validación de email
  bool validateEmail() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _emailError = 'Ingrese su correo electrónico';
      notifyListeners();
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _emailError = 'Ingrese un correo válido';
      notifyListeners();
      return false;
    }

    _emailError = null;
    notifyListeners();
    return true;
  }

  /// Validación de WhatsApp
  bool validateWhatsapp() {
    final whatsapp = whatsappController.text.trim();

    if (whatsapp.isEmpty) {
      _whatsappError = 'Ingrese su número de WhatsApp';
      notifyListeners();
      return false;
    }

    if (whatsapp.length != 9) {
      _whatsappError = 'El número debe tener 9 dígitos';
      notifyListeners();
      return false;
    }

    _whatsappError = null;
    notifyListeners();
    return true;
  }

  /// Validación de password
  bool validatePassword() {
    final password = passwordController.text;

    if (password.isEmpty) {
      _passwordError = 'Ingrese su contraseña';
      notifyListeners();
      return false;
    }

    if (password.length < 8) {
      _passwordError = 'La contraseña debe tener al menos 8 caracteres';
      notifyListeners();
      return false;
    }

    _passwordError = null;
    notifyListeners();
    return true;
  }

  /// Validación de confirmación de password
  bool validateConfirmPassword() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'Confirme su contraseña';
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _confirmPasswordError = 'Las contraseñas no coinciden';
      notifyListeners();
      return false;
    }

    _confirmPasswordError = null;
    notifyListeners();
    return true;
  }

  /// Limpiar errores
  void clearErrors() {
    _numeroDocumentoError = null;
    _emailError = null;
    _whatsappError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _numeroDocumentoRepresentanteError = null;
    notifyListeners();
  }

  /// Reset completo
  void _resetAll() {
    numeroDocumentoController.clear();
    nombresController.clear();
    apellidosController.clear();
    emailController.clear();
    whatsappController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    razonSocialController.clear();
    numeroDocumentoRepresentanteController.clear();

    _tipoComercio = null;
    _tipoDocumentoRepresentante = null;
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    _isNombresEnabled = false;
    _isApellidosEnabled = false;
    _isRazonSocialEnabled = false;

    clearErrors();
  }

  @override
  void dispose() {
    _documentDebounceTimer?.cancel();
    _representanteDebounceTimer?.cancel();
    _commerceDebounceTimer?.cancel();
    _documentCubitDebounceTimer?.cancel();
    numeroDocumentoController.removeListener(_onDocumentChanged);
    numeroDocumentoRepresentanteController.removeListener(
      _onRepresentanteDocumentChanged,
    );
    numeroDocumentoController.dispose();
    nombresController.dispose();
    apellidosController.dispose();
    emailController.dispose();
    whatsappController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    razonSocialController.dispose();
    numeroDocumentoRepresentanteController.dispose();
    super.dispose();
  }
}
