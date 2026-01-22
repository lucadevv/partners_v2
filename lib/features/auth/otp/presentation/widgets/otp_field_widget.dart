import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget de campo OTP individual
class OtpFieldWidget extends StatelessWidget {
  final bool isFilled;
  final bool isFocused;
  final String value;

  const OtpFieldWidget({
    super.key,
    this.isFilled = false,
    this.isFocused = false,
    this.value = '',
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isFocused || isFilled
        ? const Color(0xFF66CFFF)
        : const Color(0xFF0A2B7A);
    final double borderWidth = isFocused || isFilled ? 2 : 1;

    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF051858),
          ),
        ),
      ),
    );
  }
}

/// Widget de fila de campos OTP
class OtpFieldsRowWidget extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpFieldsRowWidget({
    super.key,
    this.length = 5,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpFieldsRowWidget> createState() => _OtpFieldsRowWidgetState();
}

class _OtpFieldsRowWidgetState extends State<OtpFieldsRowWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _code = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode(),
    );

    // Auto focus en el primer campo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      _controllers[index].text = value[value.length - 1];

      // Mover al siguiente campo si existe
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    // Construir el código completo
    _code = _controllers.map((c) => c.text).join();

    if (widget.onChanged != null) {
      widget.onChanged!(_code);
    }

    // Si todos los campos están llenos, llamar onCompleted
    if (_code.length == widget.length) {
      widget.onCompleted(_code);
    }

    setState(() {});
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _onKeyEvent(index, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF051858),
              ),
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _controllers[index].text.isNotEmpty
                        ? const Color(0xFF66CFFF)
                        : const Color(0xFF0A2B7A),
                    width: _controllers[index].text.isNotEmpty ? 2 : 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _controllers[index].text.isNotEmpty
                        ? const Color(0xFF66CFFF)
                        : const Color(0xFF0A2B7A),
                    width: _controllers[index].text.isNotEmpty ? 2 : 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFF66CFFF),
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) => _onChanged(index, value),
            ),
          ),
        );
      }),
    );
  }
}
