final class UVCDeviceDescriptor {
  final int vid;
  final int pid;
  final String? sn;
  final String? manufacturer;
  final String? product;

  UVCDeviceDescriptor({
    required this.vid,
    required this.pid,
    this.sn,
    this.manufacturer,
    this.product,
  });
}
