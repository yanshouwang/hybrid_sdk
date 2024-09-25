import 'dart:ffi' as ffi;

import 'ffi.g.dart' as ffi;
import 'v4l2_capability.dart';

final _dylibV4L2 = ffi.DynamicLibrary.executable();

final libV4L2 = ffi.LibV4L2(_dylibV4L2);

extension UnsignedCharArrayX on ffi.Array<ffi.UnsignedChar> {
  String get dartValue {
    final charCodes = <int>[];
    var i = 0;
    while (true) {
      final charCode = this[i];
      if (charCode == 0) {
        break;
      }
      charCodes.add(charCode);
      i++;
    }
    return String.fromCharCodes(charCodes);
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
