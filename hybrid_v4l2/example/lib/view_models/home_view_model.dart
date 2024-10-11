import 'dart:isolate';

import 'package:clover/clover.dart';
import 'package:collection/collection.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:hybrid_v4l2/hybrid_v4l2.dart';
import 'package:logging/logging.dart';

class HomeViewModel extends ViewModel with TypeLogger {
  final V4L2 v4l2;
  final List<V4L2MappedBuffer> _mappedBufs;
  final Stopwatch _fpsWatch;

  int? _fd;
  Isolate? _isolate;
  V4L2RGBXBuffer? _frame;

  HomeViewModel()
      : v4l2 = V4L2(),
        _mappedBufs = [],
        _fpsWatch = Stopwatch() {
    open();
    beginStreaming();
  }

  V4L2RGBXBuffer? get frame => _frame;

  @override
  void dispose() {
    endStreaming();
    close();
    super.dispose();
  }

  void open() {
    final fd = v4l2.open(
      '/dev/video0',
      [V4L2O.rdwr, V4L2O.nonblock],
    );
    final cap = v4l2.querycap(fd);
    logger.info('''[QUERYCAP]
driver: ${cap.driver}
card: ${cap.card}
busInfo: ${cap.busInfo}
version: ${(cap.version >> 16) & 0xffff}.${(cap.version >> 8) & 0xff}.${cap.version & 0xff}
capabilities: ${cap.capabilities.join(',')}
deviceCaps: ${cap.deviceCaps.join(',')}
''');

    final inputs = v4l2.enuminput(fd);
    for (var input in inputs) {
      logger.info('''[ENUMINPUT]
type: ${input.type}
audioset: ${input.audioset}
tuner: ${input.tuner}
std: ${input.std.join(',')}
status: ${input.status.join(',')}
capabilities: ${input.capabilities.join(',')}
''');
    }

    final input = v4l2.gInput(fd);
    logger.info('''[G_INPUT]
type: ${input.type}
audioset: ${input.audioset}
tuner: ${input.tuner}
std: ${input.std.join(',')}
status: ${input.status.join(',')}
capabilities: ${input.capabilities.join(',')}
''');

    final fmts = v4l2.enumFmt(fd, V4L2BufType.videoCapture);
    for (var fmt in fmts) {
      logger.info('''[ENUM_FMT]
description: ${fmt.description}
pixelformat: ${fmt.pixelformat}
flags: ${fmt.flags.join(',')}
''');
    }

    final fmt = v4l2.gFmt(fd, V4L2BufType.videoCapture);
    logger.info('''[G_FMT]
pix.width: ${fmt.pix.width}
pix.height: ${fmt.pix.height}
pix.pixelformat: ${fmt.pix.pixelformat}
pix.field: ${fmt.pix.field}
''');

    final frmsizes = v4l2.enumFramesizes(fd, V4L2PixFmt.mjpeg);
    final frmsize = minBy(
      frmsizes,
      (frmsize) => frmsize.width * frmsize.height,
    );
    if (frmsize != null) {
      fmt.pix.width = frmsize.width;
      fmt.pix.height = frmsize.height;
      v4l2.sFmt(fd, fmt);
      logger.info('''[S_FMT]
width: ${frmsize.width}
height: ${frmsize.height}
''');
    }

    _fd = fd;
  }

  void close() {
    final fd = _fd;
    if (fd == null) {
      throw ArgumentError.notNull();
    }
    v4l2.close(fd);
  }

  void beginStreaming() async {
    final fd = _fd;
    if (fd == null) {
      return;
    }
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
      _mappedBufs.add(mappedBuf);
      v4l2.qbuf(fd, buf);
    }
    v4l2.streamon(fd, V4L2BufType.videoCapture);
    logger.info('STREAMON');

    final receivePort = ReceivePort()
      ..listen(
        (index) async {
          try {
            final mappedBuf = _mappedBufs[index];
            _frame = v4l2.mjpeg2RGBX(mappedBuf);
            notifyListeners();
          } catch (e) {
            logger.warning('$e');
          }
        },
      );

    _isolate = await Isolate.spawn(
      (commandArgs) {
        final sendPort = commandArgs.sendPort;
        final fd = commandArgs.fd;
        final logger = Logger('V4L2');
        final v4l2 = V4L2();
        while (true) {
          try {
            final timeout = V4L2Timeval()
              ..tvSec = 2
              ..tvUsec = 0;
            v4l2.select(fd, timeout);
            final buf =
                v4l2.dqbuf(fd, V4L2BufType.videoCapture, V4L2Memory.mmap);
            sendPort.send(buf.index);
            v4l2.qbuf(fd, buf);
          } catch (e) {
            logger.warning('STREAMING failed, $e.');
          }
        }
      },
      StreamingCommandArgs(
        receivePort.sendPort,
        fd,
      ),
    );

    _fpsWatch.start();
  }

  void endStreaming() {
    final fd = _fd;
    final isolate = _isolate;
    if (fd == null || isolate == null) {
      throw ArgumentError.notNull();
    }
    _fpsWatch.stop();
    isolate.kill(priority: Isolate.immediate);
    for (var mappedBuf in _mappedBufs) {
      v4l2.munmap(mappedBuf);
    }
    v4l2.streamoff(fd, V4L2BufType.videoCapture);
  }
}

class StreamingCommandArgs {
  final SendPort sendPort;
  final int fd;

  const StreamingCommandArgs(this.sendPort, this.fd);
}
