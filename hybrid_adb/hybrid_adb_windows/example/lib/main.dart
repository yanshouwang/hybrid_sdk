import 'package:flutter/foundation.dart';
import 'package:hybrid_adb_platform_interface/hybrid_adb_platform_interface.dart';

void main() async {
  final adb = ADB.instance;
  final version = await adb.execute([
    'version',
  ]);
  debugPrint(version);
}
