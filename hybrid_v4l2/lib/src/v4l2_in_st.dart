import 'ffi.g.dart' as ffi;

/// Input Status Flags
enum V4L2InSt {
  /* General */
  /// Attached device is off.
  noPower(ffi.V4L2_IN_ST_NO_POWER),

  ///
  noSignal(ffi.V4L2_IN_ST_NO_SIGNAL),

  /// The hardware supports color decoding, but does not detect color modulation
  /// in the signal.
  noColor(ffi.V4L2_IN_ST_NO_COLOR),
  /* Sensor Orientation */
  /// The input is connected to a device that produces a signal that is flipped
  /// horizontally and does not correct this before passing the signal to userspace.
  hflip(ffi.V4L2_IN_ST_HFLIP),

  /// The input is connected to a device that produces a signal that is flipped
  /// vertically and does not correct this before passing the signal to userspace.
  /// .. note:: A 180 degree rotation is the same as HFLIP | VFLIP
  vflip(ffi.V4L2_IN_ST_VFLIP),

  /* Analog Video */
  /// No horizontal sync lock.
  noHLock(ffi.V4L2_IN_ST_NO_H_LOCK),

  /// A color killer circuit automatically disables color decoding when it detects
  /// no color modulation. When this flag is set the color killer is enabled and
  /// has shut off color decoding.
  colorKill(ffi.V4L2_IN_ST_COLOR_KILL),

  /// No vertical sync lock.
  noVLock(ffi.V4L2_IN_ST_NO_V_LOCK),

  /// No standard format lock in case of auto-detection format by the component.
  noStdLock(ffi.V4L2_IN_ST_NO_STD_LOCK),

  /* Digital Video */
  /// No synchronization lock.
  noSync(ffi.V4L2_IN_ST_NO_SYNC),

  /// No equalizer lock.
  noEqu(ffi.V4L2_IN_ST_NO_EQU),

  /// Carrier recovery failed.
  noCarrier(ffi.V4L2_IN_ST_NO_CARRIER),

  /* VCR and Set-Top Box */
  /// Macrovision is an analog copy prevention system mangling the video signal
  /// to confuse video recorders. When this flag is set Macrovision has been
  /// detected.
  macrovision(ffi.V4L2_IN_ST_MACROVISION),

  /// Conditional access denied.
  noAccess(ffi.V4L2_IN_ST_NO_ACCESS),

  /// VTR time constant. [?]
  vtr(ffi.V4L2_IN_ST_VTR);

  final int value;

  const V4L2InSt(this.value);
}
