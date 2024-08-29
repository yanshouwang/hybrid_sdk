import 'package:ffi/ffi.dart';
import 'package:hybrid_uvc/src/uvc_device_descriptor.dart';

import 'libuvc.g.dart';

extension FFIUVCDeviceDescriptorX on uvc_device_descriptor {
  UVCDeviceDescriptor get dartValue {
    return UVCDeviceDescriptor(
      vid: idVendor,
      pid: idProduct,
      sn: serialNumber.cast<Utf8>().toDartString(),
      manufacturerName: manufacturer.cast<Utf8>().toDartString(),
      productName: product.cast<Utf8>().toDartString(),
    );
  }
}
