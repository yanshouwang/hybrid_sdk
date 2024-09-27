import 'dart:developer';

import 'package:hybrid_v4l2/hybrid_v4l2.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.onRecord.listen(onLogRecord);
  final v4l2 = V4L2();
  final fd = v4l2.open('/dev/video0');
  try {
    Logger.root.info('[QUERYCAP]');
    final cap = v4l2.querycap(fd);
    final driver = cap.driver;
    final card = cap.card;
    final busInfo = cap.busInfo;
    final version = cap.version;
    final capabilities = cap.capabilities;
    final deviceCaps = cap.deviceCaps;
    Logger.root.info('''driver: $driver
card: $card
busInfo: $busInfo
version: ${(version >> 16) & 0xffff}.${(version >> 8) & 0xff}.${version & 0xff}
capabilities:
${capabilities.join('\n')}
deviceCaps:
${deviceCaps.join('\n')}''');

    Logger.root.info('[ENUM_FMT]');
    final fmts = v4l2.enumFmt(fd);
    for (var fmt in fmts) {
      final description = fmt.description;
      final pixelformat = fmt.pixelformat;
      final flags = fmt.flags;
      Logger.root.info('''description: $description
pixelformat: $pixelformat
flags:
${flags.join('\n')}''');
    }
  } finally {
    v4l2.close(fd);
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
