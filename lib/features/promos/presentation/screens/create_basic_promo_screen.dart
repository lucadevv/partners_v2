import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/features/promos/presentation/presentation.dart';

@RoutePage()
class CreateBasicPromoScreen extends StatefulWidget {
  const CreateBasicPromoScreen({super.key});

  @override
  State<CreateBasicPromoScreen> createState() => _CreateBasicPromoScreenState();
}

class _CreateBasicPromoScreenState extends State<CreateBasicPromoScreen> {
  late CreateBasicPromoNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = CreateBasicPromoNotifier();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  void _openImageSourceSheet() {
    showPromoImageSourceBottomSheet(
      context,
      currentImagePath: _notifier.imagePath,
      onImageSelected: _notifier.setImagePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.appColor.primary),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'Promoción básica',
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _notifier,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleField(controller: _notifier.titleController),
                20.spaceh,
                _ObservationsField(controller: _notifier.observationsController),
                20.spaceh,
                _UploadImageBlock(
                  imagePath: _notifier.imagePath,
                  onTap: _openImageSourceSheet,
                ),
                20.spaceh,
                _CalcularAlcanceRow(
                  value: _notifier.scopeCount,
                  onTapView: () => context.router.push(
                    PromoMapRoute(scopeCount: _notifier.scopeCount),
                  ).then((_) {}),
                ),
                40.spaceh,
                _CrearPromocionButton(
                  enabled: _notifier.isFormValid,
                  onPressed: () {
                    // TODO: submit promo; then pop or navigate to list
                    context.router.popUntilRoot();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  final TextEditingController controller;

  const _TitleField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _FieldDecorator(
      label: 'Título de la promoción SMART (Máx ${CreateBasicPromoNotifier.maxTitleLength})',
      child: TextField(
        controller: controller,
        maxLength: CreateBasicPromoNotifier.maxTitleLength,
        style: TextStyle(
          color: context.appColor.primary,
          fontSize: 18,
          fontFamily: 'Figtree',
        ),
        decoration: InputDecoration(
          hintText: 'Ingrese un título',
          hintStyle: TextStyle(
            color: context.appColor.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 18,
          ),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}

class _ObservationsField extends StatelessWidget {
  final TextEditingController controller;

  const _ObservationsField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _FieldDecorator(
      label: 'Observaciones (Máx ${CreateBasicPromoNotifier.maxObservationsLength})',
      child: TextField(
        controller: controller,
        maxLength: CreateBasicPromoNotifier.maxObservationsLength,
        maxLines: 4,
        style: TextStyle(
          color: context.appColor.primary,
          fontSize: 18,
          fontFamily: 'Figtree',
        ),
        decoration: InputDecoration(
          hintText: 'Ingrese una descripción',
          hintStyle: TextStyle(
            color: context.appColor.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 18,
          ),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}

class _FieldDecorator extends StatelessWidget {
  final String label;
  final Widget child;

  const _FieldDecorator({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.appColor.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: context.appColor.onSurfaceVariant.withValues(alpha: 0.8),
                fontSize: 12,
                fontFamily: 'Figtree',
              ),
            ),
            8.spaceh,
            child,
          ],
        ),
      ),
    );
  }
}

class _UploadImageBlock extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const _UploadImageBlock({this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: hasImage
              ? context.appColor.secondary.withValues(alpha: 0.3)
              : context.appColor.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasImage)
                Icon(Icons.edit_outlined, color: context.appColor.primary, size: 24),
              if (hasImage) 12.spacew,
              Icon(
                Icons.add_a_photo_outlined,
                color: context.appColor.primary,
                size: 35,
              ),
              10.spacew,
              Text(
                hasImage ? 'Editar imagen o logotipo' : 'Subir imagen o logotipo',
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
}

class _CalcularAlcanceRow extends StatelessWidget {
  final int value;
  final VoidCallback onTapView;

  const _CalcularAlcanceRow({required this.value, required this.onTapView});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.appColor.primary),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calcular alcance',
                    style: TextStyle(
                      color: context.appColor.onSurfaceVariant.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  8.spaceh,
                  Text(
                    '$value',
                    style: TextStyle(
                      color: context.appColor.primary,
                      fontSize: 23,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        20.spacew,
        SizedBox(
          width: 64,
          height: 60,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.appColor.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTapView,
                borderRadius: BorderRadius.circular(50),
                child: Icon(
                  Icons.map_outlined,
                  color: context.appColor.primary,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CrearPromocionButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _CrearPromocionButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: enabled ? context.appColor.secondary : context.appColor.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: enabled ? context.appColor.primary : context.appColor.onSurfaceVariant,
                  size: 20,
                ),
                10.spacew,
                Text(
                  'Crear promoción',
                  style: TextStyle(
                    color: enabled ? context.appColor.primary : context.appColor.onSurfaceVariant,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
