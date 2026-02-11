import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/features/issue_points/presentation/presentation.dart';

@RoutePage()
class IssuePointsScreen extends StatefulWidget {
  const IssuePointsScreen({super.key});

  @override
  State<IssuePointsScreen> createState() => _IssuePointsScreenState();
}

class _IssuePointsScreenState extends State<IssuePointsScreen> {
  late IssuePointsFormNotifier _formNotifier;

  @override
  void initState() {
    super.initState();
    _formNotifier = IssuePointsFormNotifier(
      userName: 'Amderson Joaquin Moscol Sicha',
    );
  }

  @override
  void dispose() {
    _formNotifier.dispose();
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
      body: ListenableBuilder(
        listenable: _formNotifier,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name field (read-only)
                IssuePointsFieldWidget(
                  field: _formNotifier.userNameField,
                  value: _formNotifier.userName,
                ),
                const SizedBox(height: 20),
                // Amount fields row
                Row(
                  children: [
                    Expanded(
                      child: IssuePointsFieldWidget(
                        field: _formNotifier.voucherAmountField,
                        controller: _formNotifier.voucherAmountController,
                        errorText: _formNotifier.voucherAmountError,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: IssuePointsFieldWidget(
                        field: _formNotifier.pointsField,
                        controller: _formNotifier.pointsController,
                        errorText: _formNotifier.pointsError,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Description field
                IssuePointsFieldWidget(
                  field: _formNotifier.descriptionField,
                  controller: _formNotifier.descriptionController,
                  errorText: _formNotifier.descriptionError,
                ),
                const SizedBox(height: 20),
                // Upload receipt button
                _buildUploadButton(),
                const SizedBox(height: 20),
                // Image preview if uploaded
                if (_formNotifier.imagePath != null) _buildImagePreview(),
                const SizedBox(height: 40),
                // Submit button
                _buildSubmitButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement image picker
        _formNotifier.setImagePath('placeholder');
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFD3F0FE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
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
      ),
    );
  }

  Widget _buildImagePreview() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const SizedBox(
                width: 330,
                height: 440,
                child: Center(child: Icon(Icons.image, size: 50)),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _formNotifier.clearImage();
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFD3F0FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _formNotifier.isFormComplete
            ? () {
                // TODO: Navigate to success screen
                // context.router.push(const IssuePointsSuccessRoute());
                // Navigate to success screen - route will be available after build_runner
              }
            : null,
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
            const Icon(Icons.arrow_back, color: Color(0xFF051858), size: 20),
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
