// --- PRESENTACIÓN: CHANGE NOTIFIER ---
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:partners/core/utils/enums/enums.dart';
import 'package:partners/features/auth/register/domain/entities/validators/doc_validator.dart';
import 'package:partners/features/auth/register/domain/entities/validators/ruc_validator.dart';
import 'package:partners/features/auth/register/domain/factory/doc_config_factory.dart';
import 'package:partners/features/auth/register/domain/factory/name_config_factory.dart';
import 'package:partners/features/auth/register/domain/factory/rep_config_factory.dart';
import 'package:partners/features/auth/register/domain/factory/ruc_config_factory.dart';
import 'package:partners/features/auth/register/domain/forms/doc_form_config.dart';
import 'package:partners/features/auth/register/domain/forms/form_config.dart';
import 'package:partners/features/auth/register/domain/forms/name_form_config.dart';
import 'package:partners/features/auth/register/domain/forms/rep_doc_form_config.dart';
import 'package:partners/features/auth/register/domain/forms/ruc_form_config.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:partners/features/auth/register/presentation/cubit/register_state.dart';

class RegisterFormNotifier extends ChangeNotifier {
  final RegisterCubit _cubit;

  // 1. SELECTORES
  RucType _selectedRuc = RucType.ruc10;
  DocumentType? _selectedDocType;

  // 2. FLAGS DE ÉXITO (Para controlar el botón)
  bool _isRucValid = false;
  bool _isDocValid = false;

  // 3. ERRORES
  String? _rucError;
  String? _docError;

  // 4. DEBOUNCERS (Timers)
  Timer? _rucDebounce;
  Timer? _docDebounce;

  // 5. CONTROLLERS
  final TextEditingController rucController = TextEditingController();
  final TextEditingController nameSocialRazonController =
      TextEditingController();
  final TextEditingController docRepController = TextEditingController();
  final TextEditingController nameRepContoller = TextEditingController();

  RegisterFormNotifier({required RegisterCubit cubit}) : _cubit = cubit;

  // --- FACTORIES ---
  RucFormConfig get rucConfig => RucConfigFactory.getConfig(_selectedRuc);
  NameFormConfig get nameConfig => NameConfigFactory.getConfig(_selectedRuc);
  DocFormConfig get docConfig => DocConfigFactory.getConfig(_selectedDocType);
  RepDocFormConfig get repConfig =>
      RepConfigFactory.getDocConfig(_selectedDocType);
  FieldDefinition get repNameConfig => RepConfigFactory.getNameConfig();

  // --- GETTERS PÚBLICOS ---
  RucType get selectedRuc => _selectedRuc;
  DocumentType? get selectedDocType => _selectedDocType;
  String? get rucError => _rucError;
  String? get docError => _docError;

  // IMPORTANTE: Getter para saber si el formulario está completo
  bool get isFormComplete {
    if (_selectedRuc == RucType.ruc20) {
      return _cubit.state.sendRucStatus == RegisterStatus.success &&
          _cubit.state.sendDocStatus == RegisterStatus.success &&
          _isRucValid &&
          _isDocValid;
    }
    return _cubit.state.sendRucStatus == RegisterStatus.success && _isRucValid;
  }

  // --- ACCIONES ---

  void changeRucType(RucType tipo) {
    // RESET TOTAL AL CAMBIAR DE TIPO
    _cubit.reset();
    _selectedRuc = tipo;
    _rucError = null;
    _isRucValid = false; // Reset flag

    // Limpiar datos de representante si cambio a tipo que no lo necesita
    if (tipo != RucType.ruc20) {
      _docError = null;
      _isDocValid = false;
    }

    // Limpiar Controllers para evitar confusiones
    rucController.clear();
    nameSocialRazonController.clear();
    docRepController.clear();
    nameRepContoller.clear();

    notifyListeners();
  }

  void changeDocType(DocumentType tipo) {
    _selectedDocType = tipo;
    _docError = null;
    _isDocValid = false; // Reset flag porque cambió el doc
    docRepController.clear();
    nameRepContoller.clear();

    notifyListeners();
  }

  // --- VALIDACIÓN ASÍNCRONA CON DEBOUNCER Y MOCK DE API ---

  void validateRuc(String value) {
    if (_rucDebounce?.isActive ?? false) _rucDebounce!.cancel();

    _rucDebounce = Timer(Duration(milliseconds: 800), () async {
      final RucStrategy strategy = RucConfigFactory.getValidatorStrategy(
        _selectedRuc,
      );

      if (!strategy.validate(value)) {
        _rucError = strategy.getErrorMessage();
        _isRucValid = false;
        nameSocialRazonController.clear();
      } else {
        _rucError = null;
        _cubit.sendRuc(ruc: value, type: _selectedRuc);
      }
      notifyListeners();
    });
  }

  void validateRepDoc(String value) {
    // Solo validamos si ya seleccionó tipo de documento
    if (_selectedDocType == null) return;

    if (_docDebounce?.isActive ?? false) _docDebounce!.cancel();

    _docDebounce = Timer(Duration(milliseconds: 800), () async {
      final DocValidatorStrategy strategy =
          DocConfigFactory.getValidatorStrategy(_selectedDocType!);
      if (!strategy.validate(value)) {
        _docError = strategy.getErrorMessage();
        _isDocValid = false;
        nameRepContoller.clear();
      } else {
        _docError = null;
        _cubit.sendDocumendt(type: _selectedDocType!, number: value);
      }
      notifyListeners();
    });
  }

  // Change Notifier
  void updateFromRucResponse(String socialReason) {
    nameSocialRazonController.text = socialReason;
    _isRucValid = true;
    notifyListeners();
  }

  void updateFromDocResponse(String representativeName) {
    nameRepContoller.text = representativeName;
    _isDocValid = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _rucDebounce?.cancel();
    _docDebounce?.cancel();
    rucController.dispose();
    nameSocialRazonController.dispose();
    docRepController.dispose();
    nameRepContoller.dispose();
    super.dispose();
  }
}
