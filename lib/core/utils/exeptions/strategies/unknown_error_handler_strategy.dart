import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/strategies/error_handler_strategy.dart';

class UnknownErrorHandlerStrategy implements ErrorHandlerStrategy {
  @override
  bool canHandle(dynamic error) => true;

  @override
  AppException handle(dynamic error) {
    return UnknownException(
      'Error inesperado',
      details: error.toString(),
    );
  }
}
