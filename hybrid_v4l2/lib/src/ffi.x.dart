import 'dart:convert';
import 'dart:ffi' as ffi;

import 'ffi.c.dart' as ffi;
import 'ffi.ioctl.dart' as ffi;
import 'ffi.v4l2.dart' as ffi;
import 'v4l2_capability.dart';

const _ioctl = 'ioctl';

final _dylibC = ffi.DynamicLibrary.executable();
final _dylibIOCTL = ffi.DynamicLibrary.open('lib$_ioctl.so');

final libC = ffi.LibC(_dylibC);
final libIOCTL = ffi.LibIOCTL(_dylibIOCTL);

extension UnsignedCharArrayX on ffi.Array<ffi.UnsignedChar> {
  String get dartValue {
    final codeUnits = <int>[];
    var i = 0;
    while (true) {
      final codeUnit = this[i];
      if (codeUnit == 0) {
        break;
      }
      codeUnits.add(codeUnit);
      i++;
    }
    return utf8.decode(codeUnits);
  }
}

// ignore: camel_case_extensions
extension intX on int {
  List<V4L2Capability> get dartCapabilities {
    final capabilities = <V4L2Capability>[];
    for (var capability in V4L2Capability.values) {
      if (this & capability.value != 0) {
        capabilities.add(capability);
      }
    }
    return capabilities;
  }
}
