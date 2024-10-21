import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:clover/clover.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:hybrid_v4l2/hybrid_v4l2.dart';
import 'package:hybrid_v4l2_example/util.dart';
import 'package:logging/logging.dart';

class HomeViewModel extends ViewModel with TypeLogger {
  final V4L2 _v4l2;
  List<V4L2PixFmt> _formats;
  V4L2Format? _fmt;
  List<V4L2Frmsize> _sizes;

  double _ratio;
  Token? _token;
  V4L2Frame? _frame;

  HomeViewModel()
      : _v4l2 = V4L2(),
        _formats = [],
        _sizes = [],
        _ratio = 1.0 {
    _init();
  }

  List<V4L2PixFmt> get formats => List.unmodifiable(_formats);
  List<V4L2Frmsize> get sizes => List.unmodifiable(_sizes);

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

  double get ratio => _ratio;
  bool get streaming => _token != null;
  V4L2Frame? get frame => _frame;

  @override
  void dispose() {
    if (streaming) {
      stopStreaming();
    }
    super.dispose();
  }

  void setFormat(V4L2PixFmt format) {
    final fd = _open();
    final fmt = ArgumentError.checkNotNull(_fmt);
    fmt.pix.pixelformat = format;
    _v4l2.sFmt(fd, fmt);
    _close(fd);
    notifyListeners();
  }

  void setSize(V4L2Frmsize size) {
    final fd = _open();
    final fmt = ArgumentError.checkNotNull(_fmt);
    fmt.pix.width = size.width;
    fmt.pix.height = size.height;
    _v4l2.sFmt(fd, fmt);
    _close(fd);
    notifyListeners();
  }

  void setRatio(double ratio) {
    _ratio = ratio;
    notifyListeners();
  }

  void beginStreaming() async {
    var token = _token;
    if (token != null) {
      throw ArgumentError.value(token);
    }

    _token = token = Token();
    notifyListeners();

    final fd = _open();
    await beginStreamingAsync(fd);

    while (token.isNotCancelled) {
      try {
        _frame = await readAsync(fd, ratio);
        notifyListeners();
      } catch (e) {
        logger.info('read failed, $e');
      }
    }

    await endStreamingAsync(fd);
    _close(fd);
    _frame = null;
    notifyListeners();
  }

  void stopStreaming() async {
    final token = ArgumentError.checkNotNull(_token);
    token.cancel();

    _token = null;
    notifyListeners();
  }

  void _init() {
    final fd = _open();
    final fmts = _v4l2.enumFmt(fd, V4L2BufType.videoCapture);
    final fmt = _v4l2.gFmt(fd, V4L2BufType.videoCapture);
    final frmsizes = _v4l2.enumFramesizes(fd, fmt.pix.pixelformat);
    _close(fd);

    _formats = fmts.map((fmt) => fmt.pixelformat).toList();
    _fmt = fmt;
    _sizes = frmsizes;
    notifyListeners();

//     final cap = v4l2.querycap(fd);
//     logger.info('''[QUERYCAP]
// driver: ${cap.driver}
// card: ${cap.card}
// busInfo: ${cap.busInfo}
// version: ${(cap.version >> 16) & 0xffff}.${(cap.version >> 8) & 0xff}.${cap.version & 0xff}
// capabilities: ${cap.capabilities.join(',')}
// deviceCaps: ${cap.deviceCaps.join(',')}
// ''');

//     final inputs = v4l2.enuminput(fd);
//     for (var input in inputs) {
//       logger.info('''[ENUMINPUT]
// type: ${input.type}
// audioset: ${input.audioset}
// tuner: ${input.tuner}
// std: ${input.std.join(',')}
// status: ${input.status.join(',')}
// capabilities: ${input.capabilities.join(',')}
// ''');
//     }

//     final input = v4l2.gInput(fd);
//     logger.info('''[G_INPUT]
// type: ${input.type}
// audioset: ${input.audioset}
// tuner: ${input.tuner}
// std: ${input.std.join(',')}
// status: ${input.status.join(',')}
// capabilities: ${input.capabilities.join(',')}
// ''');
  }

  int _open() {
    return _v4l2.open(
      '/dev/video0',
      [V4L2O.rdwr, V4L2O.nonblock],
    );
  }

  void _close(int fd) {
    _v4l2.close(fd);
  }
}

Future<void> beginStreamingAsync(int fd) async {
  final sendPort = await _sendPort;
  final id = _id++;
  final completer = Completer<void>();
  _completers[id] = completer;
  final command = _BeginStreamingCommand(id, fd);
  sendPort.send(command);
  return completer.future;
}

