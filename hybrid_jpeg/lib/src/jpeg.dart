import 'package:hybrid_logging/hybrid_logging.dart';

import 'hybrid_jpeg_plugin.dart';

abstract interface class JPEG implements LogController {
  static JPEG? _instance;

  factory JPEG() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = HybridJPEGPlugin.instance.createJPEG();
    }
    return instance;
  }
}
