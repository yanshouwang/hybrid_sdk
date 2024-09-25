import 'dart:ffi';

import 'package:ffi/ffi.dart' as ffi;

import 'ffi.g.dart' as ffi;
import 'ffi.x.dart' as ffi;
import 'v4l2.dart';
import 'v4l2_capability.dart';
import 'v4l2_device.dart';
import 'v4l2_device_capability.dart';
import 'v4l2_error.dart';

final class V4L2Impl implements V4L2 {
  @override
  V4L2Device open(String deviceName) {
    final fd =
        ffi.libV4L2.open(deviceName.toNativeUtf8().cast(), ffi.O_RDWR, 0);
    if (fd == -1) {
      throw V4L2Error('open failed, $fd.');
    }
    return V4L2DeviceImpl(fd);
  }

  @override
  void close(V4L2Device device) {
    if (device is! V4L2DeviceImpl) {
      throw TypeError();
    }
    final status = ffi.libV4L2.close(device.fd);
    if (status == -1) {
      throw V4L2Error('close failed, $status.');
    }
  }

  @override
  V4L2DeviceCapability queryCapability(V4L2Device device) {
    if (device is! V4L2DeviceImpl) {
      throw TypeError();
    }
    return ffi.using((arena) {
      final cap = arena<ffi.v4l2_capability>();
      final status = ffi.libV4L2.ioctl(device.fd, ffi.VIDIOC_QUERYCAP, cap);
      if (status == -1) {
        throw V4L2Error('ioctl failed, $status.');
      }
      return V4L2DeviceCapabilityImpl(cap.ref);
    });
  }
}

final class V4L2DeviceImpl implements V4L2Device {
  final int fd;

  V4L2DeviceImpl(this.fd);
}

class V4L2DeviceCapabilityImpl implements V4L2DeviceCapability {
  final ffi.v4l2_capability ffiValue;

  V4L2DeviceCapabilityImpl(this.ffiValue);

  @override
  String get driver => ffiValue.driver.dartValue;

  @override
  String get card => ffiValue.card.dartValue;

  @override
  String get busInfo => ffiValue.bus_info.dartValue;

  @override
  int get version => ffiValue.version;

  @override
  List<V4L2Capability> get capabilities =>
      ffiValue.capabilities.dartCapabilities;

  @override
  List<V4L2Capability> get deviceCapabilities =>
      ffiValue.device_caps.dartCapabilities;
}
