import 'uvc_video_streaming_descriptor_subtype.dart';

abstract interface class UVCFrameDescriptor {
  UVCVideoStreamingDescriptorSubtype get subtype;
  int get index;
  int get capabilities;
  int get width;
  int get height;
  int get minimumBitRate;
  int get maximumBitRate;
  int get maximumVideoFrameBufferSize;
  int get defaultInterval;
  int get minimumInterval;
  int get maximumInterval;
  int get intervalStep;
  int get intervalType;
  int get bytesPerLine;
  List<int> get intervals;
}
