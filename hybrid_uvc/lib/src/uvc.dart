import 'hybrid_uvc.dart';
import 'uvc_device.dart';
import 'uvc_device_descriptor.dart';
import 'uvc_format_descriptor.dart';
import 'uvc_frame.dart';
import 'uvc_frame_format.dart';
import 'uvc_stream_control.dart';
import 'uvc_zoom_relative.dart';

typedef UVCFrameCallback = void Function(UVCFrame frame);

abstract interface class UVC {
  List<UVCDevice> findDevices({
    int? vid,
    int? pid,
    String? sn,
  });

  UVCDevice findDevice({
    int? vid,
    int? pid,
    String? sn,
  });

  UVCDeviceDescriptor getDeviceDescriptor(UVCDevice device);

  void open(UVCDevice device);
  void close(UVCDevice device);

  List<UVCFormatDescriptor> getFormatDescriptors(UVCDevice device);

  UVCStreamControl getStreamControl(
    UVCDevice device, {
    required UVCFrameFormat format,
    required int width,
    required int height,
    required int fps,
  });
  void startStreaming(
    UVCDevice device, {
    required UVCStreamControl control,
    required UVCFrameCallback callback,
  });
  void stopStreaming(UVCDevice device);

  int getZoomAbs(UVCDevice device);
  void setZoomAbs(UVCDevice device, int focalLength);
  UVCZoomRelative getZoomRel();
  void setZoomRel(UVCZoomRelative zoomRel);

  UVCFrame mjpeg2RGB(UVCFrame frame);
  UVCFrame mjpeg2Gray(UVCFrame frame);
  UVCFrame yuyv2RGB(UVCFrame frame);
  UVCFrame yuyv2BGR(UVCFrame frame);
  UVCFrame yuyv2Y(UVCFrame frame);
  UVCFrame yuyv2UV(UVCFrame frame);
  UVCFrame uyvy2RGB(UVCFrame frame);
  UVCFrame uyvy2BGR(UVCFrame frame);
  UVCFrame any2RGB(UVCFrame frame);
  UVCFrame any2BGR(UVCFrame frame);

  factory UVC() => HybridUVCPlugin.instance;
}
