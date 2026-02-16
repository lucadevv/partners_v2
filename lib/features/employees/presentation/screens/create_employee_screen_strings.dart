/// Textos fijos de la pantalla Crear empleado.
abstract final class CreateEmployeeScreenStrings {
  CreateEmployeeScreenStrings._();

  static const String appBarTitle = 'Crear empleado';
  static const String emailLabel = 'Correo';
  static const String emailHint = 'Ingrese el correo';
  static const String passwordLabel = 'Contraseña';
  static const String passwordHint = 'Ingrese la contraseña';
  static const String nameLabel = 'Nombres';
  static const String nameHint = 'Ingrese los nombres';
  static const String lastNameLabel = 'Apellidos';
  static const String lastNameHint = 'Ingrese los apellidos';
  static const String branchLabel = 'Sucursal';
  static const String branchHint = 'Elija la sucursal';
  static const String roleLabel = 'Rol';
  static const String roleHint = 'Elija el rol';
  static const String photoLabel = 'Foto';
  static const String addPhoto = 'Agregar una foto';
  static const String takePhoto = 'Tomar foto';
  static const String uploadFromGallery = 'Subir desde galería';
  static const String choosePhotoSource = 'Elegir origen de la imagen';
  static const String submitButton = 'Crear empleado';
  static const String successMessage =
      'Empleado asignado a la sucursal correctamente';
  static const String selectBranch = 'Seleccione una sucursal';
  static const String selectRole = 'Seleccione un rol';
  static const String photoRequired = 'Agregue una foto del empleado';

  /// Nombre del rol en español para mostrar en UI (API devuelve employee, branch_manager, superadmin).
  static String roleDisplayName(String apiName) {
    return switch (apiName) {
      'employee' => 'Empleado',
      'branch_manager' => 'Gerente de sucursal',
      'superadmin' => 'Superadministrador',
      _ => apiName,
    };
  }
}
