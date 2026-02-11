/// Textos fijos de la pantalla de login.
/// Fuente única para UI y para widget tests; evita strings sueltos en la pantalla.
abstract final class LoginScreenStrings {
  LoginScreenStrings._();

  // Títulos y subtítulos
  static const String welcomeTitle = '¡Bienvenido a';
  static const String appName = 'Partners';
  static const String subtitle = 'Ingrese colocando sus datos';

  // Formulario
  static const String emailLabel = 'Email';
  static const String emailHint = 'Ingrese su correo electrónico';
  static const String passwordLabel = 'Contraseña';
  static const String passwordHint = 'Ingrese su contraseña';

  // Botón y enlaces
  static const String continueButton = 'Continuar';
  static const String forgotPassword = '¿Olvidó su contraseña?';
  static const String noAccount = '¿No tiene cuenta?';
  static const String registerFree = 'Regístrese gratis';

  // Validación / mensajes
  static const String emptyFieldsSnackBar =
      'Por favor ingrese email y contraseña';
  static const String invalidEmailFormat =
      'El formato del email no es válido';
}
