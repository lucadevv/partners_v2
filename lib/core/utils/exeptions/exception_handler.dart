import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/exeptions/loggers/exception_logger.dart';
import 'package:partners/core/utils/exeptions/strategies/app_exception_handler_strategy.dart';
import 'package:partners/core/utils/exeptions/strategies/dio_error_handler_strategy.dart';
import 'package:partners/core/utils/exeptions/strategies/error_handler_strategy.dart';
import 'package:partners/core/utils/exeptions/strategies/format_error_handler_strategy.dart';
import 'package:partners/core/utils/exeptions/strategies/http_status_error_handler_strategy.dart';
import 'package:partners/core/utils/exeptions/strategies/unknown_error_handler_strategy.dart';

class ExceptionHandler {
  static final List<ErrorHandlerStrategy> _strategies = [
    AppExceptionHandlerStrategy(),
    DioErrorHandlerStrategy(HttpStatusErrorHandlerStrategy()),
    FormatErrorHandlerStrategy(),
    UnknownErrorHandlerStrategy(),
  ];

  static AppException handleException(dynamic error) {
    for (final strategy in _strategies) {
      if (strategy.canHandle(error)) {
        return strategy.handle(error);
      }
    }
    return UnknownException(
      'Error inesperado',
      details: error.toString(),
    );
  }

  static void logException(AppException exception, {String? tag}) {
    ExceptionLogger.log(exception, tag: tag);
  }
}
