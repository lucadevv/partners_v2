import 'dart:async';
import 'package:flutter/material.dart';
import 'package:partners/core/utils/validations/dni_validator.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_comercio.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';

/// ChangeNotifier para manejar las validaciones de UI del formulario de registro
class RegisterFormNotifier extends ChangeNotifier {
  // Timer para debouncer
  Timer? _documentDebounceTimer;
  Timer? _representanteDebounceTimer;
  // Controllers
  final TextEditingController numeroDocumentoController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Controllers adicionales para RUC 20
  final TextEditingController razonSocialController = TextEditingController();
  final TextEditingController numeroDocumentoRepresentanteController = TextEditingController();

  // Valores seleccionados
  TipoComercio? _tipoComercio;
  TipoDocumento? _tipoDocumento;
  TipoDocumento? _tipoDocumentoRepresentante;

  // Estados de validación
  String? _numeroDocumentoError;
  String? _emailError;
  String? _whatsappError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _numeroDocumentoRepresentanteError;

  // Callback para validar documento automáticamente
  Function(String, TipoDocumento?, TipoComercio?)? onDocumentValidated;
  Function(String, TipoDocumento?)? onRepresentanteDocumentValidated;

  // Estados de UI
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isNombresEnabled = false;
  bool _isApellidosEnabled = false;
  bool _isRazonSocialEnabled = false;

  // Getters
  TipoComercio? get tipoComercio => _tipoComercio;
  TipoDocumento? get tipoDocumento => _tipoDocumento;
  TipoDocumento? get tipoDocumentoRepresentante => _tipoDocumentoRepresentante;
  String? get numeroDocumentoError => _numeroDocumentoError;
  String? get emailError => _emailError;
  String? get whatsappError => _whatsappError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  String? get numeroDocumentoRepresentanteError => _numeroDocumentoRepresentanteError;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isNombresEnabled => _isNombresEnabled;
  bool get isApellidosEnabled => _isApellidosEnabled;
  bool get isRazonSocialEnabled => _isRazonSocialEnabled;

  // Setter para tipo de comercio
  void setTipoComercio(TipoComercio? tipo) {
    _tipoComercio = tipo;
    notifyListeners();
  }

  // Setter para tipo de documento
  void setTipoDocumento(TipoDocumento? tipo) {
    _tipoDocumento = tipo;
    // Si hay un número de documento y es RUC 20, validar nuevamente
    if (numeroDocumentoController.text.isNotEmpty && 
        (_tipoComercio == TipoComercio.ruc20)) {
      _validateDocumentWithDebounce();
    }
    notifyListeners();
  }

