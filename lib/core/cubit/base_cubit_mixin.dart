import 'package:partners/core/utils/exeptions/app_exceptions.dart';

mixin BaseCubitMixin {
  String getErrorMessage(AppException exception) {
    return exception.message;
  }
}
