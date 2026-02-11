// Barrel: auth feature.
// Auth está organizado por subfeatures (login, register, validation, etc.).
// Importar desde el subfeature concreto: auth/login/..., auth/register/..., etc.
// Re-exportamos presentación de cada subfeature para uso desde rutas/inyección.

export 'login/domain/domain.dart';
export 'login/data/data.dart';
export 'login/presentation/presentation.dart';
export 'register/domain/domain.dart';
export 'register/data/data.dart' hide CeStrategy, DniStrategy;
export 'register/presentation/presentation.dart';
