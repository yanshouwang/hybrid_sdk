import 'dart:ffi';
import 'dart:io';

import 'ffi.hybrid_v4l2.dart';

const _libHybridV4L2Name = 'hybrid_v4l2';

/// The dynamic library in which the symbols for [LibHybridV4L2] can be found.
final _dylibHybridV4L2 = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open(
        '$_libHybridV4L2Name.framework/$_libHybridV4L2Name');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libHybridV4L2Name.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libHybridV4L2Name.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylibHybridV4L2].
final libHybridV4L2 = LibHybridV4L2(_dylibHybridV4L2);