Future<V4L2Frame> readAsync(int fd, double ratio) async {
  final sendPort = await _sendPort;
  final id = _id++;
  final completer = Completer<V4L2Frame>();
  _completers[id] = completer;
  final command = _ReadCommand(id, fd, ratio);
  sendPort.send(command);
  return completer.future;
}

Future<void> endStreamingAsync(int fd) async {
  final sendPort = await _sendPort;
  final id = _id++;
  final completer = Completer<void>();
  _completers[id] = completer;
  final command = _EndStreamingCommand(id, fd);
  sendPort.send(command);
  return completer.future;
}

abstract base class _Command {
  final int id;

  const _Command(this.id);
}

abstract base class _Reply {
  final int id;
  final Object? error;

  const _Reply(
    this.id,
    this.error,
  );
}

final class _BeginStreamingCommand extends _Command {
  final int fd;

  const _BeginStreamingCommand(super.id, this.fd);
}

final class _BeginStreamingReply extends _Reply {
  const _BeginStreamingReply(super.id, super.error);
}

final class _ReadCommand extends _Command {
  final int fd;
  final double ratio;

  const _ReadCommand(super.id, this.fd, this.ratio);
}

final class _ReadReply extends _Reply {
  final V4L2Frame? frame;

  const _ReadReply(
    super.id,
    this.frame,
    super.error,
  );
}

final class _EndStreamingCommand extends _Command {
  final int fd;

  const _EndStreamingCommand(super.id, this.fd);
}

final class _EndStreamingReply extends _Reply {
  const _EndStreamingReply(super.id, super.error);
}

var _id = 0;

final _completers = <int, Completer>{};

Future<SendPort> _sendPort = () async {
  final completer = Completer<SendPort>();
  final receivePort = ReceivePort()
    ..listen(
      (message) {
        if (message is SendPort) {
          completer.complete(message);
        } else if (message is _BeginStreamingReply) {
          final id = message.id;
          final error = message.error;
          final completer = _completers.remove(id);
          if (completer == null) {
            return;
          }
          if (error == null) {
            completer.complete();
          } else {
            completer.completeError(error);
          }
        } else if (message is _ReadReply) {
          final id = message.id;
          final frame = message.frame;
          final error = message.error;
          final completer = _completers.remove(id);
          if (completer == null) {
            return;
          }
          if (error == null) {
            completer.complete(frame);
          } else {
            completer.completeError(error);
          }
        } else if (message is _EndStreamingReply) {
          final id = message.id;
          final error = message.error;
          final completer = _completers.remove(id);
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
    (insideSendPort) {
      Logger.root.onRecord.listen((record) {
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
      });
      final v4l2 = V4L2();
      final mappedBufs = <V4L2MappedBuffer>[];

      final insideReceivePort = ReceivePort()
        ..listen(
          (message) async {
            if (message is _BeginStreamingCommand) {
              final id = message.id;
              final fd = message.fd;
              try {
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
                final reply = _BeginStreamingReply(id, null);
                insideSendPort.send(reply);
              } catch (e) {
                final reply = _BeginStreamingReply(id, e);
                insideSendPort.send(reply);
              }
            } else if (message is _ReadCommand) {
              final id = message.id;
              final fd = message.fd;
              final ratio = message.ratio;
              try {
                final timeout = V4L2Timeval()
                  ..tvSec = 2
                  ..tvUsec = 0;
                v4l2.select(fd, timeout);
                final buf =
                    v4l2.dqbuf(fd, V4L2BufType.videoCapture, V4L2Memory.mmap);
                try {
                  final mappedBuf = mappedBufs[buf.index];
                  final rgbaBuf = v4l2.mjpegToRGBA(mappedBuf, ratio);
                  final frame = V4L2Frame(
                    rgbaBuf.value,
                    rgbaBuf.width,
                    rgbaBuf.height,
                  );
                  final reply = _ReadReply(id, frame, null);
                  insideSendPort.send(reply);
                } finally {
                  v4l2.qbuf(fd, buf);
                }
              } catch (e) {
                final reply = _ReadReply(id, null, e);
                insideSendPort.send(reply);
              }
            } else if (message is _EndStreamingCommand) {
              final id = message.id;
              final fd = message.fd;
              try {
                v4l2.streamoff(fd, V4L2BufType.videoCapture);
                for (var mappedBuf in mappedBufs) {
                  v4l2.munmap(mappedBuf);
                }
                mappedBufs.clear();
                final reply = _EndStreamingReply(id, null);
                insideSendPort.send(reply);
              } catch (e) {
                final reply = _EndStreamingReply(id, e);
                insideSendPort.send(reply);
              }
            } else {
              throw UnsupportedError(
                'Unsupported message type: ${message.runtimeType}',
              );
            }
          },
        );

      insideSendPort.send(insideReceivePort.sendPort);
    },
    receivePort.sendPort,
  );
  return completer.future;
}();
