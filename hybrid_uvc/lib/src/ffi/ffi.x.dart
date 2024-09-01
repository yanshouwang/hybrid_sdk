// ignore_for_file: camel_case_types, camel_case_extensions

import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:hybrid_uvc/src/uvc_frame_format.dart';
import 'package:hybrid_uvc/src/uvc_input_terminal_type.dart';
import 'package:hybrid_uvc/src/uvc_request_code.dart';
import 'package:hybrid_uvc/src/uvc_video_streaming_descriptor_subtype.dart';

import 'ffi.g.dart';

extension UVCFrameFormatX on UVCFrameFormat {
  uvc_frame_format get ffiValue {
    switch (this) {
      case UVCFrameFormat.unknown:
        return uvc_frame_format.UVC_FRAME_FORMAT_UNKNOWN;
      case UVCFrameFormat.any:
        return uvc_frame_format.UVC_FRAME_FORMAT_ANY;
      case UVCFrameFormat.uncompressed:
        return uvc_frame_format.UVC_FRAME_FORMAT_UNCOMPRESSED;
      case UVCFrameFormat.commpressed:
        return uvc_frame_format.UVC_FRAME_FORMAT_COMPRESSED;
      case UVCFrameFormat.yuyv:
        return uvc_frame_format.UVC_FRAME_FORMAT_YUYV;
      case UVCFrameFormat.uyvy:
        return uvc_frame_format.UVC_FRAME_FORMAT_UYVY;
      case UVCFrameFormat.rgb:
        return uvc_frame_format.UVC_FRAME_FORMAT_RGB;
      case UVCFrameFormat.bgr:
        return uvc_frame_format.UVC_FRAME_FORMAT_BGR;
      case UVCFrameFormat.mjpeg:
        return uvc_frame_format.UVC_FRAME_FORMAT_MJPEG;
      case UVCFrameFormat.h264:
        return uvc_frame_format.UVC_FRAME_FORMAT_H264;
      case UVCFrameFormat.gray8:
        return uvc_frame_format.UVC_FRAME_FORMAT_GRAY8;
      case UVCFrameFormat.gray16:
        return uvc_frame_format.UVC_FRAME_FORMAT_GRAY16;
      case UVCFrameFormat.by8:
        return uvc_frame_format.UVC_FRAME_FORMAT_BY8;
      case UVCFrameFormat.ba81:
        return uvc_frame_format.UVC_FRAME_FORMAT_BA81;
      case UVCFrameFormat.sgrbg8:
        return uvc_frame_format.UVC_FRAME_FORMAT_SGRBG8;
      case UVCFrameFormat.sgbrg8:
        return uvc_frame_format.UVC_FRAME_FORMAT_SGBRG8;
      case UVCFrameFormat.srggb8:
        return uvc_frame_format.UVC_FRAME_FORMAT_SRGGB8;
      case UVCFrameFormat.sbggr8:
        return uvc_frame_format.UVC_FRAME_FORMAT_SBGGR8;
      case UVCFrameFormat.nv12:
        return uvc_frame_format.UVC_FRAME_FORMAT_NV12;
      case UVCFrameFormat.p010:
        return uvc_frame_format.UVC_FRAME_FORMAT_P010;
      case UVCFrameFormat.count:
        return uvc_frame_format.UVC_FRAME_FORMAT_COUNT;
    }
  }
}

extension UVCRequestCodeX on UVCRequestCode {
  uvc_req_code get ffiValue {
    switch (this) {
      case UVCRequestCode.undefined:
        return uvc_req_code.UVC_RC_UNDEFINED;
      case UVCRequestCode.setCurrent:
        return uvc_req_code.UVC_SET_CUR;
      case UVCRequestCode.getCurrent:
        return uvc_req_code.UVC_GET_CUR;
      case UVCRequestCode.getMinimum:
        return uvc_req_code.UVC_GET_MIN;
      case UVCRequestCode.getMaximum:
        return uvc_req_code.UVC_GET_MAX;
      case UVCRequestCode.getResolution:
        return uvc_req_code.UVC_GET_RES;
      case UVCRequestCode.getLength:
        return uvc_req_code.UVC_GET_LEN;
      case UVCRequestCode.getInfo:
        return uvc_req_code.UVC_GET_INFO;
      case UVCRequestCode.getDefault:
        return uvc_req_code.UVC_GET_DEF;
    }
  }
}

extension Uint8ArrayX on Array<Uint8> {
  Uint8List toList(int length) {
    final elements = <int>[];
    for (var i = 0; i < length; i++) {
      final item = this[i];
      elements.add(item);
    }
    return Uint8List.fromList(elements);
  }
}

extension UInt32PointerX on Pointer<Uint32> {
  Uint32List toList() {
    final elements = <int>[];
    var i = 0;
    while (true) {
      final item = this[i];
      if (item == 0) {
        break;
      }
      elements.add(item);
      i++;
    }
    return Uint32List.fromList(elements);
  }
}

extension CharPointerX on Pointer<Char> {
  String? toDartString() {
    final utf8Ptr = cast<Utf8>();
    return utf8Ptr == nullptr ? null : utf8Ptr.toDartString();
  }
}

