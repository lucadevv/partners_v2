import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/features/branches/presentation/presentation.dart';

@RoutePage()
class CreateBranchScreen extends StatefulWidget {
  const CreateBranchScreen({super.key});

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();
}

class _CreateBranchScreenState extends State<CreateBranchScreen> {
  late CreateBranchFormNotifier _formNotifier;

  @override
  void initState() {
    super.initState();
    _formNotifier = CreateBranchFormNotifier();
  }

  @override
  void dispose() {
    _formNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColor.surface,
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 35,
              height: 35,
              child: Icon(
                Icons.arrow_back,
                color: context.appColor.primary,
                size: 20,
              ),
            ),
          ),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'Crear nueva sucursal',
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _formNotifier,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                20.spaceh,
                // Upload banner button
                _buildUploadBannerButton(),
                20.spaceh,
                BranchFieldWidget(
                  field: _formNotifier.nameField,
                  controller: _formNotifier.nameController,
                  errorText: _formNotifier.nameError,
                ),
                20.spaceh,
                _buildSelectField(
                  context,
                  label: 'Categoría de la sucursal',
                  hint: 'Elige una categoría',
                  value: _formNotifier.selectedCategory,
                  onTap: () {
                    context.router.push(const SelectCategoryRoute());
                  },
                ),
                20.spaceh,
                _buildSelectField(
                  context,
                  label: 'Sub categoría de la sucursal',
                  hint: 'Elige una sub categoría',
                  value: _formNotifier.selectedSubCategory,
                  onTap: () {
                    context.router.push(const SelectSubCategoryRoute());
                  },
                  enabled: _formNotifier.selectedCategory != null,
                ),
                20.spaceh,
                BranchPhoneFieldWidget(
                  field: _formNotifier.phoneField,
                  controller: _formNotifier.phoneController,
                  errorText: _formNotifier.phoneError,
                ),
                20.spaceh,
                _buildSelectField(
                  context,
                  label: 'Horario de la sucursal',
                  hint: 'Configure horario disponible',
                  value: _formNotifier.selectedSchedule,
                  onTap: () {
                    context.router.push(const ConfigureScheduleRoute());
                  },
                  icon: Icons.access_time,
                ),
                20.spaceh,
                _buildSelectField(
                  context,
                  label: 'Trabajadores de la sucursal',
                  hint: 'Agrega trabajadores',
                  value: null,
                  onTap: () {
                    context.router.push(const AddWorkersRoute());
                  },
                ),
                20.spaceh,
                BranchFieldWidget(
                  field: _formNotifier.addressField,
                  controller: _formNotifier.addressController,
                  errorText: _formNotifier.addressError,
                ),
                20.spaceh,
                _buildLocationSection(),
                40.spaceh,
                _buildCreateButton(context),
                40.spaceh,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadBannerButton() {
    return SizedBox(
      height: 77,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFD3F0FE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _showImageSourceBottomSheet();
            },
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_a_photo_outlined,
                  color: Color(0xFF00114A),
                  size: 35,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Subir banner',
                  style: TextStyle(
                    color: Color(0xFF00114A),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectField(
    BuildContext context, {
    required String label,
    required String hint,
    String? value,
    required VoidCallback onTap,
    IconData? icon,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: enabled
                ? context.appColor.onSurface
                : const Color(0xFFC6C6C6),
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Figtree',
          ),
        ),
        8.spaceh,
        SizedBox(
          height: 77,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.appColor.primary, width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled ? onTap : null,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 38,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          value ?? hint,
                          style: TextStyle(
                            color: value != null
                                ? context.appColor.primary
                                : enabled
                                ? context.appColor.primary
                                : const Color(0xFFC6C6C6),
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ),
                      if (icon != null)
                        Icon(icon, color: context.appColor.primary, size: 24)
                      else
                        Icon(
                          Icons.arrow_drop_down,
                          color: enabled
                              ? context.appColor.primary
                              : const Color(0xFFC6C6C6),
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address field (desde Domain config) - ya está en el body, pero lo movemos aquí si es necesario
        // O podemos mantenerlo arriba y solo mostrar el mapa aquí
        20.spaceh,
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Builder(
            builder: (context) {
              return SizedBox(
                height: 321,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: context.appColor.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 46,
                              height: 46,
                              child: Icon(
                                Icons.location_on,
                                color: context.appColor.onPrimary,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 37,
                          height: 37,
                          child: Icon(
                            Icons.zoom_out_map,
                            color: context.appColor.primary,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    final enabled = _formNotifier.isFormComplete;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.appColor.primary,
                    context.appColor.secondary,
                  ],
                )
              : null,
          color: enabled ? null : const Color(0xFFC6C6C6),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled
                ? () {
                    // TODO: Implementar lógica de creación
                    context.router.pop();
                  }
                : null,
            borderRadius: BorderRadius.circular(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: enabled
                      ? context.appColor.primary
                      : const Color(0xFF9CA3AF),
                  size: 22,
                ),
                20.spacew,
                Text(
                  'Crear nueva sucursal',
                  style: TextStyle(
                    color: enabled
                        ? context.appColor.primary
                        : const Color(0xFF9CA3AF),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SizedBox(width: 131, height: 5),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xFFD3F0FE),
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(
                      width: 35,
                      height: 35,
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xFF0F2B69),
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Elige una opción',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ),
                  const SizedBox(width: 35),
                ],
              ),
              const SizedBox(height: 30),
              _buildImageOption(
                icon: Icons.camera_alt,
                title: 'Tomar foto con cámara',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implementar cámara
                  _formNotifier.setImagePath('placeholder');
                },
              ),
              const SizedBox(height: 20),
              _buildImageOption(
                icon: Icons.photo_library,
                title: 'Subir foto de galería',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implementar galería
                  _formNotifier.setImagePath('placeholder');
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Icon(icon, size: 27, color: Colors.black),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Figtree',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
