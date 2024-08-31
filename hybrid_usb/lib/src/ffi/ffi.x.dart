import '../usb_option.dart';
import 'ffi.g.dart';

extension USBOptionX on USBOption {
  libusb_option get ffiValue {
    switch (this) {
      case USBOption.logLevel:
        return libusb_option.LIBUSB_OPTION_LOG_LEVEL;
      case USBOption.useUSBDK:
        return libusb_option.LIBUSB_OPTION_USE_USBDK;
      case USBOption.noDeviceDiscovery:
        return libusb_option.LIBUSB_OPTION_NO_DEVICE_DISCOVERY;
      case USBOption.logCallback:
        return libusb_option.LIBUSB_OPTION_LOG_CB;
      case USBOption.max:
        return libusb_option.LIBUSB_OPTION_MAX;
    }
  }
}
