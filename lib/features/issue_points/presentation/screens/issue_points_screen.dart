import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class IssuePointsScreen extends StatefulWidget {
  const IssuePointsScreen({super.key});

  @override
  State<IssuePointsScreen> createState() => _IssuePointsScreenState();
}

class _IssuePointsScreenState extends State<IssuePointsScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _voucherAmountController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  String _userName = 'Amderson Joaquin Moscol Sicha';
  String? _imagePath;

  @override
  void dispose() {
    _descriptionController.dispose();
    _voucherAmountController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;
    
    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0A2B7A)),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'Emitir puntos',
          style: TextStyle(
            color: Color(0xFF0A2B7A),
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User name field
            _buildTextField(
              label: 'Nombre del usuario',
              value: _userName,
              isEditable: false,
            ),
            const SizedBox(height: 20),
            // Amount fields row
            Row(
              children: [
                Expanded(
                  child: _buildAmountField(
                    label: 'Monto total del voucher',
                    controller: _voucherAmountController,
                    isActive: true,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildAmountField(
                    label: 'Puntos a emitir',
                    controller: _pointsController,
                    isActive: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Description field
            _buildDescriptionField(),
            const SizedBox(height: 20),
            // Upload receipt button
            _buildUploadButton(),
            const SizedBox(height: 20),
            // Image preview if uploaded
            if (_imagePath != null) _buildImagePreview(),
            const SizedBox(height: 40),
            // Submit button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    bool isEditable = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFC6C6C6),
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: 'Figtree',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF696969),
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: 'Figtree',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField({
    required String label,
    required TextEditingController controller,
    required bool isActive,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withOpacity(0.64)
            : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(10),
        border: isActive
            ? Border.all(color: const Color(0xFF0A2B7A), width: 1)
            : null,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFC6C6C6),
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: 'Figtree',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            style: TextStyle(
              color: isActive ? const Color(0xFF00114A) : const Color(0xFF696969),
              fontSize: 23,
              fontWeight: FontWeight.normal,
              fontFamily: 'Figtree',
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '0',
            ),
            onChanged: (value) {
              // Calculate points based on voucher amount
              if (isActive && value.isNotEmpty) {
                final amount = double.tryParse(value) ?? 0;
                _pointsController.text = amount.toStringAsFixed(0);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.64),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF0A2B7A), width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descripción',
            style: TextStyle(
              color: Color(0xFFC6C6C6),
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: 'Figtree',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            style: const TextStyle(
              color: Color(0xFF00114A),
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: 'Figtree',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Agrega un comentario',
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement image picker
        setState(() {
          _imagePath = 'placeholder';
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD3F0FE),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
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
              'Subir comprobante',
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
    );
  }

  Widget _buildImagePreview() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 330,
            height: 440,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 50),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              setState(() {
                _imagePath = null;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFD3F0FE),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_a_photo_outlined,
                    color: Color(0xFF00114A),
                    size: 35,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Tomar nuevamente',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Navigate to success screen
          // context.router.push(const IssuePointsSuccessRoute());
          // Navigate to success screen - route will be available after build_runner
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF66CFFF),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_back,
              color: Color(0xFF051858),
              size: 20,
            ),
            const SizedBox(width: 10),
            const Text(
              'Emitir puntos',
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
    );
  }
}
