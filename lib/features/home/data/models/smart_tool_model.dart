import 'package:partners/features/home/domain/entities/smart_tool_entity.dart';

/// Data model for Smart Tool (Data Layer)
class SmartToolModel extends SmartToolEntity {
  const SmartToolModel({
    required super.id,
    required super.title,
    required super.iconName,
    required super.route,
  });

  factory SmartToolModel.fromJson(Map<String, dynamic> json) {
    return SmartToolModel(
      id: json['id'] as String,
      title: json['title'] as String,
      iconName: json['iconName'] as String,
      route: json['route'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'iconName': iconName,
      'route': route,
    };
  }

  SmartToolEntity toEntity() {
    return SmartToolEntity(
      id: id,
      title: title,
      iconName: iconName,
      route: route,
    );
  }
}
