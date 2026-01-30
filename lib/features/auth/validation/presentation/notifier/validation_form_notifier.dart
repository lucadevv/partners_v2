import 'package:flutter/material.dart';
import 'package:partners/features/auth/validation/domain/entities/validation_entity.dart';
import 'package:partners/features/auth/validation/domain/factories/item_factory.dart';

class ValidationFormNotifier extends ChangeNotifier {
  final List<ItemValidation> itemScreenFactory = ItemFactory.getConfig();
}
