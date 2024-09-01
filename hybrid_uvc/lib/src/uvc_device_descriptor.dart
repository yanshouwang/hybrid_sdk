abstract interface class UVCDeviceDescriptor {
  int get vid;
  int get pid;
  String? get sn;
  String? get manufacturer;
  String? get product;
}
