import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/models/models.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/core/services/services.dart';
import 'package:partners/features/branches/domain/domain.dart';
import 'package:partners/features/branches/presentation/screens/branches_screen_strings.dart';
import 'package:partners/main.dart';

/// Card de una sucursal en la lista (imagen, nombre, dirección, teléfono, horario, trabajadores).
/// Si la sucursal no está activa se muestra con estilo desactivado. Tap navega al detalle.
class BranchCardWidget extends StatelessWidget {
  const BranchCardWidget({super.key, required this.branch});

  final BranchEntity branch;

  static const double _imageHeight = 141;
  static const double _cardRadius = 20;

  @override
  Widget build(BuildContext context) {
    final roleService = getIt<RoleService>();
    final canEdit = roleService.hasPermission(Permission.updateBranches);
    final isActive = branch.isActive;

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: isActive
            ? null
            : Border.all(
                color: context.appColor.outline.withValues(alpha: 0.4),
                width: 1,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(context, canEdit),
          _buildContentSection(context),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.router.push(BranchDetailRoute(branchId: branch.id)),
        borderRadius: BorderRadius.circular(_cardRadius),
        child: Opacity(
          opacity: isActive ? 1.0 : 0.75,
          child: card,
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, bool canEdit) {
    return Stack(
      children: [
        Container(
          height: _imageHeight,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(_cardRadius),
              topRight: Radius.circular(_cardRadius),
            ),
          ),
          child: branch.imageUrl == null || branch.imageUrl!.isEmpty
              ? const Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Color(0xFF9CA3AF),
                  ),
                )
              : Image.network(
                  branch.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: _imageHeight,
                ),
        ),
        if (canEdit) _buildEditButton(context),
        _buildWorkersBadge(context),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Positioned(
      left: 18,
      bottom: 76,
      child: GestureDetector(
        onTap: () {
          // TODO: context.router.push(EditBranchRoute(branchId: branch.id));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit, color: context.appColor.primary, size: 24),
              10.spacew,
              Text(
                BranchesScreenStrings.editButton,
                style: TextStyle(
                  color: context.appColor.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Figtree',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkersBadge(BuildContext context) {
    return Positioned(
      right: 18,
      top: 95,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 19,
            height: 19,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 12,
              color: Color(0xFF00114A),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${branch.workers}',
            style: TextStyle(
              color: context.appColor.onPrimary,
              fontSize: 23,
              fontWeight: FontWeight.w500,
              fontFamily: 'Figtree',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    final textStyle = TextStyle(
      color: context.appColor.onSurface,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontFamily: 'Figtree',
    );
    final titleStyle = TextStyle(
      color: context.appColor.onSurface,
      fontSize: 23,
      fontWeight: FontWeight.w600,
      fontFamily: 'Figtree',
    );

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              branch.name,
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          20.spacew,
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 23,
                      color: context.appColor.onSurface,
                    ),
                    7.spacew,
                    Expanded(
                      child: Text(branch.address, style: textStyle),
                    ),
                  ],
                ),
                12.spaceh,
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 24,
                      color: context.appColor.onSurface,
                    ),
                    7.spacew,
                    Text(branch.phone, style: textStyle),
                  ],
                ),
                12.spaceh,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 21,
                      color: context.appColor.onSurface,
                    ),
                    7.spacew,
                    Expanded(
                      child: Text(
                        branch.schedule.isEmpty ? '—' : branch.schedule,
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
