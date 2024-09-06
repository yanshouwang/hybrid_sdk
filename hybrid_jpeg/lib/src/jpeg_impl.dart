import 'package:hybrid_logging/hybrid_logging.dart';

import 'hybrid_jpeg_plugin.dart';
import 'jpeg.dart';

final class HybridJPEGPluginImpl extends HybridJPEGPlugin {
  @override
  JPEG createJPEG() {
    return JPEGImpl();
  }
}

final class JPEGImpl with TypeLogger, LoggerController implements JPEG {}