  // Setter para tipo de documento del representante (RUC 20)
  void setTipoDocumentoRepresentante(TipoDocumento? tipo) {
    _tipoDocumentoRepresentante = tipo;
    notifyListeners();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // Habilitar campos de nombres y apellidos (para RUC 10 y 15)
  void enableNombresApellidos(String nombres, String apellidos) {
    nombresController.text = nombres;
    apellidosController.text = apellidos;
    _isNombresEnabled = true;
    _isApellidosEnabled = true;
    notifyListeners();
  }

  // Habilitar razón social (para RUC 20)
  void enableRazonSocial(String razonSocial) {
    razonSocialController.text = razonSocial;
    _isRazonSocialEnabled = true;
    notifyListeners();
  }

  // Inicializar listeners para debouncer
  void initializeDocumentListeners() {
    numeroDocumentoController.addListener(_onDocumentChanged);
    numeroDocumentoRepresentanteController.addListener(_onRepresentanteDocumentChanged);
  }

  // Listener para cambios en el documento principal
  void _onDocumentChanged() {
    _validateDocumentWithDebounce();
  }

  // Listener para cambios en el documento del representante
  void _onRepresentanteDocumentChanged() {
    _validateRepresentanteDocumentWithDebounce();
  }

  // Validar documento con debouncer (1000ms)
  void _validateDocumentWithDebounce() {
    _documentDebounceTimer?.cancel();
    _documentDebounceTimer = Timer(const Duration(milliseconds: 1000), () {
      final numero = numeroDocumentoController.text.trim();
      
      if (numero.isEmpty) {
        _numeroDocumentoError = null;
        notifyListeners();
        return;
      }

      // Para RUC 10 y 15, validar como DNI (8 dígitos)
      if (_tipoComercio == TipoComercio.ruc10 || 
          _tipoComercio == TipoComercio.ruc15) {
        // Validar como DNI
        if (!DniValidator.isValidDni(numero)) {
          _numeroDocumentoError = 'El DNI debe tener 8 dígitos';
          notifyListeners();
          return;
        }
        // Si es válido, limpiar error y llamar callback
        _numeroDocumentoError = null;
        notifyListeners();
        
        // Llamar callback para validar con backend (usando DNI por defecto)
        if (onDocumentValidated != null && _tipoComercio != null) {
          onDocumentValidated!(numero, TipoDocumento.dni, _tipoComercio);
        }
      } else if (_tipoComercio == TipoComercio.ruc20) {
        // Para RUC 20, el documento principal es el RUC del negocio (no se valida formato específico)
        // Solo validar que no esté vacío y tenga al menos algunos dígitos
        if (numero.length < 8 || !RegExp(r'^\d+$').hasMatch(numero)) {
          _numeroDocumentoError = 'Ingrese un RUC válido';
          notifyListeners();
          return;
        }
        
        // Si es válido, limpiar error y llamar callback
        _numeroDocumentoError = null;
        notifyListeners();

        // Llamar callback para validar con backend (sin tipo de documento para RUC del negocio)
        if (onDocumentValidated != null && _tipoComercio != null) {
          onDocumentValidated!(numero, null, _tipoComercio);
        }
      }
    });
  }

  // Validar documento del representante con debouncer (1000ms)
  void _validateRepresentanteDocumentWithDebounce() {
    _representanteDebounceTimer?.cancel();
    _representanteDebounceTimer = Timer(const Duration(milliseconds: 1000), () {
      final numero = numeroDocumentoRepresentanteController.text.trim();
      
      if (numero.isEmpty) {
        _numeroDocumentoRepresentanteError = null;
        notifyListeners();
        return;
      }

      // Validar formato según tipo de documento
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

      // Si es válido, limpiar error y llamar callback
      _numeroDocumentoRepresentanteError = null;
      notifyListeners();

      // Llamar callback para validar con backend
      if (onRepresentanteDocumentValidated != null && _tipoDocumentoRepresentante != null) {
        onRepresentanteDocumentValidated!(numero, _tipoDocumentoRepresentante);
      }
    });
  }

  // Validación de número de documento (para validación manual)
  bool validateNumeroDocumento() {
    final numero = numeroDocumentoController.text.trim();

    if (numero.isEmpty) {
      _numeroDocumentoError = 'Ingrese el número de documento';
      notifyListeners();
      return false;
    }

    // Para RUC 10 y 15, validar como DNI
    if (_tipoComercio == TipoComercio.ruc10 || 
        _tipoComercio == TipoComercio.ruc15) {
      if (!DniValidator.isValidDni(numero)) {
        _numeroDocumentoError = 'El DNI debe tener 8 dígitos';
        notifyListeners();
        return false;
      }
    } else if (_tipoDocumento == TipoDocumento.dni && !DniValidator.isValidDni(numero)) {
      _numeroDocumentoError = 'El DNI debe tener 8 dígitos';
      notifyListeners();
      return false;
    } else if (_tipoDocumento == TipoDocumento.ce && (numero.length != 9 || !RegExp(r'^\d+$').hasMatch(numero))) {
      _numeroDocumentoError = 'El CE debe tener 9 dígitos';
      notifyListeners();
      return false;
    }

    _numeroDocumentoError = null;
    notifyListeners();
    return true;
  }

  // Validación de email
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

  // Validación de WhatsApp
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

  // Validación de password
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

  // Validación de confirmación de password
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

  // Verificar si el formulario está completo (sin validar, solo verificar que tenga datos)
  bool isFormComplete() {
    // Verificar tipo de comercio
    if (_tipoComercio == null) {
      return false;
    }

    // Verificar número de documento principal
    final numeroDocumento = numeroDocumentoController.text.trim();
    if (numeroDocumento.isEmpty) {
      return false;
    }

    // Para RUC 10 y 15: verificar que tenga nombres y apellidos
    if (_tipoComercio == TipoComercio.ruc10 || _tipoComercio == TipoComercio.ruc15) {
      final nombres = nombresController.text.trim();
      final apellidos = apellidosController.text.trim();
      if (nombres.isEmpty || apellidos.isEmpty) {
        return false;
      }
    }

    // Para RUC 20: verificar razón social, documento del representante y nombres del representante
    if (_tipoComercio == TipoComercio.ruc20) {
      final razonSocial = razonSocialController.text.trim();
      if (razonSocial.isEmpty) {
        return false;
      }

      if (_tipoDocumentoRepresentante == null) {
        return false;
      }

      final numeroRepresentante = numeroDocumentoRepresentanteController.text.trim();
      if (numeroRepresentante.isEmpty) {
        return false;
      }

      final nombresRepresentante = nombresController.text.trim();
      final apellidosRepresentante = apellidosController.text.trim();
      if (nombresRepresentante.isEmpty || apellidosRepresentante.isEmpty) {
        return false;
      }
    }

    return true;
  }

  // Validar todo el formulario
  bool validateForm() {
    bool isValid = true;

    if (_tipoComercio == null) {
      isValid = false;
    }

    // Para RUC 10 y 15, tipoDocumento debe ser DNI (ya se establece automáticamente)
    // Para RUC 20, no se requiere tipoDocumento para el RUC del negocio
    if ((_tipoComercio == TipoComercio.ruc10 || _tipoComercio == TipoComercio.ruc15) && _tipoDocumento == null) {
      isValid = false;
    }

    if (!validateNumeroDocumento()) {
      isValid = false;
    }

    // Para RUC 20, validar documento del representante
    if (_tipoComercio == TipoComercio.ruc20) {
      if (_tipoDocumentoRepresentante == null) {
        isValid = false;
      }

      final numeroRepresentante = numeroDocumentoRepresentanteController.text.trim();
      if (numeroRepresentante.isEmpty) {
        isValid = false;
      } else {
        // Validar formato del documento del representante
        if (_tipoDocumentoRepresentante == TipoDocumento.dni) {
          if (!DniValidator.isValidDni(numeroRepresentante)) {
            _numeroDocumentoRepresentanteError = 'El DNI debe tener 8 dígitos';
            isValid = false;
          }
        } else if (_tipoDocumentoRepresentante == TipoDocumento.ce) {
          if (numeroRepresentante.length != 9 || !RegExp(r'^\d+$').hasMatch(numeroRepresentante)) {
            _numeroDocumentoRepresentanteError = 'El CE debe tener 9 dígitos';
            isValid = false;
          }
        }
      }
    }

    notifyListeners();
    return isValid;
  }

  // Limpiar errores
  void clearErrors() {
    _numeroDocumentoError = null;
    _emailError = null;
    _whatsappError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _numeroDocumentoRepresentanteError = null;
    notifyListeners();
  }

  // Reset completo
  void reset() {
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
    _tipoDocumento = null;
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
    numeroDocumentoController.removeListener(_onDocumentChanged);
    numeroDocumentoRepresentanteController.removeListener(_onRepresentanteDocumentChanged);
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
