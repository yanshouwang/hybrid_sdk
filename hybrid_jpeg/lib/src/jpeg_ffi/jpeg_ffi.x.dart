import 'dart:ffi' as ffi;
import 'dart:io';

import 'jpeg_ffi.g.dart' as ffi;

const _jpeg = 'jpeg';

final _dylibJPEG = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return ffi.DynamicLibrary.open('$_jpeg.framework/$_jpeg');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return ffi.DynamicLibrary.open('lib$_jpeg.so');
  }
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('$_jpeg.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final libJPEG = ffi.LibJPEG(_dylibJPEG);
