import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'usb.dart';
import 'usb_impl.dart';

abstract class HybridUSBPlugin extends PlatformInterface {
  /// Constructs a [HybridUSBPlugin].
  HybridUSBPlugin() : super(token: _token);

  static final Object _token = Object();

  static HybridUSBPlugin _instance = HybridUSBPluginImpl();

  /// The default instance of [HybridUSBPlugin] to use.
  static HybridUSBPlugin get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridUSBPlugin] when
  /// they register themselves.
  static set instance(HybridUSBPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  USB createUSB();
}
