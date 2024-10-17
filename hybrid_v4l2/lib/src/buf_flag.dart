import 'ffi.v4l2.dart' as ffi;

/// Buffer Flags
enum V4L2BufFlag {
  /// The buffer resides in device memory and has been mapped into the application’s
  /// address space, see Streaming I/O (Memory Mapping) for details. Drivers set
  /// or clear this flag when the ioctl VIDIOC_QUERYBUF, ioctl VIDIOC_QBUF,
  /// VIDIOC_DQBUF or VIDIOC_DQBUF ioctl is called. Set by the driver.
  mapped(ffi.V4L2_BUF_FLAG_MAPPED),

  /// Internally drivers maintain two buffer queues, an incoming and outgoing
  /// queue. When this flag is set, the buffer is currently on the incoming queue.
  /// It automatically moves to the outgoing queue after the buffer has been filled
  /// (capture devices) or displayed (output devices). Drivers set or clear this
  /// flag when the VIDIOC_QUERYBUF ioctl is called. After (successful) calling
  /// the VIDIOC_QBUFioctl it is always set and after VIDIOC_DQBUF always cleared.
  queued(ffi.V4L2_BUF_FLAG_QUEUED),

  /// When this flag is set, the buffer is currently on the outgoing queue, ready
  /// to be dequeued from the driver. Drivers set or clear this flag when the
  /// VIDIOC_QUERYBUF ioctl is called. After calling the VIDIOC_QBUF or VIDIOC_DQBUF
  /// it is always cleared. Of course a buffer cannot be on both queues at the
  /// same time, the V4L2_BUF_FLAG_QUEUED and V4L2_BUF_FLAG_DONE flag are mutually
  /// exclusive. They can be both cleared however, then the buffer is in “dequeued”
  /// state, in the application domain so to say.
  done(ffi.V4L2_BUF_FLAG_DONE),

  /// Drivers set or clear this flag when calling the VIDIOC_DQBUF ioctl. It may
  /// be set by video capture devices when the buffer contains a compressed image
  /// which is a key frame (or field), i. e. can be decompressed on its own. Also
  /// known as an I-frame. Applications can set this bit when type refers to an
  /// output stream.
  keyframe(ffi.V4L2_BUF_FLAG_KEYFRAME),

  /// Similar to V4L2_BUF_FLAG_KEYFRAME this flags predicted frames or fields
  /// which contain only differences to a previous key frame. Applications can
  /// set this bit when type refers to an output stream.
  pframe(ffi.V4L2_BUF_FLAG_PFRAME),

  /// Similar to V4L2_BUF_FLAG_KEYFRAME this flags a bi-directional predicted
  /// frame or field which contains only the differences between the current frame
  /// and both the preceding and following key frames to specify its content.
  /// Applications can set this bit when type refers to an output stream.
  bframe(ffi.V4L2_BUF_FLAG_BFRAME),

  /// When this flag is set, the buffer has been dequeued successfully, although
  /// the data might have been corrupted. This is recoverable, streaming may
  /// continue as normal and the buffer may be reused normally. Drivers set this
  /// flag when the VIDIOC_DQBUF ioctl is called.
  error(ffi.V4L2_BUF_FLAG_ERROR),

  /// This buffer is part of a request that hasn’t been queued yet.
  inRequest(ffi.V4L2_BUF_FLAG_IN_REQUEST),

  /// The timecode field is valid. Drivers set or clear this flag when the
  /// VIDIOC_DQBUF ioctl is called. Applications can set this bit and the
  /// corresponding timecode structure when type refers to an output stream.
  timecode(ffi.V4L2_BUF_FLAG_TIMECODE),

  /// Only valid if struct v4l2_requestbuffers flag V4L2_BUF_CAP_SUPPORTS_M2M_HOLD_CAPTURE_BUF
  /// is set. It is typically used with stateless decoders where multiple output
  /// buffers each decode to a slice of the decoded frame. Applications can set
  /// this flag when queueing the output buffer to prevent the driver from
  /// dequeueing the capture buffer after the output buffer has been decoded (i.e.
  /// the capture buffer is ‘held’). If the timestamp of this output buffer differs
  /// from that of the previous output buffer, then that indicates the start of
  /// a new frame and the previously held capture buffer is dequeued.
  m2mHoldCaptureBuf(ffi.V4L2_BUF_FLAG_M2M_HOLD_CAPTURE_BUF),

