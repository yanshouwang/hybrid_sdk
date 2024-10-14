import 'dart:async';
import 'dart:isolate';

import 'package:clover/clover.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:hybrid_v4l2/hybrid_v4l2.dart';
import 'package:hybrid_v4l2_example/models.dart';
import 'package:hybrid_v4l2_example/util.dart';

class HomeViewModel extends ViewModel with TypeLogger {
  final V4L2 v4l2;
  final List<V4L2MappedBuffer> _mappedBufs;

  late final StreamSubscription _receivePortSubscription;

  List<FormatDescriptor> _descriptors;
  V4L2Format? _fmt;

  int? _fd;
  Token? _streamingToken;
  V4L2RGBXBuffer? _frame;

  HomeViewModel()
      : v4l2 = V4L2(),
        _mappedBufs = [],
        _descriptors = [] {
    open();
  }

  List<V4L2PixFmt> get formats =>
      List.unmodifiable(_descriptors.map((descriptor) => descriptor.format));
  List<V4L2Frmsize> get sizes => List.unmodifiable(format == null
      ? []
      : _descriptors
          .firstWhere((descriptor) => descriptor.format == format)
          .sizes);

  V4L2PixFmt? get format {
    final fmt = _fmt;
    if (fmt == null) {
      return null;
    }
    return formats.firstWhere((format) => format == fmt.pix.pixelformat);
  }

  V4L2Frmsize? get size {
    final fmt = _fmt;
    if (fmt == null) {
      return null;
    }
    final width = fmt.pix.width;
    final height = fmt.pix.height;
    return sizes
        .firstWhere((size) => size.width == width && size.height == height);
  }

  bool get streaming => _streamingToken != null;
  V4L2RGBXBuffer? get frame => _frame;

  @override
  void dispose() {
    if (streaming) {
      stopStreaming();
    }
    close();
    _receivePortSubscription.cancel();
    super.dispose();
  }

  // void startStreaming() async {
  //   var token = _streamingToken;
  //   if (token != null) {
  //     throw ArgumentError.value(token);
  //   }
  //   _streamingToken = token = Token();
  //   notifyListeners();
  //   final random = math.Random();
  //   const width = 100;
  //   const height = 100;
  //   final element1 = random.nextInt(255);
  //   final element2 = random.nextInt(255);
  //   final elements1 = List.generate(
  //     width * height * 4,
  //     (i) => i % 4 == 3 ? 0xff : element1,
  //   );
  //   final elements2 = List.generate(
  //     width * height * 4,
  //     (i) => i % 4 == 3 ? 0xff : element2,
  //   );
  //   final value1 = Uint8List.fromList(elements1);
  //   final value2 = Uint8List.fromList(elements2);
  //   while (token.isNotCancelled) {
  //     _frame = TestV4L2RGBXBuffer(
  //       value: _frame?.value == value1 ? value2 : value1,
  //       width: width,
  //       height: height,
  //     );
  //     notifyListeners();
  //     await Future.delayed(
  //       const Duration(
  //         milliseconds: 10,
  //       ),
  //     );
  //   }
  // }

  // void stopStreaming() {
  //   final token = ArgumentError.checkNotNull(_streamingToken);
  //   token.cancel();
  //   _streamingToken = null;
  //   _frame = null;
  //   notifyListeners();
  // }

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

    final descriptors = <FormatDescriptor>[];
    final fmts = v4l2.enumFmt(fd, V4L2BufType.videoCapture);
    for (var fmt in fmts) {
      final frmsizes = v4l2.enumFramesizes(fd, V4L2PixFmt.mjpeg);
      final descriptor = FormatDescriptor(fmt.pixelformat, frmsizes);
      descriptors.add(descriptor);
    }
    final fmt = v4l2.gFmt(fd, V4L2BufType.videoCapture);

