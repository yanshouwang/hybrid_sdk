import 'uvc_still_frame_resolution.dart';
import 'uvc_video_streaming_descriptor_subtype.dart';

abstract interface class UVCStillFrameDescriptor {
  UVCVideoStreamingDescriptorSubtype get subtype;
  int get endpointAddress;
  List<UVCStillFrameResolution> get imageSizePatterns;
  int get compression;
}
