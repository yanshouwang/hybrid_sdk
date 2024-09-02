import 'dart:ffi';
import 'dart:io';

import 'ffi.dart';
import 'hybrid_usb_plugin.dart';
import 'usb.dart';
import 'usb_error.dart';
import 'usb_option.dart';

const _usb = 'usb-1.0';

final _dylibUSB = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_usb.framework/$_usb');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_usb.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_usb.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final _libUSB = LibUSB(_dylibUSB);

final class HybridUSBPluginImpl extends HybridUSBPlugin {
  @override
  USB createUSB() {
    return USBImpl();
  }
}

final class USBImpl implements USB {
  @override
  void setOption(USBOption option) {
    final err = _libUSB.libusb_set_option(nullptr, option.ffiValue);
    if (err != libusb_error.LIBUSB_SUCCESS.value) {
      final errName = _libUSB.libusb_error_name(err);
      throw USBError('setOption failed, $errName');
    }
  }
}