    _fd = fd;
    _descriptors = descriptors;
    _fmt = fmt;
    notifyListeners();
  }

  void close() {
    final fd = _fd;
    if (fd == null) {
      throw ArgumentError.notNull();
    }
    v4l2.close(fd);

    _fd = null;
    _descriptors = [];
    _fmt = null;
    notifyListeners();
  }

  void setFormat(V4L2PixFmt format) {
    final fd = _fd;
    final fmt = _fmt;
    if (fd == null || fmt == null) {
      throw ArgumentError.notNull();
    }
    fmt.pix.pixelformat = format;
    v4l2.sFmt(fd, fmt);
    notifyListeners();
  }

  void setSize(V4L2Frmsize size) {
    final fd = _fd;
    final fmt = _fmt;
    if (fd == null || fmt == null) {
      throw ArgumentError.notNull();
    }
    fmt.pix.width = size.width;
    fmt.pix.height = size.height;
    v4l2.sFmt(fd, fmt);
    notifyListeners();
  }

  void startStreaming() async {
    final fd = ArgumentError.checkNotNull(_fd);
    var token = _streamingToken;
    if (token != null) {
      throw ArgumentError.value(token);
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

    _streamingToken = token = Token();
    notifyListeners();

    while (true) {
      await _select();
      if (token.isCancelled) {
        break;
      }
      final buf = v4l2.dqbuf(fd, V4L2BufType.videoCapture, V4L2Memory.mmap);
      final mappedBuf = _mappedBufs.elementAtOrNull(buf.index);
      if (mappedBuf == null) {
        break;
      }
      try {
        _frame = v4l2.mjpeg2RGBX(mappedBuf);
        notifyListeners();
      } catch (e) {
        logger.warning('MJPEG2RGBX failed, $e.');
      } finally {
        v4l2.qbuf(fd, buf);
      }
    }
  }

  void stopStreaming() {
    final fd = ArgumentError.checkNotNull(_fd);
    final token = ArgumentError.checkNotNull(_streamingToken);
    token.cancel();
    v4l2.streamoff(fd, V4L2BufType.videoCapture);
    logger.info('STREAMOFF');

    for (var mappedBuf in _mappedBufs) {
      v4l2.munmap(mappedBuf);
    }
    _mappedBufs.clear();
    _streamingToken = null;
    _frame = null;
    notifyListeners();
  }

  Future<void> _select() async {
    final fd = _fd;
    if (fd == null) {
      return;
    }
    final sendPort = await _sendPort;
    final id = _id++;
    final completer = Completer<void>();
    _selectCompleters[id] = completer;
    final command = _SelectCommand(id, fd);
    sendPort.send(command);
    return completer.future;
  }
}

class _SelectCommand {
  final int id;
  final int fd;

  const _SelectCommand(this.id, this.fd);
}

class _SelectReply {
  final int id;
  final Object? error;

  const _SelectReply(this.id, this.error);
}

var _id = 0;

final _selectCompleters = <int, Completer<void>>{};

Future<SendPort> _sendPort = () async {
  final completer = Completer<SendPort>();
  final outsideReceivePort = ReceivePort()
    ..listen(
      (message) {
        if (message is SendPort) {
          completer.complete(message);
        } else if (message is _SelectReply) {
          final id = message.id;
          final error = message.error;
          final completer = _selectCompleters.remove(id);
          if (completer == null) {
            return;
          }
          if (error == null) {
            completer.complete();
          } else {
            completer.completeError(error);
          }
        } else {
          throw UnsupportedError(
            'Unsupported message type: ${message.runtimeType}',
          );
        }
      },
    );
  await Isolate.spawn(
    (outsideSendPort) {
      final v4l2 = V4L2();
      final insideReceivePort = ReceivePort()
        ..listen(
          (message) async {
            if (message is _SelectCommand) {
              final id = message.id;
              final fd = message.fd;
              try {
                final timeout = V4L2Timeval()
                  ..tvSec = 2
                  ..tvUsec = 0;
                v4l2.select(fd, timeout);
                final reply = _SelectReply(id, null);
                outsideSendPort.send(reply);
              } catch (e) {
                final reply = _SelectReply(id, e);
                outsideSendPort.send(reply);
              }
            } else {
              throw UnsupportedError(
                'Unsupported message type: ${message.runtimeType}',
              );
            }
          },
        );

      outsideSendPort.send(insideReceivePort.sendPort);
    },
    outsideReceivePort.sendPort,
  );
  return completer.future;
}();
