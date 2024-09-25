import 'v4l2_capability.dart';

abstract interface class V4L2DeviceCapability {
  /// name of the driver module (e.g. "bttv")
  String get driver;

  /// name of the card (e.g. "Hauppauge WinTV")
  String get card;

  /// name of the bus (e.g. "PCI:" + pci_name(pci_dev) )
  String get busInfo;

  /// KERNEL_VERSION
  int get version;

  /// capabilities of the physical device as a whole
  List<V4L2Capability> get capabilities;

  /// capabilities accessed via this particular device (node)
  List<V4L2Capability> get deviceCapabilities;
}
