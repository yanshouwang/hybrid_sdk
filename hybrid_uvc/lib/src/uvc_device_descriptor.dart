final class UVCDeviceDescriptor {
  final int vid;
  final int pid;
  final String sn;
  final String manufacturerName;
  final String productName;

  UVCDeviceDescriptor({
    required this.vid,
    required this.pid,
    required this.sn,
    required this.manufacturerName,
    required this.productName,
  });
}
