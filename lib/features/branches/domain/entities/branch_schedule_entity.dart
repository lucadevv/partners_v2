import 'package:equatable/equatable.dart';

/// Horario de sucursal (detalle).
class BranchScheduleEntity extends Equatable {
  final String id;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;
  final String startTime;
  final String endTime;

  const BranchScheduleEntity({
    required this.id,
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

  @override
  List<Object?> get props =>
      [id, monday, tuesday, wednesday, thursday, friday, saturday, sunday, startTime, endTime];
}
