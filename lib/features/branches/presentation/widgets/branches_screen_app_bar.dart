import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/branches/presentation/screens/branches_screen_strings.dart';

/// AppBar de la pantalla Mis sucursales.
class BranchesScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BranchesScreenAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: context.appColor.primary),
        onPressed: () => context.router.pop(),
      ),
      title: Text(
        BranchesScreenStrings.appBarTitle,
        style: TextStyle(
          color: context.appColor.primary,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          fontFamily: 'Figtree',
        ),
      ),
      centerTitle: true,
    );
  }
}
