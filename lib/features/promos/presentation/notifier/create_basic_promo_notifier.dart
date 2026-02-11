import 'package:flutter/material.dart';

/// ChangeNotifier para el formulario de promoción básica (regla: formularios complejos).
/// Según diseño Pencil: título, observaciones, imagen, calcular alcance (sin campos lat/lng).
class CreateBasicPromoNotifier extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController observationsController = TextEditingController();

  String? _imagePath;
  int _scopeCount = 0;

  String? get imagePath => _imagePath;
  int get scopeCount => _scopeCount;

  static const int maxTitleLength = 350;
  static const int maxObservationsLength = 1050;

  bool get isFormValid =>
      titleController.text.trim().isNotEmpty &&
      observationsController.text.trim().isNotEmpty &&
      _imagePath != null &&
      _imagePath!.isNotEmpty;

  void setImagePath(String? path) {
    _imagePath = path;
    notifyListeners();
  }

  void setScopeCount(int value) {
    _scopeCount = value;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    observationsController.dispose();
    super.dispose();
  }
}
