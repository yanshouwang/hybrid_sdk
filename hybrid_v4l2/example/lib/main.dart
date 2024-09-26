import 'dart:developer';

import 'package:hybrid_v4l2/hybrid_v4l2.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.onRecord.listen(onLogRecord);
  final v4l2 = V4L2();
  final device = v4l2.open('/dev/video0');
  try {
    final capability = v4l2.queryCapability(device);
    final driver = capability.driver;
    final card = capability.card;
    final busInfo = capability.busInfo;
    final version = capability.version;
    final capabilities = capability.capabilities;
    final deviceCapabilities = capability.deviceCapabilities;
    Logger.root.info('''/dev/video0

driver: $driver
card: $card
busInfo: $busInfo
version: ${(version >> 16) & 0xffff}.${(version >> 8) & 0xff}.${version & 0xff}

capabilities:
${capabilities.join('\n')}

deviceCapabilities:
${deviceCapabilities.join('\n')}''');
  } finally {
    v4l2.close(device);
  }
}

void onLogRecord(LogRecord record) {
  log(
    record.message,
    time: record.time,
    sequenceNumber: record.sequenceNumber,
    level: record.level.value,
    name: record.loggerName,
    zone: record.zone,
    error: record.error,
    stackTrace: record.stackTrace,
  );
}
