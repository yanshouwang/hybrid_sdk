import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:hybrid_usb/src/usb_option.dart';

import 'usb_ffi.g.dart' as ffi;

const _usb = 'usb-1.0';

final _dylibUSB = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return ffi.DynamicLibrary.open('$_usb.framework/$_usb');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return ffi.DynamicLibrary.open('lib$_usb.so');
  }
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('$_usb.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final libUSB = ffi.LibUSB(_dylibUSB);

extension USBOptionX on USBOption {
  ffi.libusb_option get ffiValue {
    switch (this) {
      case USBOption.logLevel:
        return ffi.libusb_option.LIBUSB_OPTION_LOG_LEVEL;
      case USBOption.useUSBDK:
        return ffi.libusb_option.LIBUSB_OPTION_USE_USBDK;
      case USBOption.noDeviceDiscovery:
        return ffi.libusb_option.LIBUSB_OPTION_NO_DEVICE_DISCOVERY;
      case USBOption.logCallback:
        return ffi.libusb_option.LIBUSB_OPTION_LOG_CB;
      case USBOption.max:
        return ffi.libusb_option.LIBUSB_OPTION_MAX;
    }
  }
}
