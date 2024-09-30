import 'v4l2_impl.dart';

abstract interface class V4L2Timeval {
  factory V4L2Timeval() => V4L2TimevalImpl.managed();

  int get tvSec;
  set tvSec(int value);
  int get tvUsec;
  set tvUsec(int value);
}
