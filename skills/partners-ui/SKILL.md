---
name: partners-ui
description: >
  UI patterns for Partners app - widget patterns, theme, performance, Container vs DecoratedBox,
  strings centralizados, colores desde theme, convenciones de nombres e imports.
  Trigger: Creating/modifying widgets, working with UI components, performance optimization.
license: Apache-2.0
metadata:
  author: partners-app
  version: "1.1"
  scope: [presentation, ui]
  auto_invoke:
    - "Creating/modifying widgets, screens, or theme"
    - "Working with Partners UI (screens, widgets, theme)"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Antes de implementar UI

**Primero analizar** la configuración de tema del proyecto:

1. **ThemeData** y tema **light** (p. ej. en `lib/core/theme/` o donde esté definido el tema de la app).
2. **AppColors** (o equivalente) y cómo se exponen en el tema (ColorScheme, extensions).
3. **context.appColor** y **context.appTextTheme** (extensiones en `core/extension/`).

La implementación de pantallas y widgets debe basarse en esos colores y estilos; no hardcodear colores ni fuentes que ya vienen del ThemeData o AppColors.

---

## Reglas de UI Flutter (resumen obligatorio)

Al crear o modificar pantallas y widgets en Partners, aplicar siempre:

| Regla | Aplicación |
|-------|------------|
| **Theme / colores** | **Obligatorio**: usar `context.appColor` (no `Theme.of(context).colorScheme` directo ni colores hardcodeados). Ver `.cursor/rules/context_extensions.mdc`. |
| **TextTheme** | **Obligatorio**: usar `context.appTextTheme`. Evitar `TextStyle(fontSize: 18, color: Colors.black)` sueltos. |
| **Espaciado** | Usar `n.spaceh` y `n.spacew` en lugar de `SizedBox(height: n)` / `SizedBox(width: n)`. Import desde `package:partners/core/extension/extension.dart`. |
| **Opacidad** | **Nunca** `withOpacity()`. Usar `Color.withValues(alpha: valor)` con valor entre 0.0 y 1.0. |
| **Container vs DecoratedBox** | Usar **DecoratedBox** cuando solo se necesita decoración (color, borde, sombra). Usar **Container** cuando además se necesita padding, margin, constraints o alignment. Ver sección detallada más abajo. |
| **Listas** | Usar `ListView.builder` (o equivalente lazy) para listas; no construir todos los hijos con `ListView(children: items.map(...).toList())`. |
| **Const** | Usar constructores `const` en widgets que no dependen de estado ni de `context` (p. ej. `const SizedBox(height: 16)`, `const Icon(Icons.add)`). |
| **Botones** | Usar **ElevatedButton(onPressed: ..., child: child)** para acciones principales. **No sobrescribir colores** en `styleFrom`; los colores vienen del **ThemeData** / **ElevatedButtonThemeData**. Extender el tema, no reemplazarlo. No usar `DecoratedBox` + `InkWell` para botones estándar. Ver sección "Botones". |
| **Strings** | Textos fijos (títulos, labels, botones) en una clase de constantes `XxxScreenStrings` en `xxx_screen_strings.dart`; en la UI usar `XxxScreenStrings.continueButton`. Ver sección "Textos fijos". |
| **Imports** | Agrupar: 1) Flutter, 2) third-party, 3) proyecto. Usar barrel exports cuando existan (`package:partners/features/.../presentation.dart`). |
| **Nombres** | Archivos y carpetas: `snake_case`. Clases: `PascalCase`. Variables y parámetros: `camelCase`. Constantes: `UPPER_SNAKE_CASE`. |
| **Calidad** | Antes de PR: `flutter analyze`, `dart format .`, `flutter test`. |

Extensiones del proyecto: **obligatorio** usar `context.appColor`, `context.appTextTheme`, `n.spaceh` y `n.spacew` desde `package:partners/core/extension/extension.dart`. Regla completa: `.cursor/rules/context_extensions.mdc`.

### ListView vs Column/Row (referencia: .cursor/rules/flutter_ui_pencil.mdc)

- **Column/Row**: pocos hijos fijos (&lt; ~10–15), sin scroll o el scroll lo hace un padre. Ej.: formulario corto, fila de chips.
- **ListView/ListView.builder**: muchos ítems o cantidad variable, o se necesita scroll. **Siempre preferir `ListView.builder`** para listas largas (lazy). Lo mismo para grids: `GridView.builder` cuando hay muchas celdas.
- Evitar `ListView(children: [ ... muchos widgets ... ])` o `Column(children: [ ... 100 ítems ... ])`; usar `ListView.builder` con `itemBuilder`.

### Diseños Pencil (.pen) → Flutter

