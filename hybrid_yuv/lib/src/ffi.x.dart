import 'dart:ffi';
import 'dart:io';

import 'ffi.dart';

const _libYUVName = 'yuv';

/// The dynamic library in which the symbols for [LibYUV] can be found.
final _dylibYUV = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libYUVName.framework/$_libYUVName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libYUVName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libYUVName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylibYUV].
final libYUV = LibYUV(_dylibYUV);
