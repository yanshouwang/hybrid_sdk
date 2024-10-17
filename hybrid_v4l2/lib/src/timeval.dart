import 'dart:ffi' as ffi;

import 'impl.dart';

abstract interface class V4L2Timeval implements ffi.Finalizable {
  factory V4L2Timeval() => V4L2TimevalImpl.managed();

  int get tvSec;
  set tvSec(int value);
  int get tvUsec;
  set tvUsec(int value);
}