Al traducir diseños desde Pencil o conceptos tipo Tailwind: equivalencias en `.cursor/rules/flutter_ui_pencil.mdc` (layout vertical/horizontal → Column/Row, gap, fill_container → Expanded/Flexible, DecoratedBox para solo decoración, etc.).

---

## File Conventions

```
lib/features/<feature>/presentation/
├── presentation.dart        # Barrel (optional)
├── screens/                 # Full-screen widgets
│   └── feature_screen.dart
├── widgets/                 # Reusable UI components
│   └── feature_widget.dart
├── cubit/                   # State: see partners-state skill
└── notifier/                # Form state: see partners-state skill
```

- **UI only**: layout, theme, widgets. Consume estado y llama `context.read<Cubit>().method()`. **No** llama UseCase ni hace `fold` del Either; el fold es solo en el Cubit (partners-state). Referencia: auth/register (pantallas que usan RegisterCubit).
- **Obligatorio**: `context.appColor`, `context.appTextTheme`, `n.spaceh`/`n.spacew` (`.cursor/rules/context_extensions.mdc`).

## Textos fijos (copy estática)

Cuando la pantalla o el widget tiene **textos que no cambian** (títulos, labels, botones, mensajes de validación, SnackBars):

- **No** usar strings literales sueltos en el árbol de widgets (`Text('Continuar')`, `label: "Email"`, etc.).
- **Sí** usar una clase de constantes en `lib/`, por ejemplo `XxxScreenStrings` en `lib/features/<feature>/presentation/xxx_screen_strings.dart`, con `static const String continueButton = 'Continuar';` etc.
- En la UI: `Text(XxxScreenStrings.continueButton)`, `label: XxxScreenStrings.emailLabel`, `SnackBar(content: Text(XxxScreenStrings.emptyFieldsSnackBar))`.
- Ventajas: una sola fuente de verdad; los widget tests importan la misma clase y usan `find.text(XxxScreenStrings.xxx)`; cambios de copy en un solo archivo.

Estructura sugerida:

```
lib/features/<feature>/presentation/
├── xxx_screen.dart
├── xxx_screen_keys.dart   # ValueKey/Key para find.byKey en widget tests y accesibilidad
├── xxx_screen_strings.dart # Textos fijos (UI + tests); tests usan find.text(XxxScreenStrings.xxx)
└── ...
```

- **Keys**: En `xxx_screen_keys.dart` definir constantes de keys (p. ej. `static const Key createButtonKey = ValueKey('create_button');`) para usar en el widget y en tests con `find.byKey(CreateBranchScreenKeys.createButtonKey)`.

## UI Performance Rules

### Container vs DecoratedBox

**CRITICAL: Use DecoratedBox when only decoration is needed**

```dart
// ❌ WRONG - Container only for decoration (less efficient)
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: childWidget,
)

// ✅ CORRECT - DecoratedBox for only decoration (more efficient)
DecoratedBox(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: childWidget,
)

// ✅ CORRECT - Container when you need padding + decoration
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: childWidget,
)
```

### Performance Guidelines
- ✅ Use `ListView.builder` for lists (lazy loading)
- ✅ Use `const` constructors for widgets that don't change
- ✅ Use `AutomaticKeepAliveClientMixin` carefully
- ✅ Use `shouldRepaint` in custom painters
- ✅ Optimize image loading with `cached_network_image`

## Widget Patterns

### Responsive Design
```dart
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  
  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop;
        } else if (constraints.maxWidth >= 800) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

### Loading States
```dart
class LoadingWidget extends StatelessWidget {
  final String? message;
  
