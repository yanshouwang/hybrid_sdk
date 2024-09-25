import 'package:flutter/foundation.dart';
import 'package:hybrid_v4l2/hybrid_v4l2.dart';

void main() {
  final v4l2 = V4L2();
  final device = v4l2.open('/dev/video0');
  final deviceCapability = v4l2.queryCapability(device);
  debugPrint(
      '''driver ${deviceCapability.driver}, card ${deviceCapability.card}, bus ${deviceCapability.busInfo}, version ${deviceCapability.version}

capabilities
${deviceCapability.capabilities.join('\n')}

deviceCapabilities
${deviceCapability.deviceCapabilities.join('\n')}''');
  v4l2.close(device);
}
