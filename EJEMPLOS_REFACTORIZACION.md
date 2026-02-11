# 🔧 Ejemplos de Refactorización

## 1. Container → DecoratedBox (Performance)

### ❌ ANTES (Ineficiente)
```dart
// lib/features/branches/presentation/screens/add_workers_screen.dart
body: Container(
  decoration: const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(50),
      topRight: Radius.circular(50),
    ),
  ),
  child: Column(
    children: [
      Container(
        width: 131,
        height: 5,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      // ...
    ],
  ),
)
```

### ✅ DESPUÉS (Optimizado)
```dart
// lib/features/branches/presentation/screens/add_workers_screen.dart
body: DecoratedBox(
  decoration: const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(50),
      topRight: Radius.circular(50),
    ),
  ),
  child: Column(
    children: [
      Container(
        width: 131,
        height: 5,
        margin: const EdgeInsets.only(top: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      // ...
    ],
  ),
)
```

**Nota:** El Container interno necesita mantenerse porque tiene `margin`, pero el `decoration` puede ir en un `DecoratedBox` hijo.

---

## 2. Formulario Complejo → ChangeNotifier

### ❌ ANTES (setState directo)
```dart
// lib/features/branches/presentation/screens/create_branch_screen.dart
class _CreateBranchScreenState extends State<CreateBranchScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedSchedule;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleNameChange(String value) {
    setState(() {
      // Validación aquí
    });
  }

  // ... más métodos con setState
}
```

### ✅ DESPUÉS (ChangeNotifier)
```dart
// lib/features/branches/presentation/notifier/create_branch_form_notifier.dart
import 'dart:async';
import 'package:flutter/material.dart';

class CreateBranchFormNotifier extends ChangeNotifier {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Estados
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedSchedule;

  // Errores
  String? _nameError;
  String? _phoneError;
  String? _addressError;

  // Debouncers
  Timer? _nameDebounce;
  Timer? _phoneDebounce;

  // Getters
  String? get selectedCategory => _selectedCategory;
  String? get selectedSubCategory => _selectedSubCategory;
  String? get selectedSchedule => _selectedSchedule;
  String? get nameError => _nameError;
  String? get phoneError => _phoneError;
  String? get addressError => _addressError;

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

  // Validación con debouncer
  void validateName(String value) {
    if (_nameDebounce?.isActive ?? false) _nameDebounce!.cancel();

    _nameDebounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isEmpty) {
        _nameError = 'El nombre es requerido';
      } else if (value.length < 3) {
        _nameError = 'El nombre debe tener al menos 3 caracteres';
      } else {
        _nameError = null;
      }
      notifyListeners();
    });
  }

  void validatePhone(String value) {
    if (_phoneDebounce?.isActive ?? false) _phoneDebounce!.cancel();

    _phoneDebounce = Timer(const Duration(milliseconds: 500), () {
      final phoneRegex = RegExp(r'^[0-9]{9}$');
      if (value.isEmpty) {
        _phoneError = 'El teléfono es requerido';
      } else if (!phoneRegex.hasMatch(value)) {
        _phoneError = 'El teléfono debe tener 9 dígitos';
      } else {
        _phoneError = null;
      }
      notifyListeners();
    });
  }

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

  @override
  void dispose() {
    _nameDebounce?.cancel();
    _phoneDebounce?.cancel();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
```

