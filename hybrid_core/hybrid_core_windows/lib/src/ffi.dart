// ignore_for_file: type=lint
import 'dart:ffi';

import 'ffi.g.dart';

export 'dart:ffi';

export 'package:ffi/ffi.dart';

export 'ffi.g.dart';

final kernel32Lib = DynamicLibrary.open('Kernel32.dll');
final kernel32 = HybridCore(kernel32Lib);

int LOBYTE(int w) => w & 0xff;
int HIBYTE(int w) => (w >> 8) & 0xff;
