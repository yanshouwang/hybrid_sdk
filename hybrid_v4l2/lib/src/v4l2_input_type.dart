import 'ffi.g.dart' as ffi;

/// Input Types
enum V4L2InputType {
  /// This input uses a tuner (RF demodulator).
  tuner(ffi.V4L2_INPUT_TYPE_TUNER),

  /// Analog baseband input, for example CVBS / Composite Video, S-Video, RGB.
  camera(ffi.V4L2_INPUT_TYPE_CAMERA),

  /// This input is a touch device for capturing raw touch data.
  touch(ffi.V4L2_INPUT_TYPE_TOUCH);

  final int value;

  const V4L2InputType(this.value);
}
