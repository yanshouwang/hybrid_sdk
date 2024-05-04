import 'package:logging/logging.dart';

mixin TypeLogger {
  Logger get logger => Logger('$runtimeType');
}
