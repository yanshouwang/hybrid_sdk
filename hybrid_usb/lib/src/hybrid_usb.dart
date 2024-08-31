import 'dart:ffi';
import 'dart:io';

import 'package:hybrid_usb/src/usb_error.dart';
import 'package:hybrid_usb/src/usb_option.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ffi.dart';
import 'usb.dart';

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

abstract class HybridUSBPlugin extends PlatformInterface implements USB {
  /// Constructs a [HybridUSBPlugin].
  HybridUSBPlugin() : super(token: _token);

  static final Object _token = Object();

  static HybridUSBPlugin _instance = _HybridUSBPlugin();

  /// The default instance of [HybridUSBPlugin] to use.
  static HybridUSBPlugin get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridUSBPlugin] when
  /// they register themselves.
  static set instance(HybridUSBPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

final class _HybridUSBPlugin extends HybridUSBPlugin {
  @override
  void setOption(USBOption option) {
    final err = _libUSB.libusb_set_option(nullptr, option.ffiValue);
    if (err != libusb_error.LIBUSB_SUCCESS.value) {
      final errName = _libUSB.libusb_error_name(err);
      throw USBError('setOption failed, $errName');
    }
  }
}
