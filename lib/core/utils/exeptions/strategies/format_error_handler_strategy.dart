import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/strategies/error_handler_strategy.dart';

class FormatErrorHandlerStrategy implements ErrorHandlerStrategy {
  @override
  bool canHandle(dynamic error) => error is FormatException;

  @override
  AppException handle(dynamic error) {
    final formatError = error as FormatException;
    return ValidationException(
      'Error en el formato de los datos',
      details: formatError.message,
    );
  }
}
