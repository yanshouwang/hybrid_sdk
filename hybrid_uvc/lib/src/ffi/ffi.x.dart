// ignore_for_file: camel_case_extensions

import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:hybrid_uvc/src/uvc_device_descriptor.dart';
import 'package:hybrid_uvc/src/uvc_format_descriptor.dart';
import 'package:hybrid_uvc/src/uvc_format_specific_data.dart';
import 'package:hybrid_uvc/src/uvc_format_specifier.dart';
import 'package:hybrid_uvc/src/uvc_frame_descriptor.dart';
import 'package:hybrid_uvc/src/uvc_frame_format.dart';
import 'package:hybrid_uvc/src/uvc_still_frame_descriptor.dart';
import 'package:hybrid_uvc/src/uvc_still_frame_resolution.dart';
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

extension uvc_device_descriptor_x on uvc_device_descriptor {
  UVCDeviceDescriptor get dartValue {
    return UVCDeviceDescriptor(
      vid: idVendor,
      pid: idProduct,
      sn: serialNumber.toDartString(),
      manufacturer: manufacturer.toDartString(),
      product: product.toDartString(),
    );
  }
}

extension uvc_format_desc_x on uvc_format_desc {
  UVCFormatDescriptor get dartValue {
    final frameDescriptors = <UVCFrameDescriptor>[];
    var frameDescPtr = frame_descs;
    while (frameDescPtr != nullptr) {
      final frameDesc = frameDescPtr.ref;
      frameDescriptors.add(frameDesc.dartValue);
      frameDescPtr = frameDesc.next;
    }
    final stillFrameDescriptors = <UVCStillFrameDescriptor>[];
    var stillFrameDescPtr = still_frame_desc;
    while (stillFrameDescPtr != nullptr) {
      final stillFrameDesc = stillFrameDescPtr.ref;
      stillFrameDescriptors.add(stillFrameDesc.dartValue);
      stillFrameDescPtr = stillFrameDesc.next;
    }
    return UVCFormatDescriptor(
      descriptorSubtype:
          uvc_vs_desc_subtype.fromValue(bDescriptorSubtype).dartValue,
      formatIndex: bFormatIndex,
      formatSpecifier: unnamed.dartValue,
      formatSpecificData: unnamed1.dartValue,
      defaultFrameIndex: bDefaultFrameIndex,
      aspectRatioX: bAspectRatioX,
      aspectRatioY: bAspectRatioY,
      interlaceFlags: bmInterlaceFlags,
      copyProtect: bCopyProtect,
      variableSize: bVariableSize,
      frameDescriptors: frameDescriptors,
      stillFrameDescriptors: stillFrameDescriptors,
    );
  }
}

extension uvc_frame_desc_x on uvc_frame_desc {
  UVCFrameDescriptor get dartValue {
    return UVCFrameDescriptor(
      descriptorSubtype:
          uvc_vs_desc_subtype.fromValue(bDescriptorSubtype).dartValue,
      frameIndex: bFrameIndex,
      capabilities: bmCapabilities,
      width: wWidth,
      height: wHeight,
      minBitRate: dwMinBitRate,
      maxBitRate: dwMaxBitRate,
      maxVideoFrameBufferSize: dwMaxVideoFrameBufferSize,
      defaultFrameInterval: dwDefaultFrameInterval,
      minFrameInterval: dwMinFrameInterval,
      maxFrameInterval: dwMaxFrameInterval,
      frameIntervalStep: dwFrameIntervalStep,
      frameIntervalType: bFrameIntervalType,
      bytesPerLine: dwBytesPerLine,
      intervals: intervals.toList(),
    );
  }
}

extension uvc_still_frame_desc_x on uvc_still_frame_desc {
  UVCStillFrameDescriptor get dartValue {
    final imageSizePatterns = <UVCStillFrameResolution>[];
    var imageSizePatternPtr = this.imageSizePatterns;
    while (imageSizePatternPtr != nullptr) {
      final imageSizePattern = imageSizePatternPtr.ref;
      imageSizePatterns.add(imageSizePattern.dartValue);
      imageSizePatternPtr = imageSizePattern.next;
    }
    return UVCStillFrameDescriptor(
      descriptorSubtype:
          uvc_vs_desc_subtype.fromValue(bDescriptorSubtype).dartValue,
      endpointAddress: bEndPointAddress,
      imageSizePatterns: imageSizePatterns,
      compression: bCompression.value,
    );
  }
}

extension uvc_still_frame_res_x on uvc_still_frame_res {
  UVCStillFrameResolution get dartValue {
    return UVCStillFrameResolution(
      resolutionIndex: bResolutionIndex,
      width: wWidth,
      height: wHeight,
    );
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

extension UnnamedUnion1X on UnnamedUnion1 {
  UVCFormatSpecifier get dartValue {
    return UVCFormatSpecifier(
      guid: guidFormat.toList(16),
      fourCC: fourccFormat.toList(4),
    );
  }
}

extension UnnamedUnion2X on UnnamedUnion2 {
  UVCFormatSpecificData get dartValue {
    return UVCFormatSpecificData(
      bitsPerPixel: bBitsPerPixel,
      flags: bmFlags,
    );
  }
}
