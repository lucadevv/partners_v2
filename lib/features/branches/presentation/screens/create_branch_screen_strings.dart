/// Textos fijos de la pantalla Crear sucursal.
/// Fuente única para UI y tests; sigue partners-ui skill.
abstract final class CreateBranchScreenStrings {
  CreateBranchScreenStrings._();

  // App bar
  static const String appBarTitle = 'Crear nueva sucursal';

  // Sección banner
  static const String uploadBanner = 'Subir banner';

  // Campos del formulario
  static const String categoryLabel = 'Categoría de la sucursal';
  static const String categoryHint = 'Elige una categoría';
  static const String subCategoryLabel = 'Sub categoría de la sucursal';
  static const String subCategoryHint = 'Elige una sub categoría';
  static const String scheduleLabel = 'Horario de la sucursal';
  static const String scheduleHint = 'Configure horario disponible';

  // Bottom sheets
  static const String chooseCategoryTitle = 'Elija o busque la categoría';
  static const String chooseSubCategoryTitle = 'Elija o busque la subcategoría';
  static const String configureScheduleTitle = 'Configure el horario';
  static const String chooseOptionTitle = 'Elige una opción';

  // Opciones de imagen
  static const String takePhoto = 'Tomar foto con cámara';
  static const String uploadFromGallery = 'Subir foto de galería';

  // Botón principal
  static const String createBranchButton = 'Crear nueva sucursal';

  // Horarios predefinidos
  static const String scheduleMonSat = 'Lunes a Sábado: 9:00 a 21:00';
  static const String scheduleMonFri = 'Lunes a Viernes: 8:00 a 18:00';
  static const String scheduleEveryDay = 'Todos los días: 10:00 a 22:00';
  static const String scheduleMonSun = 'Lunes a Domingo: 8:00 a 20:00';

  static const List<String> scheduleOptions = [
    scheduleMonSat,
    scheduleMonFri,
    scheduleEveryDay,
    scheduleMonSun,
  ];

  static const List<String> categories = [
    'Restaurante',
    'Estética',
    'Limpieza',
    'Cine',
    'Pollería',
  ];

  static const List<String> subCategories = [
    'Cevichería',
    'Pollería',
    'Juguería',
    'Comida rápida',
  ];

  // Modal configurar horario (mismo contenido que configure_schedule, pero como modal)
  static const String scheduleModalTitle = 'Configure el horario';
  static const String scheduleModalDaysLabel = 'Señale los días disponibles';
  static const String scheduleModalTimeLabel =
      'Señale la hora, según el día seleccionado';
  static const String scheduleModalStartLabel = 'Inicio de hora';
  static const String scheduleModalEndLabel = 'Fin de hora';
  static const String scheduleModalConfirm = 'Aplicar horario';
  static const List<String> scheduleModalDays = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];
}
