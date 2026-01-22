import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';

class TipoDocumentoBottomSheet extends StatelessWidget {
  final String? selectedValue;
  final Function(String?) onChanged;

  const TipoDocumentoBottomSheet({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  static void show({
    required BuildContext context,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return TipoDocumentoBottomSheet(
          selectedValue: selectedValue,
          onChanged: onChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColor.onPrimary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.black,
                ),
                Expanded(
                  child: Text(
                    'Opciones a elegir',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: context.appColor.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
          RadioGroup<String>(
            groupValue: selectedValue,
            onChanged: (String? value) {
              onChanged(value);
              Navigator.of(context).pop();
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text('DNI'),
                  value: 'DNI',
                  activeColor: context.appColor.primary,
                ),
                RadioListTile<String>(
                  title: Text('CE'),
                  value: 'CE',
                  activeColor: context.appColor.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
