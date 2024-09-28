import 'ffi.g.dart' as ffi;

/// enum v4l2_field
enum V4L2Field {
  /// Applications request this field order when any one of the V4L2_FIELD_NONE,
  /// V4L2_FIELD_TOP, V4L2_FIELD_BOTTOM, or V4L2_FIELD_INTERLACED formats is
  /// acceptable. Drivers choose depending on hardware capabilities or e. g. the
  /// requested image size, and return the actual field order. Drivers must never
  /// return V4L2_FIELD_ANY. If multiple field orders are possible the driver must
  /// choose one of the possible field orders during VIDIOC_S_FMT or VIDIOC_TRY_FMT.
  /// struct v4l2_buffer field can never be V4L2_FIELD_ANY.
  any(ffi.v4l2_field.V4L2_FIELD_ANY),

  /// Images are in progressive format, not interlaced. The driver may also indicate
  /// this order when it cannot distinguish between V4L2_FIELD_TOP and V4L2_FIELD_BOTTOM.
  none(ffi.v4l2_field.V4L2_FIELD_NONE),

  /// Images consist of the top (aka odd) field only.
  top(ffi.v4l2_field.V4L2_FIELD_TOP),

  /// Images consist of the bottom (aka even) field only. Applications may wish to
  /// prevent a device from capturing interlaced images because they will have
  /// “comb” or “feathering” artefacts around moving objects.
  bottom(ffi.v4l2_field.V4L2_FIELD_BOTTOM),

  /// Images contain both fields, interleaved line by line. The temporal order of
  /// the fields (whether the top or bottom field is first transmitted) depends on
  /// the current video standard. M/NTSC transmits the bottom field first, all other
  /// standards the top field first.
  interlaced(ffi.v4l2_field.V4L2_FIELD_INTERLACED),

  /// Images contain both fields, the top field lines are stored first in memory,
  /// immediately followed by the bottom field lines. Fields are always stored in
  /// temporal order, the older one first in memory. Image sizes refer to the frame,
  /// not fields.
  seqTB(ffi.v4l2_field.V4L2_FIELD_SEQ_TB),

  /// Images contain both fields, the bottom field lines are stored first in memory,
  /// immediately followed by the top field lines. Fields are always stored in
  /// temporal order, the older one first in memory. Image sizes refer to the frame,
  /// not fields.
  seqBT(ffi.v4l2_field.V4L2_FIELD_SEQ_BT),

  /// The two fields of a frame are passed in separate buffers, in temporal order,
  /// i. e. the older one first. To indicate the field parity (whether the current
  /// field is a top or bottom field) the driver or application, depending on data
  /// direction, must set struct v4l2_buffer field to V4L2_FIELD_TOP or V4L2_FIELD_BOTTOM.
  /// Any two successive fields pair to build a frame. If fields are successive,
  /// without any dropped fields between them (fields can drop individually), can
  /// be determined from the struct v4l2_buffer sequence field. This format cannot
  /// be selected when using the read/write I/O method since there is no way to
  /// communicate if a field was a top or bottom field.
  alternate(ffi.v4l2_field.V4L2_FIELD_ALTERNATE),

  /// Images contain both fields, interleaved line by line, top field first. The top
  /// field is transmitted first.
  interlacedTB(ffi.v4l2_field.V4L2_FIELD_INTERLACED_TB),

  /// Images contain both fields, interleaved line by line, top field first. The
  /// bottom field is transmitted first.
  interlacedBT(ffi.v4l2_field.V4L2_FIELD_INTERLACED_BT);

  final int value;

  const V4L2Field(this.value);
}
