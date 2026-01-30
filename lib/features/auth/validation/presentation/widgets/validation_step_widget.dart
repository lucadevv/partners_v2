import 'package:flutter/material.dart';
import 'package:partners/core/extension/context_extension.dart';
import 'package:partners/core/utils/enums/enums.dart';

class ValidationStepWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final ItemValidationState state;

  const ValidationStepWidget({
    super.key,
    required this.text,
    this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Solo permitir tap si el paso está en estado pending
    final canTap = state == ItemValidationState.pending;
    final chechBox = state == ItemValidationState.completed;

    return GestureDetector(
      onTap: canTap ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
        decoration: BoxDecoration(
          color: _getStateColor(context),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: _getStateBorderColor(context)!, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              chechBox
                  ? Icons.check_circle_outline_outlined
                  : Icons.arrow_forward_outlined,
              color: _getStateTextColor(context),
              size: 31,
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Figtree',
                  height: 1.22,
                  color: _getStateTextColor(context),
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getStateColor(BuildContext context) {
    switch (state) {
      case ItemValidationState.initial:
        return context.appColor.surface;
      case ItemValidationState.pending:
        return context.appColor.secondary;
      case ItemValidationState.completed:
        return context.appColor.tertiary;
    }
  }

  Color? _getStateBorderColor(BuildContext context) {
    switch (state) {
      case ItemValidationState.initial:
        return context.appColor.tertiary;
      case ItemValidationState.pending:
        return context.appColor.secondary;
      case ItemValidationState.completed:
        return context.appColor.tertiary;
    }
  }

  Color? _getStateTextColor(BuildContext context) {
    switch (state) {
      case ItemValidationState.initial:
        return context.appColor.tertiary;
      case ItemValidationState.pending:
        return context.appColor.tertiary;
      case ItemValidationState.completed:
        return context.appColor.surface;
    }
  }
}
