# flutter

Write your command content here.

- gen_routes:
  - Descripción: Genera el archivo de rutas de AutoRoute basado en las anotaciones @AutoRoute.
  - Comando: dart run build_runner build --delete-conflicting-outputs

- gen_models:
  - Descripción: Genera código para modelos (freezed/json_serializable).
  - Comando: dart run build_runner build --delete-conflicting-outputs

- run_unit_tests:
  - Descripción: Ejecuta solo pruebas unitarias de la capa Domain.
  - Comando: flutter test test/domain/

- run_widget_tests:
  - Descripción: Ejecuta pruebas de widgets de la capa Presentation.
  - Comando: flutter test test/presentation/

- run_integration_tests:
  - Descripción: Ejecuta pruebas de integración completas (flujo de ordenar café).
  - Comando: flutter test integration_test/

- check_solid_compliance:
  - Descripción: (Hipotético o script personal) Verifica que no haya dependencias incorrectas entre capas (ej. Domain importando Material).
  - Comando: flutter analyze | grep -E "domain.*material|presentation.*datasource" (Opcional, requiere script bash)
