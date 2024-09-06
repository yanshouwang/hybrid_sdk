import 'dart:ffi' as ffi;

import 'package:hybrid_logging/hybrid_logging.dart';

import 'usb_ffi.dart' as ffi;
import 'hybrid_usb_plugin.dart';
import 'usb.dart';
import 'usb_error.dart';
import 'usb_option.dart';

final class HybridUSBPluginImpl extends HybridUSBPlugin {
  @override
  USB createUSB() {
    return USBImpl();
  }
}

final class USBImpl with TypeLogger, LoggerController implements USB {
  @override
  void setOption(USBOption option) {
    final err = ffi.libUSB.libusb_set_option(ffi.nullptr, option.ffiValue);
    if (err != ffi.libusb_error.LIBUSB_SUCCESS.value) {
      final errName = ffi.libUSB.libusb_error_name(err);
      throw USBError('setOption failed, $errName');
    }
  }
}
