import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/models/models.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/core/services/services.dart';
import 'package:partners/main.dart';

@RoutePage()
class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showQrOptionsSheet(context));
  }

  void _showQrOptionsSheet(BuildContext context) {
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.appColor.primary.withValues(alpha: 0.85),
      builder: (ctx) => _QrOptionsSheetContent(
        onClose: () => Navigator.of(ctx).pop(),
        onSelectPremio: () {
          Navigator.of(ctx).pop();
          _navigateToScanIfAllowed(context);
        },
        onSelectCupon: () {
          Navigator.of(ctx).pop();
          _navigateToScanIfAllowed(context);
        },
      ),
    );
  }

  void _navigateToScanIfAllowed(BuildContext context) {
    final roleService = getIt<RoleService>();
    if (roleService.hasPermission(Permission.emitPoints)) {
      context.router.push(const QrScanRoute());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No tiene permiso para escanear códigos QR'),
          backgroundColor: context.appColor.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColor.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'QR Code',
          style: TextStyle(
            color: context.appColor.onPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _showQrOptionsSheet(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColor.secondary,
                foregroundColor: context.appColor.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text('Escanear QR'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrOptionsSheetContent extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSelectPremio;
  final VoidCallback onSelectCupon;

  const _QrOptionsSheetContent({
    required this.onClose,
    required this.onSelectPremio,
    required this.onSelectCupon,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: context.appColor.primary),
                  onPressed: onClose,
                ),
              ),
              Text(
                '¿Qué va a canjear?',
                style: TextStyle(
                  color: context.appColor.onSurface,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Figtree',
                ),
                textAlign: TextAlign.center,
              ),
              24.spaceh,
              _OptionTile(
                icon: Icons.card_giftcard,
                label: 'Canjear un premio',
                onTap: onSelectPremio,
              ),
              16.spaceh,
              _OptionTile(
                icon: Icons.discount,
                label: 'Canjear un cupón',
                onTap: onSelectCupon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Icon(icon, color: context.appColor.primary, size: 28),
              16.spacew,
              Text(
                label,
                style: TextStyle(
                  color: context.appColor.onSurface,
                  fontSize: 23,
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
}
