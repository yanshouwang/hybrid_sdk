import 'dart:developer';

import 'package:hybrid_v4l2/hybrid_v4l2.dart';
import 'package:logging/logging.dart';

final mappedBufs = <V4L2MappedBuffer>[];

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

    final req = V4L2Requestbuffers()
      ..count = 4
      ..type = V4L2BufType.videoCapture
      ..memory = V4L2Memory.mmap;
    v4l2.reqbufs(fd, req);
    for (var i = 0; i < req.count; i++) {
      final buf = v4l2.querybuf(
        fd,
        V4L2BufType.videoCapture,
        V4L2Memory.mmap,
        i,
      );
      final mappedBuf = v4l2.mmap(
        fd,
        buf.offset,
        buf.length,
        [V4L2Prot.read, V4L2Prot.write],
        [V4L2Map.shared],
      );
      mappedBufs.add(mappedBuf);
      v4l2.qbuf(fd, buf);
    }
    v4l2.streamon(fd, V4L2BufType.videoCapture);
    Logger.root.info('STREAMON');
    const duration = Duration(seconds: 20);
    var fps = 0;
    final timeWatch = Stopwatch()..start();
    final fpsWatch = Stopwatch()..start();
    while (timeWatch.elapsed < duration) {
      final timeout = V4L2Timeval()
        ..tvSec = 2
        ..tvUsec = 0;
      v4l2.select(fd, timeout);
      final buf = v4l2.dqbuf(fd, V4L2BufType.videoCapture, V4L2Memory.mmap);
      v4l2.qbuf(fd, buf);
      fps++;
      if (fpsWatch.elapsed.inSeconds == 0) {
        continue;
      }
      Logger.root.info('FPS: $fps.');
      fps = 0;
      fpsWatch.reset();
    }
    timeWatch.stop();
    fpsWatch.stop();
    v4l2.streamoff(fd, V4L2BufType.videoCapture);
    Logger.root.info('STREAMOFF');
  } finally {
    for (var mappedBuf in mappedBufs) {
      v4l2.munmap(mappedBuf);
    }
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
