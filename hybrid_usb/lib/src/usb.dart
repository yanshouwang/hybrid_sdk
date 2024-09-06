import 'package:hybrid_logging/hybrid_logging.dart';

import 'hybrid_usb_plugin.dart';
import 'usb_option.dart';

abstract interface class USB implements LogController {
  static USB? _instance;

  factory USB() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = HybridUSBPlugin.instance.createUSB();
    }
    return instance;
  }

  void setOption(USBOption option);
}
