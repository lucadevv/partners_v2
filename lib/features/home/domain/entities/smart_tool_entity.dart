import 'package:equatable/equatable.dart';

/// Domain entity representing a Smart Tool
class SmartToolEntity extends Equatable {
  final String id;
  final String title;
  final String iconName;
  final String route;

  const SmartToolEntity({
    required this.id,
    required this.title,
    required this.iconName,
    required this.route,
  });

  @override
  List<Object?> get props => [id, title, iconName, route];
}
