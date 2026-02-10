import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/routes/app_routes.gr.dart';

@RoutePage()
class CreateBranchScreen extends StatefulWidget {
  const CreateBranchScreen({super.key});

  @override
  State<CreateBranchScreen> createState() => _CreateBranchScreenState();
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2B69),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: Color(0xFFD3F0FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF0F2B69),
              size: 20,
            ),
          ),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'Crear nueva sucursal',
          style: TextStyle(
            color: Color(0xFF0F2B69),
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Upload banner button
            _buildUploadBannerButton(),
            const SizedBox(height: 20),
            // Branch name field
            _buildTextField(
              label: 'Nombre de la sucursal',
              hint: 'Ingresa el nombre',
              controller: _nameController,
            ),
            const SizedBox(height: 20),
            // Category field
            _buildSelectField(
              label: 'Categoría de la sucursal',
              hint: 'Elige una categoría',
              value: _selectedCategory,
              onTap: () {
                context.router.push(const SelectCategoryRoute());
              },
            ),
            const SizedBox(height: 20),
            // Sub-category field
            _buildSelectField(
              label: 'Sub categoría de la sucursal',
              hint: 'Elige una sub categoría',
              value: _selectedSubCategory,
              onTap: () {
                context.router.push(const SelectSubCategoryRoute());
              },
              enabled: _selectedCategory != null,
            ),
            const SizedBox(height: 20),
            // Phone field
            _buildPhoneField(),
            const SizedBox(height: 20),
            // Schedule field
            _buildSelectField(
              label: 'Horario de la sucursal',
              hint: 'Configure horario disponible',
              value: _selectedSchedule,
              onTap: () {
                context.router.push(const ConfigureScheduleRoute());
              },
              icon: Icons.access_time,
            ),
            const SizedBox(height: 20),
            // Workers field
            _buildSelectField(
              label: 'Trabajadores de la sucursal',
              hint: 'Agrega trabajadores',
              value: null,
              onTap: () {
                context.router.push(const AddWorkersRoute());
              },
            ),
            const SizedBox(height: 20),
            // Location section with map
            _buildLocationSection(),
            const SizedBox(height: 40),
            // Create button
            _buildCreateButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBannerButton() {
    return Container(
      height: 77,
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
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Figtree',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 77,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF0A2B7A),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              color: Color(0xFF051858),
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: 'Figtree',
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF051858),
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontFamily: 'Figtree',
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 38,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectField({
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
            color: enabled ? Colors.black : const Color(0xFFC6C6C6),
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Figtree',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 77,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF0A2B7A),
              width: 1,
            ),
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
                              ? const Color(0xFF051858)
                              : enabled
                                  ? const Color(0xFF051858)
                                  : const Color(0xFFC6C6C6),
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ),
                    if (icon != null)
                      Icon(
                        icon,
                        color: const Color(0xFF051858),
                        size: 24,
                      )
                    else
                      Icon(
                        Icons.arrow_drop_down,
                        color: enabled
                            ? const Color(0xFF00114A)
                            : const Color(0xFFC6C6C6),
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contacto telefónico',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.normal,
            fontFamily: 'Figtree',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 77,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF0A2B7A),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 26),
                child: Text(
                  '+51 ',
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: Color(0xFF051858),
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Ingresa el número',
                    hintStyle: TextStyle(
                      color: Color(0xFF051858),
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Figtree',
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 38,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 77,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF0A2B7A),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 26,
              vertical: 38,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ubicación de la sucursal',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Figtree',
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _addressController,
                        style: const TextStyle(
                          color: Color(0xFF051858),
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Figtree',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Ingresa la dirección exacta',
                          hintStyle: TextStyle(
                            color: Color(0xFF051858),
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Figtree',
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Map placeholder
        Container(
          height: 321,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF66CFFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  width: 37,
                  height: 37,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.zoom_out_map,
                    color: Color(0xFF051858),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF66CFFF),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implementar lógica de creación
            context.router.pop();
          },
          borderRadius: BorderRadius.circular(50),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward,
                color: Color(0xFF051858),
                size: 22,
              ),
              SizedBox(width: 20),
              Text(
                'Crear nueva sucursal',
                style: TextStyle(
                  color: Color(0xFF051858),
                  fontSize: 18,
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

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 131,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD3F0FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF0F2B69),
                    size: 20,
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
              },
            ),
            const SizedBox(height: 20),
            _buildImageOption(
              icon: Icons.photo_library,
              title: 'Subir foto de galería',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar galería
              },
            ),
            const SizedBox(height: 20),
          ],
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
