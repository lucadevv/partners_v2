import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/features/auth/validation/presentation/cubit/business/business_validation_cubit.dart';

class BusinessValidationWidget extends StatefulWidget {
  const BusinessValidationWidget({super.key});

  @override
  State<BusinessValidationWidget> createState() =>
      _BusinessValidationWidgetState();
}

class _BusinessValidationWidgetState
    extends State<BusinessValidationWidget> {
  File? _selectedFile;
  bool _isPickingFile = false;

  Future<void> _pickFile() async {
    try {
      setState(() => _isPickingFile = true);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSizeInBytes = await file.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 5) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El archivo debe ser menor a 5MB'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isPickingFile = false;
            _selectedFile = null;
          });
          return;
        }

        setState(() {
          _selectedFile = file;
          _isPickingFile = false;
        });
      } else {
        setState(() => _isPickingFile = false);
      }
    } catch (e) {
      setState(() => _isPickingFile = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar archivo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleFileSelection() async {
    if (_selectedFile == null) {
      await _pickFile();
    } else {
      context.read<BusinessValidationCubit>().validateBusiness(_selectedFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = context.router;
    return BlocConsumer<BusinessValidationCubit, BusinessValidationState>(
      listener: (BuildContext context, BusinessValidationState state) {
        if (state.status == BusinessValidationStatus.success) {
          context.read<BusinessValidationCubit>().resetState();
          router.pop(true);
        }
        if (state.status == BusinessValidationStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, cubitState) {
        final isLoading =
            cubitState.status == BusinessValidationStatus.loading ||
            _isPickingFile;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                Text(
                  'Tiene que subir la FICHA RUC que se descarga gratis en la SUNAT',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Figtree',
                    height: 1.83,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_selectedFile != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          color: const Color(0xFF051858),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedFile!.path.split('/').last,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF051858),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _selectedFile = null;
                                  });
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                bottom: 0,
              ),
              child: ElevatedButton(
                onPressed: !isLoading ? _handleFileSelection : null,
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12,
                        children: [
                          Icon(Icons.arrow_forward, size: 20),
                          Text(
                            _selectedFile == null
                                ? "Subir ficha RUC PDF"
                                : "Subir ficha RUC PDF",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
