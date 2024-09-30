import 'dart:developer';

import 'package:hybrid_v4l2/hybrid_v4l2.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.onRecord.listen(onLogRecord);
  final v4l2 = V4L2();
  final fd = v4l2.open(
    '/dev/video0',
    [V4L2O.rdwr, V4L2O.nonblock],
  );
  try {
    final cap = v4l2.querycap(fd);
    Logger.root.info('''[QUERYCAP]
driver: ${cap.driver}
card: ${cap.card}
busInfo: ${cap.busInfo}
version: ${(cap.version >> 16) & 0xffff}.${(cap.version >> 8) & 0xff}.${cap.version & 0xff}
capabilities: ${cap.capabilities.join(',')}
deviceCaps: ${cap.deviceCaps.join(',')}
''');

    final inputs = v4l2.enuminput(fd);
    for (var input in inputs) {
      Logger.root.info('''[ENUMINPUT]
type: ${input.type}
audioset: ${input.audioset}
tuner: ${input.tuner}
std: ${input.std.join(',')}
status: ${input.status.join(',')}
capabilities: ${input.capabilities.join(',')}
''');
    }

    final input = v4l2.gInput(fd);
    Logger.root.info('''[G_INPUT]
type: ${input.type}
audioset: ${input.audioset}
tuner: ${input.tuner}
std: ${input.std.join(',')}
status: ${input.status.join(',')}
capabilities: ${input.capabilities.join(',')}
''');

    final fmts = v4l2.enumFmt(fd, V4L2BufType.videoCapture);
    for (var fmt in fmts) {
      Logger.root.info('''[ENUM_FMT]
description: ${fmt.description}
pixelformat: ${fmt.pixelformat}
flags: ${fmt.flags.join(',')}
''');
    }

    final fmt = v4l2.gFmt(fd, V4L2BufType.videoCapture);
    Logger.root.info('''[G_FMT]
pix.width: ${fmt.pix.width}
pix.height: ${fmt.pix.height}
pix.pixelformat: ${fmt.pix.pixelformat}
pix.field: ${fmt.pix.field}
''');
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
