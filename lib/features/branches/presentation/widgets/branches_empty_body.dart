import 'package:flutter/material.dart';
import 'package:partners/features/branches/presentation/screens/branches_screen_strings.dart';

/// Cuerpo de la pantalla Mis sucursales cuando la lista está vacía.
class BranchesEmptyBody extends StatelessWidget {
  const BranchesEmptyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(BranchesScreenStrings.emptyMessage),
    );
  }
}
