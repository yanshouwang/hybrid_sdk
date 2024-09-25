import 'v4l2_device.dart';
import 'v4l2_device_capability.dart';
import 'v4l2_impl.dart';

abstract interface class V4L2 {
  factory V4L2() => V4L2Impl();

  V4L2Device open(String deviceName);
  void close(V4L2Device device);

  V4L2DeviceCapability queryCapability(V4L2Device device);
}
