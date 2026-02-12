# Integration tests (E2E)

Los integration tests arrancan la app real y simulan flujos de usuario. **No** se ejecutan junto con los tests unitarios/widget.

## Cómo ejecutar

```bash
# Todos los integration tests
flutter test integration_test/

# Solo flujo de login
flutter test integration_test/login_flow_test.dart

# Solo flujo Login → Register
flutter test integration_test/register_flow_test.dart

# Solo flujo Crear sucursal (requiere sesión para navegar Home → Sucursales → Nueva sucursal)
flutter test integration_test/create_branch_flow_test.dart
```

Si la app requiere variables de entorno o `dart-define`:

```bash
flutter test integration_test/register_flow_test.dart \
  --dart-define=token_mapbox=TU_TOKEN \
  --dart-define=base_url=https://api.ejemplo.com
```

## Tests incluidos

### login_flow_test.dart
- App muestra login al arrancar sin sesión
- Formulario vacío → SnackBar de validación
- Email inválido → SnackBar de formato
- Credenciales incorrectas → se permanece en login
- Login con email y contraseña (éxito o fallo según API)

### register_flow_test.dart
- Login → tocar "Regístrese gratis" → pantalla de registro
- Botón Continuar deshabilitado sin RUC válido
- RUC 20 → se muestran campos de documento
- Regresar → vuelve a login
- RUC inválido (ej. "123") → mensaje de validación en UI
- Cambiar RUC 20 → RUC 10 → campo documento desaparece
- RUC con formato válido (10123456789) → llamada a backend (pantalla sigue visible)

### create_branch_flow_test.dart
- La app arranca y muestra login o home
- Si hay sesión: Home → "Ver mis sucursales" → "Nueva sucursal" → pantalla Crear sucursal con título y botón Crear deshabilitado

## Notas

- Cada test llama a `app.main()` y espera con `pumpAndSettle`; los tiempos pueden variar según dispositivo/simulador.
- Si aparecen errores de binding (`_pendingFrame`, `inTest`), probar ejecutar un solo archivo o un solo test con `--name "nombre del test"`.
- Para ejecutar en un dispositivo concreto: `flutter test integration_test/register_flow_test.dart -d <device_id>`.