  /// The buffer has been prepared for I/O and can be queued by the application.
  /// Drivers set or clear this flag when the VIDIOC_QUERYBUF, VIDIOC_PREPARE_BUF,
  /// VIDIOC_QBUF or VIDIOC_DQBUF ioctl is called.
  prepared(ffi.V4L2_BUF_FLAG_PREPARED),

  /// Caches do not have to be invalidated for this buffer. Typically applications
  /// shall use this flag if the data captured in the buffer is not going to be
  /// touched by the CPU, instead the buffer will, probably, be passed on to a
  /// DMA-capable hardware unit for further processing or output. This flag is
  /// ignored unless the queue is used for memory mapping streaming I/O and reports
  /// V4L2_BUF_CAP_SUPPORTS_MMAP_CACHE_HINTS capability.
  noCacheInvalidate(ffi.V4L2_BUF_FLAG_NO_CACHE_INVALIDATE),

  /// Caches do not have to be cleaned for this buffer. Typically applications
  /// shall use this flag for output buffers if the data in this buffer has not
  /// been created by the CPU but by some DMA-capable unit, in which case caches
  /// have not been used. This flag is ignored unless the queue is used for memory
  /// mapping streaming I/O and reports V4L2_BUF_CAP_SUPPORTS_MMAP_CACHE_HINTS
  /// capability.
  noCacheClean(ffi.V4L2_BUF_FLAG_NO_CACHE_CLEAN),

  /// Mask for timestamp types below. To test the timestamp type, mask out bits
  /// not belonging to timestamp type by performing a logical and operation with
  /// buffer flags and timestamp mask.
  timestampMask(ffi.V4L2_BUF_FLAG_TIMESTAMP_MASK),

  /// Unknown timestamp type. This type is used by drivers before Linux 3.9 and
  /// may be either monotonic (see below) or realtime (wall clock). Monotonic
  /// clock has been favoured in embedded systems whereas most of the drivers use
  /// the realtime clock. Either kinds of timestamps are available in user space
  /// via clock_gettime() using clock IDs CLOCK_MONOTONIC and CLOCK_REALTIME,
  /// respectively.
  timestampUnknown(ffi.V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN),

  /// The buffer timestamp has been taken from the CLOCK_MONOTONIC clock. To access
  /// the same clock outside V4L2, use clock_gettime().
  timestampMonotonic(ffi.V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC),

  /// The CAPTURE buffer timestamp has been taken from the corresponding OUTPUT
  /// buffer. This flag applies only to mem2mem devices.
  timestampCopy(ffi.V4L2_BUF_FLAG_TIMESTAMP_COPY),

  /// Mask for timestamp sources below. The timestamp source defines the point of
  /// time the timestamp is taken in relation to the frame. Logical ‘and’ operation
  /// between the flags field and V4L2_BUF_FLAG_TSTAMP_SRC_MASK produces the value
  /// of the timestamp source. Applications must set the timestamp source when
  /// type refers to an output stream and V4L2_BUF_FLAG_TIMESTAMP_COPY is set.
  tstampSrcMask(ffi.V4L2_BUF_FLAG_TSTAMP_SRC_MASK),

  /// End Of Frame. The buffer timestamp has been taken when the last pixel of
  /// the frame has been received or the last pixel of the frame has been transmitted.
  /// In practice, software generated timestamps will typically be read from the
  /// clock a small amount of time after the last pixel has been received or
  /// transmitten, depending on the system and other activity in it.
  tstampSrcEOF(ffi.V4L2_BUF_FLAG_TSTAMP_SRC_EOF),

  /// Start Of Exposure. The buffer timestamp has been taken when the exposure of
  /// the frame has begun. This is only valid for the V4L2_BUF_TYPE_VIDEO_CAPTURE
  /// buffer type.
  tstampSrcSOE(ffi.V4L2_BUF_FLAG_TSTAMP_SRC_SOE),

  /// Last buffer produced by the hardware. mem2mem codec drivers set this flag
  /// on the capture queue for the last buffer when the ioctl VIDIOC_QUERYBUF or
  /// VIDIOC_DQBUF ioctl is called. Due to hardware limitations, the last buffer
  /// may be empty. In this case the driver will set the bytesused field to 0,
  /// regardless of the format. Any subsequent call to the VIDIOC_DQBUF ioctl will
  /// not block anymore, but return an EPIPE error code.
  last(ffi.V4L2_BUF_FLAG_LAST),

  /// The request_fd field contains a valid file descriptor.
  requestFd(ffi.V4L2_BUF_FLAG_REQUEST_FD);

  final int value;

  const V4L2BufFlag(this.value);
}
