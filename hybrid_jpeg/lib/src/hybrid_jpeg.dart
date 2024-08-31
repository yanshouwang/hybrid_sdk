import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jpeg.dart';

// const _jpeg = 'jpeg';

// final _dylibJPEG = () {
//   if (Platform.isMacOS || Platform.isIOS) {
//     return DynamicLibrary.open('$_jpeg.framework/$_jpeg');
//   }
//   if (Platform.isAndroid || Platform.isLinux) {
//     return DynamicLibrary.open('lib$_jpeg.so');
//   }
//   if (Platform.isWindows) {
//     return DynamicLibrary.open('$_jpeg.dll');
//   }
//   throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
// }();

// final _libJPEG = LibJPEG(_dylibJPEG);

abstract class HybridJPEGPlugin extends PlatformInterface implements JPEG {
  /// Constructs a [HybridJPEGPlugin].
  HybridJPEGPlugin() : super(token: _token);

  static final Object _token = Object();

  static HybridJPEGPlugin _instance = _HybridJPEGPlugin();

  /// The default instance of [HybridJPEGPlugin] to use.
  static HybridJPEGPlugin get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridJPEGPlugin] when
  /// they register themselves.
  static set instance(HybridJPEGPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

final class _HybridJPEGPlugin extends HybridJPEGPlugin {}
