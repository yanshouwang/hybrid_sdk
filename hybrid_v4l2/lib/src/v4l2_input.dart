import 'v4l2_in_cap.dart';
import 'v4l2_in_st.dart';
import 'v4l2_input_type.dart';
import 'v4l2_std.dart';

/// struct v4l2_input
abstract interface class V4L2Input {
  /// Name of the video input, a NUL-terminated ASCII string, for example: “Vin
  /// (Composite 2)”. This information is intended for the user, preferably the
  /// connector label on the device itself.
  String get name;

  /// Type of the input, see Input Types.
  V4L2InputType get type;

  /// Drivers can enumerate up to 32 video and audio inputs. This field shows which
  /// audio inputs were selectable as audio source if this was the currently
  /// selected video input. It is a bit mask. The LSB corresponds to audio input
  /// 0, the MSB to input 31. Any number of bits can be set, or none.
  ///
  /// When the driver does not enumerate audio inputs no bits must be set.
  /// Applications shall not interpret this as lack of audio support. Some drivers
  /// automatically select audio sources and do not enumerate them since there is
  /// no choice anyway.
  ///
  /// For details on audio inputs and how to select the current input see Audio
  /// Inputs and Outputs.
  int get audioset;

  /// Capture devices can have zero or more tuners (RF demodulators). When the
  /// type is set to V4L2_INPUT_TYPE_TUNER this is an RF connector and this field
  /// identifies the tuner. It corresponds to struct v4l2_tuner field index. For
  /// details on tuners see Tuners and Modulators.
  int get tuner;

  /// Every video input supports one or more different video standards. This field
  /// is a set of all supported standards. For details on video standards and how
  /// to switch see Video Standards.
  List<V4L2Std> get std;

  /// This field provides status information about the input. See Input Status
  /// Flags for flags. With the exception of the sensor orientation bits status is
  /// only valid when this is the current input.
  List<V4L2InSt> get status;

  /// This field provides capabilities for the input. See Input capabilities for
  /// flags.
  List<V4L2InCap> get capabilities;
}
