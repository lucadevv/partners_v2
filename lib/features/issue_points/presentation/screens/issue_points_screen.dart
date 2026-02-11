import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/features/issue_points/presentation/presentation.dart';

@RoutePage()
class IssuePointsScreen extends StatefulWidget {
  const IssuePointsScreen({super.key});

  @override
  State<IssuePointsScreen> createState() => _IssuePointsScreenState();
}

class _IssuePointsScreenState extends State<IssuePointsScreen> {
  late IssuePointsFormNotifier _formNotifier;
  final ImagePicker _imagePicker = ImagePicker();

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

  Future<void> _pickImageFromCamera() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (!mounted) return;
    if (file != null && file.path.isNotEmpty) {
      _formNotifier.setImagePath(file.path);
    }
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
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'Emitir puntos',
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IssuePointsFieldWidget(
                  field: _formNotifier.userNameField,
                  value: _formNotifier.userName,
                ),
                20.spaceh,
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
                    20.spacew,
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
                20.spaceh,
                IssuePointsFieldWidget(
                  field: _formNotifier.descriptionField,
                  controller: _formNotifier.descriptionController,
                  errorText: _formNotifier.descriptionError,
                ),
                20.spaceh,
                _buildUploadButton(context),
                20.spaceh,
                if (_formNotifier.imagePath != null) _buildImagePreview(context),
                40.spaceh,
                _buildSubmitButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return GestureDetector(
      onTap: _pickImageFromCamera,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.appColor.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                color: context.appColor.primary,
                size: 35,
              ),
              10.spacew,
              Text(
                'Subir comprobante',
                style: TextStyle(
                  color: context.appColor.primary,
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

  Widget _buildImagePreview(BuildContext context) {
    final path = _formNotifier.imagePath!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 330,
                height: 440,
                child: File(path).existsSync()
                    ? Image.file(
                        File(path),
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: context.appColor.onSurfaceVariant,
                        ),
                      ),
              ),
            ),
            20.spaceh,
            GestureDetector(
              onTap: _pickImageFromCamera,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.appColor.surface,
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
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: context.appColor.primary,
                        size: 35,
                      ),
                      10.spacew,
                      Text(
                        'Tomar nuevamente',
                        style: TextStyle(
                          color: context.appColor.onSurface,
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

  Widget _buildSubmitButton(BuildContext context) {
    final enabled = _formNotifier.isFormComplete;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: enabled ? context.appColor.secondary : context.appColor.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled
                ? () {
                    context.router.push(const IssuePointsSuccessRoute());
                  }
                : null,
            borderRadius: BorderRadius.circular(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: enabled ? context.appColor.primary : context.appColor.onSurfaceVariant,
                  size: 20,
                ),
                10.spacew,
                Text(
                  'Emitir puntos',
                  style: TextStyle(
                    color: enabled ? context.appColor.primary : context.appColor.onSurfaceVariant,
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
}
