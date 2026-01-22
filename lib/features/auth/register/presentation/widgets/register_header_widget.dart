import 'package:flutter/material.dart';

/// Widget de header para pantallas de registro
class RegisterHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;

  const RegisterHeaderWidget({
    super.key,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: null,
      automaticallyImplyLeading: false,
      titleSpacing: 24,
      title: GestureDetector(
        onTap: onBackPressed ?? () => Navigator.of(context).pop(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(
              Icons.arrow_back,
              color: const Color(0xFF051858),
              size: 20,
            ),
            Text(
              'Regresar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF051858),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
