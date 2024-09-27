import 'ffi.g.dart' as ffi;

/// Image Format Description Flags
enum V4L2FmtFlag {
  /// This is a compressed format.
  compressed(ffi.V4L2_FMT_FLAG_COMPRESSED),

  /// This format is not native to the device but emulated through software
  /// (usually libv4l2), where possible try to use a native format instead for
  /// better performance.
  emulated(ffi.V4L2_FMT_FLAG_EMULATED),

  /// The hardware decoder for this compressed bytestream format (aka coded format)
  /// is capable of parsing a continuous bytestream. Applications do not need to
  /// parse the bytestream themselves to find the boundaries between frames/fields.
  ///
  /// This flag can only be used in combination with the V4L2_FMT_FLAG_COMPRESSED
  /// flag, since this applies to compressed formats only. This flag is valid for
  /// stateful decoders only.
  continuousBytestream(ffi.V4L2_FMT_FLAG_CONTINUOUS_BYTESTREAM),

  /// Dynamic resolution switching is supported by the device for this compressed
  /// bytestream format (aka coded format). It will notify the user via the event
  /// V4L2_EVENT_SOURCE_CHANGE when changes in the video parameters are detected.
  ///
  /// This flag can only be used in combination with the V4L2_FMT_FLAG_COMPRESSED
  /// flag, since this applies to compressed formats only. This flag is valid for
  /// stateful codecs only.
  dynResolution(ffi.V4L2_FMT_FLAG_DYN_RESOLUTION),

  /// The hardware encoder supports setting the CAPTURE coded frame interval
  /// separately from the OUTPUT raw frame interval. Setting the OUTPUT raw frame
  /// interval with VIDIOC_S_PARM also sets the CAPTURE coded frame interval to
  /// the same value. If this flag is set, then the CAPTURE coded frame interval
  /// can be set to a different value afterwards. This is typically used for
  /// offline encoding where the OUTPUT raw frame interval is used as a hint for
  /// reserving hardware encoder resources and the CAPTURE coded frame interval
  /// is the actual frame rate embedded in the encoded video stream.
  ///
  /// This flag can only be used in combination with the V4L2_FMT_FLAG_COMPRESSED
  /// flag, since this applies to compressed formats only. This flag is valid for
  /// stateful encoders only.
  encCapFrameInterval(ffi.V4L2_FMT_FLAG_ENC_CAP_FRAME_INTERVAL),

  /// The driver allows the application to try to change the default colorspace.
  /// This flag is relevant only for capture devices. The application can ask to
  /// configure the colorspace of the capture device when calling the VIDIOC_S_FMT
  /// ioctl with V4L2_PIX_FMT_FLAG_SET_CSC set.
  cscColorSpace(ffi.V4L2_FMT_FLAG_CSC_COLORSPACE),

  /// The driver allows the application to try to change the default transfer
  /// function. This flag is relevant only for capture devices. The application
  /// can ask to configure the transfer function of the capture device when calling
  /// the VIDIOC_S_FMT ioctl with V4L2_PIX_FMT_FLAG_SET_CSC set.
  cscXferFunc(ffi.V4L2_FMT_FLAG_CSC_XFER_FUNC),

  /// The driver allows the application to try to change the default Y’CbCr encoding.
  /// This flag is relevant only for capture devices. The application can ask to
  /// configure the Y’CbCr encoding of the capture device when calling the
  /// VIDIOC_S_FMT ioctl with V4L2_PIX_FMT_FLAG_SET_CSC set.
  cscYCbCrEnc(ffi.V4L2_FMT_FLAG_CSC_YCBCR_ENC),

  /// The driver allows the application to try to change the default HSV encoding.
  /// This flag is relevant only for capture devices. The application can ask to
  /// configure the HSV encoding of the capture device when calling the VIDIOC_S_FMT
  /// ioctl with V4L2_PIX_FMT_FLAG_SET_CSC set.
  cscHSVEnc(ffi.V4L2_FMT_FLAG_CSC_HSV_ENC),

  /// The driver allows the application to try to change the default quantization.
  /// This flag is relevant only for capture devices. The application can ask to
  /// configure the quantization of the capture device when calling the VIDIOC_S_FMT
  /// ioctl with V4L2_PIX_FMT_FLAG_SET_CSC set.
  cscQuantization(ffi.V4L2_FMT_FLAG_CSC_QUANTIZATION);

  final int value;

  const V4L2FmtFlag(this.value);
}
