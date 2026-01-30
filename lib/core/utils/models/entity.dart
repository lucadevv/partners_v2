import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  final String ruc;

  const Entity({required this.ruc});

  @override
  List<Object?> get props => [ruc];

  String getDisplayName();
}
