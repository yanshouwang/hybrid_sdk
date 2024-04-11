import 'package:flutter/material.dart';

import 'package:hybrid_adb/hybrid_adb.dart';

void main() async {
  final adb = ADB.instance;
  final version = await adb.execute([
    'version',
  ]);
  debugPrint(version);
}
