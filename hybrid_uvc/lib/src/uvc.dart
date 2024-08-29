import 'hybrid_uvc.dart';
import 'uvc_device.dart';
import 'uvc_device_descriptor.dart';
import 'uvc_frame.dart';
import 'uvc_zoom_rel.dart';

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

  UVCDeviceDescriptor getDevicedescriptor(UVCDevice device);

  void open(UVCDevice device);
  void close(UVCDevice device);

  void startStreaming(UVCDevice device, UVCFrameCallback callback);
  void stopStreaming(UVCDevice device);

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

  int getZoomAbs(UVCDevice device);
  void setZoomAbs(UVCDevice device, int focalLength);
  UVCZoomRel getZoomRel();
  void setZoomRel(UVCZoomRel zoomRel);

  factory UVC() => HybridUVCPlugin.instance;
}
