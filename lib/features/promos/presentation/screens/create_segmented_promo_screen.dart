import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/routes/routes.dart';

@RoutePage()
class CreateSegmentedPromoScreen extends StatefulWidget {
  const CreateSegmentedPromoScreen({super.key});

  @override
  State<CreateSegmentedPromoScreen> createState() =>
      _CreateSegmentedPromoScreenState();
}

class _CreateSegmentedPromoScreenState extends State<CreateSegmentedPromoScreen> {
  int _sexIndex = 2; // 0 Femenino, 1 Masculino, 2 Ambos
  final TextEditingController _ageFromController = TextEditingController();
  final TextEditingController _ageToController = TextEditingController();
  String _department = 'Lima';
  String _province = 'Lima';
  String _district = 'San Miguel';

  @override
  void dispose() {
    _ageFromController.dispose();
    _ageToController.dispose();
    super.dispose();
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
          'Promoción segmentada',
          style: TextStyle(
            color: context.appColor.primary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SexSelector(
              selectedIndex: _sexIndex,
              onSelected: (i) => setState(() => _sexIndex = i),
            ),
            20.spaceh,
            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: 'Desde qué edad',
                    controller: _ageFromController,
                    hint: 'Ingrese un número',
                  ),
                ),
                20.spacew,
                Expanded(
                  child: _NumberField(
                    label: 'Edad límite',
                    controller: _ageToController,
                    hint: 'Ingrese un número',
                  ),
                ),
              ],
            ),
            20.spaceh,
            _DropdownField(
              label: 'Departamento',
              value: _department,
              items: const ['Lima', 'Arequipa', 'Cusco'],
              onChanged: (v) => setState(() => _department = v ?? _department),
            ),
            20.spaceh,
            _DropdownField(
              label: 'Provincia',
              value: _province,
              items: const ['Lima', 'Callao'],
              onChanged: (v) => setState(() => _province = v ?? _province),
            ),
            20.spaceh,
            _DropdownField(
              label: 'Distrito',
              value: _district,
              items: const ['San Miguel', 'Miraflores', 'Surco'],
              onChanged: (v) => setState(() => _district = v ?? _district),
            ),
            40.spaceh,
            SizedBox(
              width: double.infinity,
              height: 60,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.appColor.secondary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.router.push(
                        PromoMapRoute(scopeCount: 0),
                      );
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          color: context.appColor.primary,
                          size: 22,
                        ),
                        10.spacew,
                        Text(
                          'Calcular alcance',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SexSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _SexSelector({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Femenino', 'Masculino', 'Ambos'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sexo',
          style: TextStyle(
            color: context.appColor.onSurfaceVariant.withValues(alpha: 0.8),
            fontSize: 12,
            fontFamily: 'Figtree',
          ),
        ),
        8.spaceh,
        Row(
          children: List.generate(3, (i) {
            final selected = selectedIndex == i;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
                child: GestureDetector(
                  onTap: () => onSelected(i),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: selected
                          ? context.appColor.primary
                          : context.appColor.surface.withValues(alpha: 0.64),
                      borderRadius: BorderRadius.circular(10),
                      border: selected
                          ? null
                          : Border.all(color: context.appColor.primary),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          labels[i],
                          style: TextStyle(
                            color: selected
                                ? context.appColor.onPrimary
                                : context.appColor.primary,
                            fontSize: 18,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;

  const _NumberField({
    required this.label,
    required this.controller,
    required this.hint,
  });

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
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: context.appColor.primary,
                fontSize: 18,
                fontFamily: 'Figtree',
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: context.appColor.onSurfaceVariant.withValues(alpha: 0.7),
                  fontSize: 18,
                ),
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.appColor.primary),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: context.appColor.primary),
                style: TextStyle(
                  color: context.appColor.primary,
                  fontSize: 18,
                  fontFamily: 'Figtree',
                ),
                items: items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
