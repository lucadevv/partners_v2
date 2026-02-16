import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/employees/domain/domain.dart';
import 'package:partners/features/employees/presentation/screens/create_employee_screen_strings.dart';
import 'package:partners/features/employees/presentation/widgets/create_employee_photo_section.dart';
import 'package:partners/main.dart';

@RoutePage()
class EditEmployeeScreen extends StatefulWidget {
  const EditEmployeeScreen({super.key, required this.employeeId});

  final String employeeId;

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  List<BranchOptionEntity> _branchOptions = const [];
  List<RoleOptionEntity> _roleOptions = const [];
  String? _selectedBranchId;
  String? _selectedRoleId;
  String? _photoPath;

  bool _loading = true;
  String? _loadError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadOptions();
    _loadEmployee();
  }

  Future<void> _loadOptions() async {
    final branches = await getIt<GetOptionsBranchesUsecase>().call();
    final roles = await getIt<GetOptionsRolesUsecase>().call();
    if (!mounted) return;
    branches.fold((_) {}, (list) => setState(() {
      _branchOptions = list;
      if (list.isNotEmpty && _selectedBranchId == null) {
        _selectedBranchId = list.first.id;
      }
    }));
    roles.fold((_) {}, (list) => setState(() {
      _roleOptions = list;
      if (list.isNotEmpty && _selectedRoleId == null) {
        _selectedRoleId = list.first.id;
      }
    }));
  }

  Future<void> _loadEmployee() async {
    final result = await getIt<GetEmployeeByIdUsecase>().call(widget.employeeId);
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _loading = false;
        _loadError = 'No se pudo cargar el empleado';
      }),
      (entity) {
        final (name, lastName) = _splitFullName(entity.name);
        _nameController.text = name;
        _lastNameController.text = lastName;
        _emailController.text = entity.email ?? '';
        _selectedBranchId = entity.branchId;
        RoleOptionEntity? roleMatch;
        for (final r in _roleOptions) {
          if (r.name == entity.role) {
            roleMatch = r;
            break;
          }
        }
        _selectedRoleId =
            roleMatch?.id ?? (_roleOptions.isNotEmpty ? _roleOptions.first.id : null);
        setState(() => _loading = false);
      },
    );
  }

  /// Separa "Nombre Apellido(s)" en (nombre, apellidos). Si no hay espacio, todo va a nombre.
  static (String, String) _splitFullName(String fullName) {
    final trimmed = fullName.trim();
    final firstSpace = trimmed.indexOf(' ');
    if (firstSpace <= 0) {
      return (trimmed, '');
    }
    return (
      trimmed.substring(0, firstSpace).trim(),
      trimmed.substring(firstSpace + 1).trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBranchId == null || _selectedRoleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione sucursal y rol')),
      );
      return;
    }
    setState(() => _saving = true);
    final params = UpdateEmployeeParams(
      email: _emailController.text.trim(),
      name: _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      branchId: _selectedBranchId!,
      roleId: _selectedRoleId!,
      photoPath: _photoPath,
    );
    final result = await getIt<UpdateEmployeeUsecase>().call(
      widget.employeeId,
      params,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    result.fold(
      (e) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Empleado actualizado correctamente'),
          ),
        );
        context.router.maybePop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.appColor.primary),
            onPressed: () => context.router.maybePop(),
          ),
          title: Text(
            'Editar empleado',
            style: TextStyle(
              color: context.appColor.primary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Figtree',
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_loadError != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.appColor.primary),
            onPressed: () => context.router.maybePop(),
          ),
          title: Text(
            'Editar empleado',
            style: TextStyle(
              color: context.appColor.primary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Figtree',
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_loadError!, style: TextStyle(color: context.appColor.error)),
              16.spaceh,
              ElevatedButton(
                onPressed: () => context.router.maybePop(),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.appColor.primary),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          'Editar empleado',
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: CreateEmployeeScreenStrings.emailLabel,
                  hintText: CreateEmployeeScreenStrings.emailHint,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              16.spaceh,
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: CreateEmployeeScreenStrings.nameLabel,
                  hintText: CreateEmployeeScreenStrings.nameHint,
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              16.spaceh,
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: CreateEmployeeScreenStrings.lastNameLabel,
                  hintText: CreateEmployeeScreenStrings.lastNameHint,
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              16.spaceh,
              CreateEmployeePhotoSection(
                imagePath: _photoPath,
                onPathChanged: (path) => setState(() => _photoPath = path),
              ),
              16.spaceh,
              DropdownButtonFormField<String>(
                value: _selectedBranchId,
                decoration: const InputDecoration(
                  labelText: CreateEmployeeScreenStrings.branchLabel,
                  hintText: CreateEmployeeScreenStrings.branchHint,
                  border: OutlineInputBorder(),
                ),
                items: _branchOptions
                    .map(
                      (b) => DropdownMenuItem<String>(
                        value: b.id,
                        child: Text(b.name),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedBranchId = v),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Seleccione sucursal' : null,
              ),
              16.spaceh,
              DropdownButtonFormField<String>(
                value: _selectedRoleId,
                decoration: const InputDecoration(
                  labelText: CreateEmployeeScreenStrings.roleLabel,
                  hintText: CreateEmployeeScreenStrings.roleHint,
                  border: OutlineInputBorder(),
                ),
                items: _roleOptions
                    .map(
                      (r) => DropdownMenuItem<String>(
                        value: r.id,
                        child: Text(
                            CreateEmployeeScreenStrings.roleDisplayName(r.name)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedRoleId = v),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Seleccione rol' : null,
              ),
              24.spaceh,
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _saving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar cambios'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
