import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'uvc.dart';
import 'uvc_impl.dart';

abstract base class HybridUVCPlugin extends PlatformInterface implements UVC {
  /// Constructs a [HybridUVCPlugin].
  HybridUVCPlugin() : super(token: _token);

  static final Object _token = Object();

  static HybridUVCPlugin _instance = HybridUVCPluginImpl();

  /// The default instance of [HybridUVCPlugin] to use.
  static HybridUVCPlugin get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridUVCPlugin] when
  /// they register themselves.
  static set instance(HybridUVCPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
