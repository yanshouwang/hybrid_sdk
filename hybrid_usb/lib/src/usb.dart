import 'hybrid_usb.dart';
import 'usb_option.dart';

abstract interface class USB {
  factory USB() => HybridUSBPlugin.instance;

  void setOption(USBOption option);
}
