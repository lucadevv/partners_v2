import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/strategies/error_handler_strategy.dart';

class AppExceptionHandlerStrategy implements ErrorHandlerStrategy {
  @override
  bool canHandle(dynamic error) => error is AppException;

  @override
  AppException handle(dynamic error) => error as AppException;
}
