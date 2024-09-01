import 'uvc_format_specific_data.dart';
import 'uvc_format_specifier.dart';
import 'uvc_frame_descriptor.dart';
import 'uvc_still_frame_descriptor.dart';
import 'uvc_video_streaming_descriptor_subtype.dart';

abstract interface class UVCFormatDescriptor {
  UVCVideoStreamingDescriptorSubtype get subtype;
  int get index;
  UVCFormatSpecifier get specifier;
  UVCFormatSpecificData get specificData;
  int get defaultIndex;
  int get aspectRatioX;
  int get aspectRatioY;
  int get interlaceFlags;
  int get copyProtect;
  int get variableSize;
  List<UVCFrameDescriptor> get frameDescriptors;
  List<UVCStillFrameDescriptor> get stillFrameDescriptors;
}
