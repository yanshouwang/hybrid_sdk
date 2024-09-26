import 'dart:ffi' as ffi;

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
    final file = deviceName.toNativeUtf8().cast<ffi.Char>();
    final fd = ffi.libV4L2.open(file, ffi.O_RDWR, 0);
    ffi.malloc.free(file);
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
    if (status != 0) {
      throw V4L2Error('close failed, $status.');
    }
  }

  @override
  V4L2DeviceCapability queryCapability(V4L2Device device) {
    if (device is! V4L2DeviceImpl) {
      throw TypeError();
    }
    final capability = V4L2DeviceCapabilityImpl();
    final status =
        ffi.libV4L2.ioctl(device.fd, ffi.VIDIOC_QUERYCAP, capability.ffiValue);
    if (status != 0) {
      throw V4L2Error('ioctl failed, $status.');
    }
    return capability;
  }
}

final class V4L2DeviceImpl implements V4L2Device {
  final int fd;

  V4L2DeviceImpl(this.fd);
}

class V4L2DeviceCapabilityImpl
    implements V4L2DeviceCapability, ffi.Finalizable {
  static final finalizer = ffi.NativeFinalizer(ffi.malloc.nativeFree);

  final ffi.Pointer<ffi.v4l2_capability> ffiValue;

  V4L2DeviceCapabilityImpl() : ffiValue = ffi.malloc<ffi.v4l2_capability>() {
    finalizer.attach(this, ffiValue.cast());
  }

  @override
  String get driver => ffiValue.ref.driver.dartValue;

  @override
  String get card => ffiValue.ref.card.dartValue;

  @override
  String get busInfo => ffiValue.ref.bus_info.dartValue;

  @override
  int get version => ffiValue.ref.version;

  @override
  List<V4L2Capability> get capabilities =>
      ffiValue.ref.capabilities.dartCapabilities;

  @override
  List<V4L2Capability> get deviceCapabilities =>
      ffiValue.ref.device_caps.dartCapabilities;
}
