import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/employees/domain/domain.dart';
import 'package:partners/features/employees/presentation/cubit/create_employee_cubit.dart';
import 'package:partners/features/employees/presentation/cubit/create_employee_state.dart';
import 'package:partners/features/employees/presentation/screens/create_employee_screen_strings.dart';
import 'package:partners/features/employees/presentation/widgets/create_employee_photo_section.dart';
import 'package:partners/main.dart';

@RoutePage()
class CreateEmployeeScreen extends StatefulWidget implements AutoRouteWrapper {
  const CreateEmployeeScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<CreateEmployeeCubit>(
      create: (_) => getIt<CreateEmployeeCubit>()..loadOptions(),
      child: this,
    );
  }

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  String? _selectedBranchId;
  String? _selectedRoleId;
  String? _photoPath;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBranchId == null || _selectedBranchId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(CreateEmployeeScreenStrings.selectBranch)),
      );
      return;
    }
    if (_selectedRoleId == null || _selectedRoleId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(CreateEmployeeScreenStrings.selectRole)),
      );
      return;
    }
    if (_photoPath == null || _photoPath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(CreateEmployeeScreenStrings.photoRequired)),
      );
      return;
    }
    final params = CreateEmployeeParams(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      branchId: _selectedBranchId!,
      roleId: _selectedRoleId!,
      photoPath: _photoPath,
    );
    context.read<CreateEmployeeCubit>().createEmployee(params);
  }

  @override
  Widget build(BuildContext context) {
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
          CreateEmployeeScreenStrings.appBarTitle,
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<CreateEmployeeCubit, CreateEmployeeState>(
        listener: (context, state) {
          if (state.status == CreateEmployeeStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.successMessage ??
                      CreateEmployeeScreenStrings.successMessage,
                ),
              ),
            );
            context.read<CreateEmployeeCubit>().reset();
            context.router.maybePop();
          }
          if (state.status == CreateEmployeeStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocConsumer<CreateEmployeeCubit, CreateEmployeeState>(
          listenWhen: (p, c) =>
              p.optionsLoading != c.optionsLoading ||
              p.branchOptions != c.branchOptions ||
              p.roleOptions != c.roleOptions,
          listener: (context, state) {
            if (!state.optionsLoading &&
                state.branchOptions.isNotEmpty &&
                _selectedBranchId == null) {
              setState(() => _selectedBranchId = state.branchOptions.first.id);
            }
            if (!state.optionsLoading &&
                state.roleOptions.isNotEmpty &&
                _selectedRoleId == null) {
              setState(() => _selectedRoleId = state.roleOptions.first.id);
            }
          },
          builder: (context, state) {
            if (state.optionsLoading && state.branchOptions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CreateEmployeePhotoSection(
                      imagePath: _photoPath,
                      onPathChanged: (path) =>
                          setState(() => _photoPath = path),
                    ),
                    16.spaceh,
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
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: CreateEmployeeScreenStrings.passwordLabel,
                        hintText: CreateEmployeeScreenStrings.passwordHint,
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
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
                    DropdownButtonFormField<String>(
                      value: _selectedBranchId,
                      decoration: const InputDecoration(
                        labelText: CreateEmployeeScreenStrings.branchLabel,
                        hintText: CreateEmployeeScreenStrings.branchHint,
                        border: OutlineInputBorder(),
                      ),
                      items: state.branchOptions
                          .map(
                            (b) => DropdownMenuItem<String>(
                              value: b.id,
                              child: Text(b.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedBranchId = v),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Seleccione sucursal'
                          : null,
                    ),
                    16.spaceh,
                    DropdownButtonFormField<String>(
                      value: _selectedRoleId,
                      decoration: const InputDecoration(
                        labelText: CreateEmployeeScreenStrings.roleLabel,
                        hintText: CreateEmployeeScreenStrings.roleHint,
                        border: OutlineInputBorder(),
                      ),
                      items: state.roleOptions
                          .map(
                            (r) => DropdownMenuItem<String>(
                              value: r.id,
                              child: Text(
                                CreateEmployeeScreenStrings.roleDisplayName(
                                  r.name,
                                ),
                              ),
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
                        onPressed: state.status == CreateEmployeeStatus.loading
                            ? null
                            : () => _submit(context),
                        child: state.status == CreateEmployeeStatus.loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                CreateEmployeeScreenStrings.submitButton,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
