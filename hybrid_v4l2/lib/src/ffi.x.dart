import 'dart:ffi' as ffi;

import 'ffi.g.dart' as ffi;
import 'v4l2_cap.dart';
import 'v4l2_fmt_flag.dart';
import 'v4l2_pix_fmt.dart';

final _dylibV4L2 = ffi.DynamicLibrary.executable();

final libV4L2 = ffi.LibV4L2(_dylibV4L2);

extension UnsignedCharArrayX on ffi.Array<ffi.UnsignedChar> {
  String toDart() {
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
  List<V4L2Cap> toDartCaps() {
    final caps = <V4L2Cap>[];
    for (var cap in V4L2Cap.values) {
      if (this & cap.value == 0) {
        continue;
      }
      caps.add(cap);
    }
    return caps;
  }

  List<V4L2FmtFlag> toDartFmtFlags() {
    final flags = <V4L2FmtFlag>[];
    for (var flag in V4L2FmtFlag.values) {
      if (this & flag.value == 0) {
        continue;
      }
      flags.add(flag);
    }
    return flags;
  }

  V4L2PixFmt toDartPixFmt() {
    return V4L2PixFmt.values.firstWhere((fmt) => fmt.value == this);
  }
}
