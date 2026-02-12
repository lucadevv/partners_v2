import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/models/models.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/core/services/services.dart';
import 'package:partners/features/branches/presentation/screens/branches_screen_strings.dart';
import 'package:partners/main.dart';

/// FAB "Nueva sucursal" (solo visible si el rol tiene permiso createBranches o es superadmin).
class BranchesFab extends StatelessWidget {
  const BranchesFab({super.key});

  @override
  Widget build(BuildContext context) {
    final roleService = getIt<RoleService>();
    final canCreate = roleService.hasRole(UserRole.superadmin) ||
        roleService.hasPermission(Permission.createBranches);
    if (!canCreate) return const SizedBox.shrink();

    return SizedBox(
      width: 109,
      height: 109,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70.5),
          border: Border.all(color: context.appColor.secondary, width: 2),
          color: context.appColor.secondary,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.router.push(const CreateBranchRoute()),
            borderRadius: BorderRadius.circular(70.5),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.appColor.primary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: SizedBox(
                      width: 37,
                      height: 37,
                      child: Icon(
                        Icons.add,
                        color: context.appColor.onPrimary,
                        size: 17,
                      ),
                    ),
                  ),
                ),
                10.spaceh,
                Text(
                  BranchesScreenStrings.newBranchFab,
                  style: TextStyle(
                    color: context.appColor.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Figtree',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
