import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Domain entity representing a Smart Tool
class SmartToolEntity extends Equatable {
  final String id;
  final String title;
  final String iconName;
  final String route;
  final Color backgroundColor; // Color del fondo del círculo

  const SmartToolEntity({
    required this.id,
    required this.title,
    required this.iconName,
    required this.route,
    this.backgroundColor = const Color(0xFF66CFFF), // Celeste por defecto
  });

  @override
  List<Object?> get props => [id, title, iconName, route, backgroundColor];
}
