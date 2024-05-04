import 'package:logging/logging.dart';

import 'log_controller.dart';

mixin LoggerController implements LogController {
  Logger get logger;

  @override
  Level get logLevel => logger.level;
  @override
  set logLevel(Level? value) => logger.level = value;
}
