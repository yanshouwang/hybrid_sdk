import 'package:hybrid_logging/hybrid_logging.dart';

import 'hybrid_uvc_plugin.dart';
import 'uvc_device.dart';
import 'uvc_device_descriptor.dart';
import 'uvc_format_descriptor.dart';
import 'uvc_frame.dart';
import 'uvc_frame_format.dart';
import 'uvc_input_terminal.dart';
import 'uvc_request_code.dart';
import 'uvc_stream_control.dart';
import 'uvc_zoom_relative.dart';

typedef UVCFrameCallback = void Function(UVCFrame frame);

abstract interface class UVC implements LogController {
  static UVC? _instance;

  factory UVC() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = HybridUVCPlugin.instance.createUVC();
    }
    return instance;
  }

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

  UVCDevice wrap(int fileDescriptor);

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

  List<UVCInputTerminal> getInputTerminals(UVCDevice device);

  int getZoomAbsolute(
    UVCDevice device, {
    required UVCRequestCode requestCode,
  });
  void setZoomAbsolute(
    UVCDevice device, {
    required int focalLength,
  });

  UVCZoomRelative getZoomRelative(
    UVCDevice device, {
    required UVCRequestCode requestCode,
  });
  void setZoomRelative(
    UVCDevice device, {
    required int zoomRelative,
    required int digitalZoom,
    required int speed,
  });

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
}
