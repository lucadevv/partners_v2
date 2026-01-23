import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:partners/core/extension/sizedbox_extension.dart';
import 'package:partners/features/auth/document_scan/domain/entities/document_ocr_entity.dart';
import 'package:partners/features/auth/document_scan/presentation/cubit/document_scan_cubit.dart';
import 'package:partners/features/auth/register/domain/entities/tipo_documento.dart';

@RoutePage()
class DocumentSuccessScreen extends StatelessWidget {
  const DocumentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentScanCubit, DocumentScanState>(
      builder: (context, state) {
        final ocrData = state.ocrData;

        return Scaffold(
          backgroundColor: const Color(0xFF051858),
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      14.spacew,
                      Text(
                        'Regresar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Success Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            Icons.check_circle,
                            size: 80,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        32.spaceh,
                        // Text
                        Text(
                          '¡Perfecto!\nSu documento ha sido validado',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        32.spaceh,
                        // Información del documento
                        if (ocrData != null) _buildDocumentInfo(ocrData),
                      ],
                    ),
                  ),
                ),

                // Continue Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      // Retornar true para indicar que el documento fue validado exitosamente
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66CFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      minimumSize: Size(double.infinity, 56),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          color: const Color(0xFF051858),
                          size: 20,
                        ),
                        Text(
                          'Continuar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF051858),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                24.spaceh,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentInfo(DocumentOcrEntity ocrData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del documento',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          20.spaceh,
          _buildInfoRow(
            'Tipo de documento',
            ocrData.tipoDocumento == TipoDocumento.dni
                ? 'DNI'
                : 'Carné de Extranjería',
          ),
          12.spaceh,
          _buildInfoRow('Número de documento', ocrData.numeroDocumento),
          if (ocrData.nombres != null && ocrData.nombres!.isNotEmpty) ...[
            12.spaceh,
            _buildInfoRow('Nombres', ocrData.nombres!),
          ],
          if (ocrData.apellidos != null && ocrData.apellidos!.isNotEmpty) ...[
            12.spaceh,
            _buildInfoRow('Apellidos', ocrData.apellidos!),
          ],
          if (ocrData.fechaNacimiento != null &&
              ocrData.fechaNacimiento!.isNotEmpty) ...[
            12.spaceh,
            _buildInfoRow('Fecha de nacimiento', ocrData.fechaNacimiento!),
          ],
          if (ocrData.digitoVerificador != null &&
              ocrData.digitoVerificador!.isNotEmpty) ...[
            12.spaceh,
            _buildInfoRow('Dígito verificador', ocrData.digitoVerificador!),
          ],
          20.spaceh,
          // Texto completo detectado (colapsable)
          ExpansionTile(
            title: Text(
              'Texto completo detectado',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            iconColor: Colors.white,
            collapsedIconColor: Colors.white70,
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ocrData.textoCompleto,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
