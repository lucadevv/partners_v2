import 'package:partners/core/utils/exeptions/app_exceptions.dart';

abstract class ErrorHandlerStrategy {
  bool canHandle(dynamic error);
  AppException handle(dynamic error);
}
