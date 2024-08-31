import 'uvc_format_specific_data.dart';
import 'uvc_format_specifier.dart';
import 'uvc_frame_descriptor.dart';
import 'uvc_still_frame_descriptor.dart';
import 'uvc_video_streaming_descriptor_subtype.dart';

final class UVCFormatDescriptor {
  final UVCVideoStreamingDescriptorSubtype descriptorSubtype;
  final int formatIndex;
  final UVCFormatSpecifier formatSpecifier;
  final UVCFormatSpecificData formatSpecificData;
  final int defaultFrameIndex;
  final int aspectRatioX;
  final int aspectRatioY;
  final int interlaceFlags;
  final int copyProtect;
  final int variableSize;
  final List<UVCFrameDescriptor> frameDescriptors;
  final List<UVCStillFrameDescriptor> stillFrameDescriptors;

  UVCFormatDescriptor({
    required this.descriptorSubtype,
    required this.formatIndex,
    required this.formatSpecifier,
    required this.formatSpecificData,
    required this.defaultFrameIndex,
    required this.aspectRatioX,
    required this.aspectRatioY,
    required this.interlaceFlags,
    required this.copyProtect,
    required this.variableSize,
    required this.frameDescriptors,
    required this.stillFrameDescriptors,
  });
}
