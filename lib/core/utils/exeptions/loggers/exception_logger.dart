import 'package:partners/core/utils/exeptions/app_exceptions.dart';
import 'package:partners/core/utils/logger/app_logger.dart';

class ExceptionLogger {
  static void log(AppException exception, {String? tag}) {
    AppLogger.error(
      exception.message,
      exception,
      null,
      tag ?? 'ExceptionHandler',
    );
    if (exception.details != null) {
      AppLogger.info('Details: ${exception.details}', tag);
    }
    if (exception.code != null) {
      AppLogger.info('Code: ${exception.code}', tag);
    }
  }
}
