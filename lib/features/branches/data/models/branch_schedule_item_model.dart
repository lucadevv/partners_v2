/// Modelo para un ítem de branchschedules en la respuesta GET /branch.
class BranchScheduleItemModel {
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;
  final String startTime;
  final String endTime;

  const BranchScheduleItemModel({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.startTime,
    required this.endTime,
  });

  factory BranchScheduleItemModel.fromJson(Map<String, dynamic> json) {
    final startRaw = json['start_time'] as String? ?? '';
    final endRaw = json['end_time'] as String? ?? '';
    return BranchScheduleItemModel(
      monday: json['monday'] as bool? ?? false,
      tuesday: json['tuesday'] as bool? ?? false,
      wednesday: json['wednesday'] as bool? ?? false,
      thursday: json['thursday'] as bool? ?? false,
      friday: json['friday'] as bool? ?? false,
      saturday: json['saturday'] as bool? ?? false,
      sunday: json['sunday'] as bool? ?? false,
      startTime: _timeToHoursAndMinutes(startRaw),
      endTime: _timeToHoursAndMinutes(endRaw),
    );
  }

  /// Deja solo horas y minutos (HH:mm). Si viene "08:00:00" retorna "08:00".
  static String _timeToHoursAndMinutes(String time) {
    final t = time.trim();
    if (t.length >= 5) return t.substring(0, 5);
    return t;
  }

  /// Días en español (mismo orden que CreateBranchScreenStrings.scheduleModalDays).
  static const List<String> _dayNames = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  /// Genera texto para la UI: ej. "Lunes a Sábado: 08:00 a 22:00".
  String toDisplayString() {
    final days = <int>[];
    final flags = [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
    for (var i = 0; i < flags.length; i++) {
      if (flags[i]) days.add(i);
    }
    if (days.isEmpty || startTime.isEmpty || endTime.isEmpty) {
      return '';
    }
    final first = _dayNames[days.first];
    final last = _dayNames[days.last];
    final dayRange = first == last ? first : '$first a $last';
    return '$dayRange: $startTime a $endTime';
  }
}
