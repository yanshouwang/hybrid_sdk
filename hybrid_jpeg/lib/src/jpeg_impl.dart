import 'hybrid_jpeg_plugin.dart';
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

final class HybridJPEGPluginImpl extends HybridJPEGPlugin {
  @override
  JPEG createJPEG() {
    return JPEGImpl();
  }
}

final class JPEGImpl implements JPEG {}
