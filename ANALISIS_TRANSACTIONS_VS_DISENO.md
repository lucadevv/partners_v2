# Análisis: Pantallas de Transacciones vs diseño Pencil y reglas del proyecto

## 1. Fuente del diseño (Pencil)

- **Pantalla "Transacciones"** en el .pen: título "Transacciones" (fill `#0a2b7aff`, fontSize 28, centrado), coherente con el AppBar actual.
- **Sección en Home**: "Transacciones" (fontSize 23) + "Ver completo" (navegación a la pantalla completa). Ya existe en `HomeTransactionsSection`.
- **Lista de ítems**: nombre, fecha, puntos (ej. "Tonyjaxxmusic", "25 Jul 2025 - 16:54", "5 puntos"). La pantalla actual muestra name, date, points y botón de detalle.
- **Filtro**: en el diseño se asume un filtro (icono en app bar); el bottom sheet "Filtrar por" con opciones (Solo hoy, Últimos 07/15/30 días) está implementado.

---

## 2. TransactionsScreen – qué tenemos y qué falta

### Implementado

- AppBar con título "Transacciones", botón atrás, icono de filtro.
- Lista con `ListView.builder` (lazy, correcto según reglas de rendimiento).
- Cada ítem: nombre, fecha, puntos, icono "visibility" que navega al detalle.
- Bottom sheet de filtro: "Filtrar por", "Solo hoy", "Últimos 07 días", "Últimos 15 días", "Últimos 30 días".
- Colores y tipografía Figtree alineados al diseño.

### Posibles carencias (diseño / UX)

| Aspecto | Estado | Nota |
|--------|--------|------|
| Estado vacío | No hay | Si `_transactions` está vacío, la lista queda en blanco. En el diseño suele mostrarse mensaje o ilustración "No hay transacciones". |
| Estado de carga | No hay | Los datos son estáticos; si luego vienen de API, faltaría loading (skeleton o indicador). |
| Persistencia del filtro | No hay | Las opciones del bottom sheet no guardan selección ni filtran la lista (solo UI). |
| Texto "puntos" | Inconsistente | En el diseño y en Home se usa "5 puntos"; en `TransactionItemWidget` (home) se usa "points". Unificar a "puntos". |

### Desvíos respecto a las reglas del proyecto

| Regla | Situación actual | Acción recomendada |
|-------|------------------|--------------------|
| **Barrel files** | `import 'package:partners/core/routes/app_routes.gr.dart';` | Usar `import 'package:partners/core/routes/routes.dart';` |
| **Theme / colores** | Colores hardcodeados (`Color(0xFF0A2B7A)`, `Color(0xFF051858)`, etc.) | Usar `Theme.of(context).colorScheme` o paleta de `AppTheme` / `app_colors_ligth` |
| **DecoratedBox** | `Container` con solo `decoration` + `padding` en ítem y bottom sheet | Donde solo aplique decoración (p. ej. fondo + borderRadius), usar `DecoratedBox` y envolver con `Padding` |
| **Capa domain/data** | Lista hardcodeada `_transactions` en la pantalla | Si transacciones vienen de backend: feature `transactions` con domain (entity, repository, use case) y data (model, mapper, datasource); pantalla consumiendo un Cubit que use el use case |
| **withOpacity** | No usado aquí | Mantener y usar `Color.withValues(alpha:)` si se añaden transparencias |

---

## 3. TransactionDetailScreen – qué tenemos y qué falta

### Implementado

- Fondo en gradiente (azules).
- Título "Puntos emitidos", icono de check, "Transferencia exitosa", fecha.
- Sección "Detalles" con texto aclaratorio.
- Cards: Monto emitido, N° de operación, Beneficiario de Puntos Smart.
- Botón "Aceptar" que hace pop.

### Posibles carencias (diseño / UX)

| Aspecto | Estado | Nota |
|--------|--------|------|
| Datos fijos | Parcial | "N°. de operación: 1108" y "Trabajador emisor: Mariano Suquillanda Ramirez" están hardcodeados. Deberían venir del modelo/entity si el diseño lo refleja. |
| Navegación atrás | Solo botón Aceptar | El diseño puede incluir también flecha atrás en AppBar; actualmente `extendBodyBehindAppBar: true` sin AppBar visible. |

### Desvíos respecto a las reglas del proyecto

| Regla | Situación actual | Acción recomendada |
|-------|------------------|--------------------|
| **Barrel files** | No importa rutas; usa `core/extension/sizedbox_extension.dart` | Usar `import 'package:partners/core/extension/extension.dart';` (y rutas si se añade navegación por rutas) |
| **Theme** | Colores y estilos hardcodeados | Usar theme (colorScheme, textTheme) para colores y tipografía |
| **DecoratedBox** | Varios `Container` solo con `decoration` (cards, botón) | Sustituir por `DecoratedBox` + `Padding` donde corresponda |

---

## 4. Resumen de acciones sugeridas (sin implementar aún)

1. **TransactionsScreen**
   - Cambiar import a `core/routes/routes.dart`.
   - Añadir estado vacío ("No hay transacciones").
   - Unificar copy "puntos" en toda la app (lista y detalle).
   - Sustituir colores hardcodeados por Theme / paleta del proyecto.
   - Usar `DecoratedBox` donde solo haya decoración en ítems y bottom sheet.
   - (Opcional) Conectar filtro a la lista y persistir selección.
   - (Futuro) Mover datos a domain/data y Cubit.

2. **TransactionDetailScreen**
   - Import desde `core/extension/extension.dart`.
   - Pasar operación y trabajador emisor desde la ruta o un entity (evitar literales "1108", "Mariano Suquillanda Ramirez" en la pantalla).
   - Theme para colores y textos; `DecoratedBox` en cards y botón donde aplique.

3. **Reglas**
   - Seguir **barrel_files**, **arquiecture** (capas, BLoC/Cubit si hay estado de dominio) y **flutter_ui_pencil** (ListView.builder ya correcto; mantener const y estructura clara).

---

## 5. Conclusión

- La pantalla de lista y la de detalle están alineadas en contenido principal con el diseño Pencil (título, ítems nombre/fecha/puntos, filtro, detalle con cards y botón).
- Lo que falta es sobre todo: **estado vacío**, **uso de Theme y barrels**, **DecoratedBox** donde toque, y **datos desde dominio** (y filtro real) cuando se integre con backend. Este documento sirve como checklist para implementar esos cambios siguiendo las reglas del proyecto.
