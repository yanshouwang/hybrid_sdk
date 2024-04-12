// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

import 'ffi.g.dart';

final _kernel32Lib = DynamicLibrary.open('Kernel32.dll');
final kernel32Lib = HybridCoreWindowsLibrary(_kernel32Lib);

int LOBYTE(int w) => w & 0xff;
int HIBYTE(int w) => (w >> 8) & 0xff;
