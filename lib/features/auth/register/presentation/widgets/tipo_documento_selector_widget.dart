import 'package:flutter/material.dart';
import 'package:partners/core/utils/enums/enums.dart';

/// Widget selector de tipo de documento para representante legal (RUC 20)
class DocumentTypeSelectorWidget extends StatelessWidget {
  final DocumentType? selectType;
  final Function(DocumentType) onTypeSelected;

  const DocumentTypeSelectorWidget({
    super.key,
    required this.selectType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0A2B7A), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Text(
                    'Tipo de documento',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    _getLabelForTipo(selectType),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF051858),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: const Color(0xFF051858),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  String _getLabelForTipo(DocumentType? type) {
    if (type == null) {
      return 'Seleccione tipo de documento';
    }
    return switch (type) {
      DocumentType.dni => 'DNI del representante legal',
      DocumentType.ce => 'CE del representante legal',
    };
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF051858),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Opciones a elegir',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF00114A),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 24),
                _buildOption(context, DocumentType.dni, 'DNI'),
                SizedBox(height: 16),
                _buildOption(context, DocumentType.ce, 'CE'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, DocumentType tipo, String label) {
    final bool isSelected = selectType == tipo;

    return GestureDetector(
      onTap: () {
        onTypeSelected(tipo);
        Navigator.of(context).pop();
      },
      child: Row(
        children: [
          Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF051858) : Colors.transparent,
              border: Border.all(color: const Color(0xFF051858), width: 1),
            ),
          ),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF051858),
            ),
          ),
        ],
      ),
    );
  }
}
