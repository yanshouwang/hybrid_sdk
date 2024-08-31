import 'uvc_video_streaming_descriptor_subtype.dart';

class UVCFrameDescriptor {
  final UVCVideoStreamingDescriptorSubtype descriptorSubtype;
  final int frameIndex;
  final int capabilities;
  final int width;
  final int height;
  final int minBitRate;
  final int maxBitRate;
  final int maxVideoFrameBufferSize;
  final int defaultFrameInterval;
  final int minFrameInterval;
  final int maxFrameInterval;
  final int frameIntervalStep;
  final int frameIntervalType;
  final int bytesPerLine;
  final List<int> intervals;

  UVCFrameDescriptor({
    required this.descriptorSubtype,
    required this.frameIndex,
    required this.capabilities,
    required this.width,
    required this.height,
    required this.minBitRate,
    required this.maxBitRate,
    required this.maxVideoFrameBufferSize,
    required this.defaultFrameInterval,
    required this.minFrameInterval,
    required this.maxFrameInterval,
    required this.frameIntervalStep,
    required this.frameIntervalType,
    required this.bytesPerLine,
    required this.intervals,
  });
}