extension uvc_vs_desc_subtype_x on uvc_vs_desc_subtype {
  UVCVideoStreamingDescriptorSubtype get dartValue {
    switch (this) {
      case uvc_vs_desc_subtype.UVC_VS_UNDEFINED:
        return UVCVideoStreamingDescriptorSubtype.undefined;
      case uvc_vs_desc_subtype.UVC_VS_INPUT_HEADER:
        return UVCVideoStreamingDescriptorSubtype.inputHeader;
      case uvc_vs_desc_subtype.UVC_VS_OUTPUT_HEADER:
        return UVCVideoStreamingDescriptorSubtype.outputHeader;
      case uvc_vs_desc_subtype.UVC_VS_STILL_IMAGE_FRAME:
        return UVCVideoStreamingDescriptorSubtype.stillImageFrame;
      case uvc_vs_desc_subtype.UVC_VS_FORMAT_UNCOMPRESSED:
        return UVCVideoStreamingDescriptorSubtype.fromatUncompressed;
      case uvc_vs_desc_subtype.UVC_VS_FRAME_UNCOMPRESSED:
        return UVCVideoStreamingDescriptorSubtype.frameUncompressed;
      case uvc_vs_desc_subtype.UVC_VS_FORMAT_MJPEG:
        return UVCVideoStreamingDescriptorSubtype.formatMJPEG;
      case uvc_vs_desc_subtype.UVC_VS_FRAME_MJPEG:
        return UVCVideoStreamingDescriptorSubtype.frameMJPEG;
      case uvc_vs_desc_subtype.UVC_VS_FORMAT_MPEG2TS:
        return UVCVideoStreamingDescriptorSubtype.formatMPEG2TS;
      case uvc_vs_desc_subtype.UVC_VS_FORMAT_DV:
        return UVCVideoStreamingDescriptorSubtype.formatDV;
      case uvc_vs_desc_subtype.UVC_VS_COLORFORMAT:
        return UVCVideoStreamingDescriptorSubtype.colorformat;
      case uvc_vs_desc_subtype.UVC_VS_FORMAT_FRAME_BASED:
        return UVCVideoStreamingDescriptorSubtype.formatFrameBased;
      case uvc_vs_desc_subtype.UVC_VS_FRAME_FRAME_BASED:
        return UVCVideoStreamingDescriptorSubtype.frameFrameBased;
      case uvc_vs_desc_subtype.UVC_VS_FORMAT_STREAM_BASED:
        return UVCVideoStreamingDescriptorSubtype.formatStreamBased;
    }
  }
}

extension uvc_it_type_x on uvc_it_type {
  UVCInputTerminalType get dartValue {
    switch (this) {
      case uvc_it_type.UVC_ITT_VENDOR_SPECIFIC:
        return UVCInputTerminalType.vendorSpecific;
      case uvc_it_type.UVC_ITT_CAMERA:
        return UVCInputTerminalType.camera;
      case uvc_it_type.UVC_ITT_MEDIA_TRANSPORT_INPUT:
        return UVCInputTerminalType.mediaTransportInput;
    }
  }
}

extension uvc_frame_format_x on uvc_frame_format {
  UVCFrameFormat get dartValue {
    switch (this) {
      case uvc_frame_format.UVC_FRAME_FORMAT_UNKNOWN:
        return UVCFrameFormat.unknown;
      case uvc_frame_format.UVC_FRAME_FORMAT_UNCOMPRESSED:
        return UVCFrameFormat.uncompressed;
      case uvc_frame_format.UVC_FRAME_FORMAT_COMPRESSED:
        return UVCFrameFormat.commpressed;
      case uvc_frame_format.UVC_FRAME_FORMAT_YUYV:
        return UVCFrameFormat.yuyv;
      case uvc_frame_format.UVC_FRAME_FORMAT_UYVY:
        return UVCFrameFormat.uyvy;
      case uvc_frame_format.UVC_FRAME_FORMAT_RGB:
        return UVCFrameFormat.rgb;
      case uvc_frame_format.UVC_FRAME_FORMAT_BGR:
        return UVCFrameFormat.bgr;
      case uvc_frame_format.UVC_FRAME_FORMAT_MJPEG:
        return UVCFrameFormat.mjpeg;
      case uvc_frame_format.UVC_FRAME_FORMAT_H264:
        return UVCFrameFormat.h264;
      case uvc_frame_format.UVC_FRAME_FORMAT_GRAY8:
        return UVCFrameFormat.gray8;
      case uvc_frame_format.UVC_FRAME_FORMAT_GRAY16:
        return UVCFrameFormat.gray16;
      case uvc_frame_format.UVC_FRAME_FORMAT_BY8:
        return UVCFrameFormat.by8;
      case uvc_frame_format.UVC_FRAME_FORMAT_BA81:
        return UVCFrameFormat.ba81;
      case uvc_frame_format.UVC_FRAME_FORMAT_SGRBG8:
        return UVCFrameFormat.sgrbg8;
      case uvc_frame_format.UVC_FRAME_FORMAT_SGBRG8:
        return UVCFrameFormat.sgbrg8;
      case uvc_frame_format.UVC_FRAME_FORMAT_SRGGB8:
        return UVCFrameFormat.srggb8;
      case uvc_frame_format.UVC_FRAME_FORMAT_SBGGR8:
        return UVCFrameFormat.sbggr8;
      case uvc_frame_format.UVC_FRAME_FORMAT_NV12:
        return UVCFrameFormat.nv12;
      case uvc_frame_format.UVC_FRAME_FORMAT_P010:
        return UVCFrameFormat.p010;
      case uvc_frame_format.UVC_FRAME_FORMAT_COUNT:
        return UVCFrameFormat.count;
    }
  }
}

extension timeval_x on timeval {
  DateTime get dartValue {
    final millisecondsSinceEpoch = tv_sec * 1000 * 1000 + tv_usec;
    return DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch,
      isUtc: true,
    );
  }
}

extension timespec_x on timespec {
  DateTime get dartValue {
    final millisecondsSinceEpoch = tv_sec * 1000 * 1000 + tv_nsec ~/ 1000;
    return DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch,
      isUtc: true,
    );
  }
}
