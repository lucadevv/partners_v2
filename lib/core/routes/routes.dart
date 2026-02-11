// Barrel: routes area.
// No exportar shell/* aquí: app_routes.gr.dart ya reexporta esos tipos; si se exportaran
// también los shells habría conflicto de nombres (AppShellRoute, CuentaShell, etc.).
export 'app_routes.dart';
export 'app_routes.gr.dart';
export 'guards/auth_guard.dart';
export 'guards/complete_data_guard.dart';
export 'guards/initial_route_guard.dart';
export 'private_routes.dart';
export 'public_routes.dart';