  const LoadingWidget({Key? key, this.message}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
```

### Error States
```dart
class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  
  const ErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Empty States
```dart
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Widget? action;
  
  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.icon,
    this.action,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon!,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              SizedBox(height: 16),
            ],
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
```

## Theme and Colors

### Use Theme Instead of Hardcoded Colors

En Partners se usan las extensiones de `BuildContext` cuando existen: `context.appColor` (equivale a `Theme.of(context).colorScheme`) y `context.appTextTheme` (equivale a `Theme.of(context).textTheme`). Preferirlas para mantener una sola forma de acceso al theme.

```dart
// ❌ WRONG - Hardcoded colors
Container(
  color: Color(0xFF0A2B7A),
  child: Text(
    'Title',
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
)

// ✅ CORRECT - Theme-based colors (con extensión del proyecto)
Container(
  color: context.appColor.primary,
  child: Text(
    'Title',
    style: context.appTextTheme.titleLarge,
  ),
)

// ✅ CORRECT - Sin extensión (Theme.of explícito)
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Title',
    style: Theme.of(context).textTheme.titleLarge,
  ),
)
```

### TextTheme Usage
```dart
// ❌ WRONG - Hardcoded text styles
Text(
  'Welcome',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
)

// ✅ CORRECT - TextTheme
Text(
  'Welcome',
  style: Theme.of(context).textTheme.headlineMedium,
)
```

## Form Patterns

### Custom Text Field
```dart
class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  
  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
```

### Botones (ElevatedButton)

- **Preferir ElevatedButton** para acciones principales (enviar formulario, guardar, crear, etc.): `ElevatedButton(onPressed: () {}, child: child)`. No usar `DecoratedBox` + `InkWell` para botones estándar.
- **No cambiar los colores** del botón en código: ya vienen configurados desde **ThemeData** (ElevatedButtonTheme / ButtonStyle). La app usa tema light y AppColors en el tema; los botones heredan esos estilos.
- Si el diseño exige un estilo concreto, configurarlo en el **tema** (ThemeData.elevatedButtonTheme), no en cada pantalla con `styleFrom(backgroundColor: ..., foregroundColor: ...)`.
- Ejemplo: `SizedBox(width: double.infinity, height: 60, child: ElevatedButton(onPressed: enabled ? _onSubmit : null, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [ Icon(Icons.arrow_forward, size: 22), 20.spacew, Text(XxxScreenStrings.createButton) ])))`

### Custom Button
```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
          foregroundColor: textColor ?? Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
```

## List Patterns

### Optimized List Item
```dart
class TransactionListItem extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback? onTap;
  
  const TransactionListItem({
    Key? key,
    required this.transaction,
    this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.customerName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 4),
                      Text(
                        transaction.dateFormatted,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${transaction.points} puntos',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.visibility,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Animation Patterns

### Fade Transition
```dart
class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  
  const FadeInWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);
  
  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
```

## File Organization

### Widget Structure
```
lib/features/feature_name/presentation/
├── screens/
│   ├── feature_screen.dart
│   └── widgets/
│       ├── feature_header_widget.dart
│       ├── feature_item_widget.dart
│       └── feature_empty_state_widget.dart
├── cubit/
│   ├── feature_cubit.dart
│   └── feature_state.dart
└── widgets/
    ├── custom_text_field.dart
    ├── custom_button.dart
    └── loading_widget.dart
```

### Import Organization

Regla: agrupar imports en este orden (Flutter → third-party → proyecto) y usar barrel exports cuando existan (`presentation.dart`, `domain.dart`, etc.).

```dart
// 1. Flutter
import 'package:flutter/material.dart';

// 2. Third-party
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// 3. Proyecto (preferir barrel: features/xxx/presentation.dart)
import 'package:partners/core/extension/extension.dart';
import 'package:partners/core/routes/routes.dart';
import 'package:partners/features/auth/presentation/auth.dart';
```

## Testing UI Components

### Widget Test Structure
```dart
void main() {
  testWidgets('CustomButton renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            onPressed: () {},
          ),
        ),
      ),
    );
    
    // Find the button
    expect(find.text('Test Button'), findsOneWidget);
    expect(find.byType(CustomButton), findsOneWidget);
    
    // Tap the button
    await tester.tap(find.text('Test Button'));
    await tester.pumpAndSettle();
  });
}
```

## Checklist al crear o modificar una pantalla

- [ ] Textos fijos en `xxx_screen_strings.dart` y referenciados en la UI (no literales en el árbol de widgets).
- [ ] Colores desde theme: `context.appColor` / `Theme.of(context).colorScheme`; sin `Color(0xFF...)` salvo justificación.
- [ ] Estilos de texto desde theme: `context.appTextTheme` / `Theme.of(context).textTheme` donde aplique.
- [ ] Solo decoración → `DecoratedBox`; decoración + padding/margin/constraints/alignment → `Container`.
- [ ] Listas largas con `ListView.builder` (o equivalente lazy).
- [ ] Constructores `const` donde el widget no dependa de estado ni de `context`.
- [ ] Imports agrupados (Flutter, third-party, proyecto) y barrel cuando exista.
- [ ] Nombres: archivos `snake_case`, clases `PascalCase`, constantes `UPPER_SNAKE_CASE`.
- [ ] Opcional: `xxx_screen_keys.dart` con keys para tests y accesibilidad.
- [ ] Antes de PR: `flutter analyze`, `dart format .`, `flutter test`.

## Related Skills

- `partners` - Project overview, component navigation
- `partners-performance` - Performance optimization details (Container vs DecoratedBox, listas, memoria)
- `partners-testing` - Testing patterns for UI
- `partners-testing-widget` - Widget tests (screens, widgets, find.byKey, find.text(Strings))
- `partners-domain` - Use cases and entities for UI
- `flutter-3` - General Flutter patterns
- `state-management` - BLoC/Cubit patterns