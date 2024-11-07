import 'dart:ffi';
import 'dart:io';

import 'ffi.hybrid.dart';

const _libHybridName = 'hybrid';

/// The dynamic library in which the symbols for [LibHybrid] can be found.
final DynamicLibrary _dylibHybrid = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libHybridName.framework/$_libHybridName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libHybridName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libHybridName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylibHybrid].
final libHybrid = LibHybrid(_dylibHybrid);
