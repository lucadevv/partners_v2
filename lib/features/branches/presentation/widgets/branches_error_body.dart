import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/branches/presentation/screens/branches_screen_strings.dart';

/// Cuerpo de la pantalla Mis sucursales cuando hay error.
class BranchesErrorBody extends StatelessWidget {
  const BranchesErrorBody({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${BranchesScreenStrings.errorPrefix}${errorMessage ?? BranchesScreenStrings.unknownError}',
            style: TextStyle(color: context.appColor.error),
            textAlign: TextAlign.center,
          ),
          16.spaceh,
          ElevatedButton(
            onPressed: onRetry,
            child: const Text(BranchesScreenStrings.retryButton),
          ),
        ],
      ),
    );
  }
}
