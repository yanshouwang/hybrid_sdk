import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;

import 'ffi.g.dart' as ffi;
import 'v4l2_buf_flag.dart';
import 'v4l2_buf_type.dart';
import 'v4l2_cap.dart';
import 'v4l2_field.dart';
import 'v4l2_fmt_flag.dart';
import 'v4l2_in_cap.dart';
import 'v4l2_in_st.dart';
import 'v4l2_input_type.dart';
import 'v4l2_memory.dart';
import 'v4l2_pix_fmt.dart';
import 'v4l2_std.dart';
import 'v4l2_tc_flag.dart';
import 'v4l2_tc_type.dart';

final _dylibV4L2 = ffi.DynamicLibrary.executable();

final libV4L2 = ffi.LibV4L2(_dylibV4L2);

// ignore: non_constant_identifier_names
final MAP_FAILED = (ffi.malloc<ffi.Int>()..value = -1).cast<ffi.Void>();

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

  V4L2InputType toDartInputType() {
    return V4L2InputType.values.firstWhere((type) => type.value == this);
  }

  V4L2BufType toDartBufType() {
    return V4L2BufType.values.firstWhere((type) => type.value == this);
  }

  List<V4L2Std> toDartStds() {
    final stds = <V4L2Std>[];
    for (var std in V4L2Std.values) {
      if (this & std.value == 0) {
        continue;
      }
      stds.add(std);
    }
    return stds;
  }

  List<V4L2InSt> toDartInSts() {
    final sts = <V4L2InSt>[];
    for (var st in V4L2InSt.values) {
      if (this & st.value == 0) {
        continue;
      }
      sts.add(st);
    }
    return sts;
  }

  List<V4L2InCap> toDartInCaps() {
    final caps = <V4L2InCap>[];
    for (var cap in V4L2InCap.values) {
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

  V4L2Field toDartField() {
    return V4L2Field.values.firstWhere((field) => field.value == this);
  }

  V4L2Memory toDartMemory() {
    return V4L2Memory.values.firstWhere((memory) => memory.value == this);
  }

  List<V4L2BufFlag> toDartBufFlags() {
    final flags = <V4L2BufFlag>[];
    for (var flag in V4L2BufFlag.values) {
      if (this & flag.value == 0) {
        continue;
      }
      flags.add(flag);
    }
    return flags;
  }

  V4L2TCType toDartTCType() {
    return V4L2TCType.values.firstWhere((type) => type.value == this);
  }

  List<V4L2TCFlag> toDartTCFlags() {
    final flags = <V4L2TCFlag>[];
    for (var flag in V4L2TCFlag.values) {
      if (this & flag.value == 0) {
        continue;
      }
      flags.add(flag);
    }
    return flags;
  }
}
