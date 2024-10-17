import 'ffi.v4l2.dart' as ffi;

/// Control Flags
enum V4L2CtrlFlag {
  /// This control is permanently disabled and should be ignored by the application.
  /// Any attempt to change the control will result in an EINVAL error code.
  disabled(ffi.V4L2_CTRL_FLAG_DISABLED),

  /// This control is temporarily unchangeable, for example because another
  /// application took over control of the respective resource. Such controls may
  /// be displayed specially in a user interface. Attempts to change the control
  /// may result in an EBUSY error code.
  grabbed(ffi.V4L2_CTRL_FLAG_GRABBED),

  /// This control is permanently readable only. Any attempt to change the control
  /// will result in an EINVAL error code.
  readOnly(ffi.V4L2_CTRL_FLAG_READ_ONLY),

  /// A hint that changing this control may affect the value of other controls
  /// within the same control class. Applications should update their user interface
  /// accordingly.
  update(ffi.V4L2_CTRL_FLAG_UPDATE),

  /// This control is not applicable to the current configuration and should be
  /// displayed accordingly in a user interface. For example the flag may be set
  /// on a MPEG audio level 2 bitrate control when MPEG audio encoding level 1
  /// was selected with another control.
  inactive(ffi.V4L2_CTRL_FLAG_INACTIVE),

  /// A hint that this control is best represented as a slider-like element in a
  /// user interface.
  slider(ffi.V4L2_CTRL_FLAG_SLIDER),

  /// This control is permanently writable only. Any attempt to read the control
  /// will result in an EACCES error code error code. This flag is typically present
  /// for relative controls or action controls where writing a value will cause
  /// the device to carry out a given action (e. g. motor control) but no meaningful
  /// value can be returned.
  writeOnly(ffi.V4L2_CTRL_FLAG_WRITE_ONLY),

  /// This control is volatile, which means that the value of the control changes
  /// continuously. A typical example would be the current gain value if the device
  /// is in auto-gain mode. In such a case the hardware calculates the gain value
  /// based on the lighting conditions which can change over time.
  ///
  /// > *Note*
  /// >
  /// > Setting a new value for a volatile control will be ignored unless
  /// > V4L2_CTRL_FLAG_EXECUTE_ON_WRITE is also set.
  /// >
  /// > Setting a new value for a volatile control will never trigger a
  /// > V4L2_EVENT_CTRL_CH_VALUE event.
  volatile(ffi.V4L2_CTRL_FLAG_VOLATILE),

  /// This control has a pointer type, so its value has to be accessed using one
  /// of the pointer fields of struct v4l2_ext_control. This flag is set for controls
  /// that are an array, string, or have a compound type. In all cases you have
  /// to set a pointer to memory containing the payload of the control.
  hasPayload(ffi.V4L2_CTRL_FLAG_HAS_PAYLOAD),

  /// The value provided to the control will be propagated to the driver even if
  /// it remains constant. This is required when the control represents an action
  /// on the hardware. For example: clearing an error flag or triggering the flash.
  /// All the controls of the type V4L2_CTRL_TYPE_BUTTON have this flag set.
  executeOnWrite(ffi.V4L2_CTRL_FLAG_EXECUTE_ON_WRITE),
  modifyLayout(ffi.V4L2_CTRL_FLAG_MODIFY_LAYOUT),
  dynamicArray(ffi.V4L2_CTRL_FLAG_DYNAMIC_ARRAY),
  nextCtrl(ffi.V4L2_CTRL_FLAG_NEXT_CTRL),
  nextCompound(ffi.V4L2_CTRL_FLAG_NEXT_COMPOUND);

  final int value;

  const V4L2CtrlFlag(this.value);
}
