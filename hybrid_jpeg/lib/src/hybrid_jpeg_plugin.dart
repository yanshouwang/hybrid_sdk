import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jpeg.dart';
import 'jpeg_impl.dart';

abstract class HybridJPEGPlugin extends PlatformInterface {
  /// Constructs a [HybridJPEGPlugin].
  HybridJPEGPlugin() : super(token: _token);

  static final Object _token = Object();

  static HybridJPEGPlugin _instance = HybridJPEGPluginImpl();

  /// The default instance of [HybridJPEGPlugin] to use.
  static HybridJPEGPlugin get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridJPEGPlugin] when
  /// they register themselves.
  static set instance(HybridJPEGPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  JPEG createJPEG();
}
