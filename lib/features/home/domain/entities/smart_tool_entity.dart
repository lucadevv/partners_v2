import 'package:equatable/equatable.dart';

/// Domain entity representing a Smart Tool
class SmartToolEntity extends Equatable {
  final String id;
  final String title;
  final String iconName;
  final String route;
  final int backgroundColor; // Color ARGB del fondo del círculo (0xFF66CFFF = celeste por defecto)

  const SmartToolEntity({
    required this.id,
    required this.title,
    required this.iconName,
    required this.route,
    this.backgroundColor = 0xFF66CFFF, // Celeste por defecto
  });

  @override
  List<Object?> get props => [id, title, iconName, route, backgroundColor];
}
