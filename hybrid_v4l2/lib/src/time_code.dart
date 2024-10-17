import 'tc_flag.dart';
import 'tc_type.dart';

/// struct v4l2_timecode
abstract interface class V4L2TimeCode {
  /// Frame rate the timecodes are based on, see Timecode Types.
  V4L2TCType get type;

  /// Timecode flags, see Timecode Flags.
  List<V4L2TCFlag> get flags;

  /// Frame count, 0 ... 23/24/29/49/59, depending on the type of timecode.
  int get frames;

  /// Seconds count, 0 ... 59. This is a binary, not BCD number.
  int get seconds;

  /// Minutes count, 0 ... 59. This is a binary, not BCD number.
  int get minutes;

  /// Hours count, 0 ... 29. This is a binary, not BCD number.
  int get hours;

  /// The “user group” bits from the timecode.
  String get userbits;
}