```dart
// lib/features/branches/presentation/screens/create_branch_screen.dart
class _CreateBranchScreenState extends State<CreateBranchScreen> {
  late CreateBranchFormNotifier _formNotifier;

  @override
  void initState() {
    super.initState();
    _formNotifier = CreateBranchFormNotifier();
    
    // Listeners para validación automática
    _formNotifier.nameController.addListener(() {
      _formNotifier.validateName(_formNotifier.nameController.text);
    });
    
    _formNotifier.phoneController.addListener(() {
      _formNotifier.validatePhone(_formNotifier.phoneController.text);
    });
  }

  @override
  void dispose() {
    _formNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _formNotifier,
      builder: (context, child) {
        return Scaffold(
          // ... UI usando _formNotifier
          // Ejemplo:
          _buildTextField(
            label: 'Nombre de la sucursal',
            controller: _formNotifier.nameController,
            error: _formNotifier.nameError,
          ),
          // ...
          ElevatedButton(
            onPressed: _formNotifier.isFormComplete 
              ? () => _handleCreate() 
              : null,
            child: const Text('Crear'),
          ),
        );
      },
    );
  }
}
```

---

## 3. Widget Grande → Componentes Pequeños

### ❌ ANTES (Widget grande)
```dart
// 653 líneas en create_branch_screen.dart
class _CreateBranchScreenState extends State<CreateBranchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildUploadBannerButton(), // 50 líneas
          _buildTextField(...), // 30 líneas
          _buildCategoryField(), // 40 líneas
          _buildLocationSection(), // 100 líneas
          // ... más métodos grandes
        ],
      ),
    );
  }
}
```

### ✅ DESPUÉS (Componentes separados)
```dart
// lib/features/branches/presentation/widgets/branch_upload_banner_widget.dart
class BranchUploadBannerWidget extends StatelessWidget {
  final VoidCallback onTap;
  
  const BranchUploadBannerWidget({required this.onTap, super.key});
  
  @override
  Widget build(BuildContext context) {
    // Lógica del banner
  }
}

// lib/features/branches/presentation/widgets/branch_location_section_widget.dart
class BranchLocationSectionWidget extends StatelessWidget {
  final String? address;
  final VoidCallback onTap;
  
  const BranchLocationSectionWidget({
    required this.address,
    required this.onTap,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    // Lógica de ubicación
  }
}

// lib/features/branches/presentation/screens/create_branch_screen.dart
class _CreateBranchScreenState extends State<CreateBranchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BranchUploadBannerWidget(
            onTap: () => _handleUpload(),
          ),
          BranchTextField(
            label: 'Nombre',
            controller: _formNotifier.nameController,
            error: _formNotifier.nameError,
          ),
          BranchCategoryField(
            selectedCategory: _formNotifier.selectedCategory,
            onCategorySelected: _formNotifier.setCategory,
          ),
          BranchLocationSectionWidget(
            address: _formNotifier.addressController.text,
            onTap: () => _handleLocation(),
          ),
        ],
      ),
    );
  }
}
```

---

## 📋 Checklist de Refactorización

### Para cada formulario complejo:
- [ ] Crear `*FormNotifier extends ChangeNotifier`
- [ ] Mover Controllers al notifier
- [ ] Mover validación al notifier
- [ ] Mover estados al notifier
- [ ] Usar `ListenableBuilder` en el widget
- [ ] Implementar `dispose()` correctamente

### Para cada Container con solo decoration:
- [ ] Verificar si tiene padding/margin/constraints
- [ ] Si NO tiene: Cambiar a `DecoratedBox`
- [ ] Si tiene: Mantener `Container` pero optimizar

### Para widgets grandes (>300 líneas):
- [ ] Identificar secciones lógicas
- [ ] Extraer a widgets separados
- [ ] Mantener screen principal limpio
- [ ] Usar nombres descriptivos

---

## 🎯 Beneficios de las Refactorizaciones

1. **Performance:**
   - DecoratedBox es más ligero que Container
   - Mejor rendimiento en scrolls y listas
   - Menos reconstrucciones innecesarias

2. **Mantenibilidad:**
   - ChangeNotifier separa lógica de UI
   - Widgets pequeños son más fáciles de testear
   - Código más legible y organizado

3. **Consistencia:**
   - Mismo patrón en todos los formularios
   - Fácil de entender para nuevos desarrolladores
   - Sigue las mejores prácticas de Flutter
