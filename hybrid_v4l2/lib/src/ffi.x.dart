import 'dart:ffi' as ffi;

import 'ffi.hybrid_v4l2.dart' as ffi;
import 'ffi.yuv.dart' as ffi;

import 'cid.dart';
import 'ctrl_class.dart';
import 'ctrl_flag.dart';
import 'ctrl_type.dart';
import 'ctrl_which.dart';
import 'buf_flag.dart';
import 'buf_type.dart';
import 'cap.dart';
import 'field.dart';
import 'fmt_flag.dart';
import 'in_cap.dart';
import 'in_st.dart';
import 'input_type.dart';
import 'memory.dart';
import 'pix_fmt.dart';
import 'std.dart';
import 'tc_flag.dart';
import 'tc_type.dart';

final _dylibHybridV4L2 = ffi.DynamicLibrary.open('libhybrid_v4l2.so');
final _dylibYUV = ffi.DynamicLibrary.open('libyuv.so');
// final _dylibHybridV4L2 = ffi.DynamicLibrary.open(
//     '/home/orangepi/dev/hybrid_sdk/hybrid_v4l2/example/build/elinux/arm64/debug/bundle/lib/libhybrid_v4l2.so');

final libHybridV4L2 = ffi.LibHybridV4L2(_dylibHybridV4L2);
final libYUV = ffi.LibYUV(_dylibYUV);

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

extension CharArrayX on ffi.Array<ffi.Char> {
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

extension UinsignedIntArrayX on ffi.Array<ffi.UnsignedInt> {
  List<int> toDart(int count) {
    final values = <int>[];
    for (var i = 0; i < count; i++) {
      final value = this[i];
      values.add(value);
    }
    return values;
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

  V4L2CId toDartCId() {
    return V4L2CId.values.firstWhere((cid) => cid.value == this);
  }

  V4L2CtrlType toDartCtrlType() {
    return V4L2CtrlType.values.firstWhere((type) => type.value == this);
  }

  List<V4L2CtrlFlag> toDartCtrlFlags() {
    final flags = <V4L2CtrlFlag>[];
    for (var flag in V4L2CtrlFlag.values) {
      if (this & flag.value == 0) {
        continue;
      }
      flags.add(flag);
    }
    return flags;
  }

  V4L2CtrlClass toDartCtrlClass() {
    return V4L2CtrlClass.values
        .firstWhere((ctrlClass) => ctrlClass.value == this);
  }

  V4L2CtrlWhich toDartCtrlWhich() {
    return V4L2CtrlWhich.values.firstWhere((which) => which.value == this);
  }
}
