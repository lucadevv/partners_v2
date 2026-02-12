import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';

/// AppBar de la pantalla Crear sucursal (título + botón atrás).
class CreateBranchScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CreateBranchScreenAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: DecoratedBox(
          decoration: BoxDecoration(
            color: context.appColor.surface,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: 35,
            height: 35,
            child: Icon(
              Icons.arrow_back,
              color: context.appColor.primary,
              size: 20,
            ),
          ),
        ),
        onPressed: () => context.router.pop(),
      ),
      title: Text(
        CreateBranchScreenStrings.appBarTitle,
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
