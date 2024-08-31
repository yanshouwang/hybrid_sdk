import 'uvc_still_frame_resolution.dart';
import 'uvc_video_streaming_descriptor_subtype.dart';

class UVCStillFrameDescriptor {
  final UVCVideoStreamingDescriptorSubtype descriptorSubtype;
  final int endpointAddress;
  final List<UVCStillFrameResolution> imageSizePatterns;
  final int compression;

  UVCStillFrameDescriptor({
    required this.descriptorSubtype,
    required this.endpointAddress,
    required this.imageSizePatterns,
    required this.compression,
  });
}
