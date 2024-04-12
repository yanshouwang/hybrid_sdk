import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:ui';

import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';
import 'package:jni/jni.dart';

import 'jni.dart';
import 'jni.g.dart' as jni;

base class AndroidBarcodeDetectionImpl extends BarcodeDetectionImpl {
  @override
  BarcodeDetector createDetector({
    List<BarcodeFormat>? formats,
  }) {
    final executor =
        jni.Executors.newSingleThreadExecutor().castTo(jni.Executor.type);
    final builder = jni.BarcodeScannerOptions_Builder().setExecutor(executor);
    if (formats != null) {
      final values = formats
          .map((format) => format.cValue)
          .where((value) => value != jni.Barcode.FORMAT_UNKNOWN);
      if (values.isNotEmpty) {
        final value = values.first;
        final moreValues = values.skip(1).toJArray();
        builder.setBarcodeFormats(value, moreValues);
      }
    }
    final options = builder.build();
    final scanner = jni.BarcodeScanning.getClient1(options);
    return AndroidBarcodeDetector(scanner);
  }
}

class AndroidBarcodeDetector implements BarcodeDetector {
  final jni.BarcodeScanner scanner;

  AndroidBarcodeDetector(this.scanner);

  @override
  Future<List<Barcode>> detect(VisionImage image) async {
    final sendPort = await _helperIsolateSendPort;
    final int id = _detectId++;
    final _DetectCommand command = _DetectCommand(
      id,
      // TODO: 使用 scanner 代替 scannerAddress.
      // https://github.com/dart-lang/native/issues/979
      scanner.reference.pointer.address,
      image,
    );
    final completer = Completer<List<Barcode>>();
    _detectCompleters[id] = completer;
    sendPort.send(command);
    return completer.future;
  }
}

extension on BarcodeFormat {
  int get cValue {
    switch (this) {
      case BarcodeFormat.aztec:
        return jni.Barcode.FORMAT_AZTEC;
      case BarcodeFormat.code128:
        return jni.Barcode.FORMAT_CODE_128;
      case BarcodeFormat.code39:
        return jni.Barcode.FORMAT_CODE_39;
      case BarcodeFormat.code93:
        return jni.Barcode.FORMAT_CODE_93;
      case BarcodeFormat.codabar:
        return jni.Barcode.FORMAT_CODABAR;
      case BarcodeFormat.dataMatrix:
        return jni.Barcode.FORMAT_DATA_MATRIX;
      case BarcodeFormat.ean13:
        return jni.Barcode.FORMAT_EAN_13;
      case BarcodeFormat.ean8:
        return jni.Barcode.FORMAT_EAN_8;
      case BarcodeFormat.itf:
        return jni.Barcode.FORMAT_ITF;
      case BarcodeFormat.pdf417:
        return jni.Barcode.FORMAT_PDF417;
      case BarcodeFormat.qrCode:
        return jni.Barcode.FORMAT_QR_CODE;
      case BarcodeFormat.upcA:
        return jni.Barcode.FORMAT_UPC_A;
      case BarcodeFormat.upcE:
        return jni.Barcode.FORMAT_UPC_E;
      default:
        return jni.Barcode.FORMAT_UNKNOWN;
    }
  }
}

extension on jni.Barcode {
  Barcode? toBarcode(double width, double height) {
    final format = getFormat().toBarcodeFormat();
    if (format == null) {
      return null;
    }
    final rect = getBoundingBox().toRect();
    final left = rect.left / width;
    final top = rect.top / height;
    final right = rect.right / width;
    final bottom = rect.bottom / height;
    final boundingBox = Rect.fromLTRB(left, top, right, bottom);
    final value = getRawValue().toDartString(
      releaseOriginal: true,
    );
    return Barcode(
      boundingBox: boundingBox,
      format: format,
      value: value,
    );
  }
}

extension on int {
  BarcodeFormat? toBarcodeFormat() {
    switch (this) {
      case jni.Barcode.FORMAT_AZTEC:
        return BarcodeFormat.aztec;
      case jni.Barcode.FORMAT_CODABAR:
        return BarcodeFormat.codabar;
      case jni.Barcode.FORMAT_CODE_128:
        return BarcodeFormat.code128;
      case jni.Barcode.FORMAT_CODE_39:
        return BarcodeFormat.code39;
      case jni.Barcode.FORMAT_CODE_93:
        return BarcodeFormat.code93;
      case jni.Barcode.FORMAT_DATA_MATRIX:
        return BarcodeFormat.dataMatrix;
      case jni.Barcode.FORMAT_EAN_13:
        return BarcodeFormat.ean13;
      case jni.Barcode.FORMAT_EAN_8:
        return BarcodeFormat.ean8;
      case jni.Barcode.FORMAT_ITF:
        return BarcodeFormat.itf;
      case jni.Barcode.FORMAT_PDF417:
        return BarcodeFormat.pdf417;
      case jni.Barcode.FORMAT_QR_CODE:
        return BarcodeFormat.qrCode;
      case jni.Barcode.FORMAT_UPC_A:
        return BarcodeFormat.upcA;
      case jni.Barcode.FORMAT_UPC_E:
        return BarcodeFormat.upcE;
      default:
        return null;
    }
  }
}

class _DetectCommand {
  final int id;
  final int scannerAddress;
  final VisionImage image;

  const _DetectCommand(
    this.id,
    this.scannerAddress,
    this.image,
  );
}

class _DetectReply {
  final int id;
  final List<Barcode> barcodes;
  final Object? error;

  const _DetectReply(
    this.id,
    this.barcodes,
    this.error,
  );
}

var _detectId = 0;

final _detectCompleters = <int, Completer<List<Barcode>>>{};

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final receivePort = ReceivePort()
    ..listen(
      (message) {
        if (message is SendPort) {
          // The helper isolate sent us the port on which we can sent it requests.
          completer.complete(message);
        } else if (message is _DetectReply) {
          // The helper isolate sent us a response to a request we sent.
          final completer = _detectCompleters.remove(message.id);
          if (completer == null) {
            return;
          }
          final error = message.error;
          if (error == null) {
            completer.complete(message.barcodes);
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

  // Start the helper isolate.
  await Isolate.spawn(
    (sendPort) {
      final helperReceivePort = ReceivePort()
        ..listen(
          (message) async {
            // On the helper isolate listen to requests and respond to them.
            if (message is _DetectCommand) {
              try {
                final scannerAddress = message.scannerAddress;
                final scannerPtr = Pointer<Void>.fromAddress(scannerAddress);
                final scannerNewPtr = Jni.env.NewGlobalRef(scannerPtr);
                final scannerReference = JGlobalReference(scannerNewPtr);
                final scanner =
                    jni.BarcodeScanner.fromReference(scannerReference);
                final image = message.image;
                final inputImage = image is MemoryVisionImage
                    ? image.toCInputImage()
                    : image is UriVisionImage
                        ? image.toCInputImage()
                        : throw TypeError();
                final task = scanner.process1(inputImage);
                final onSuccessListener = jni.OnSuccessListener.implement(
                  jni.$OnSuccessListenerImpl(
                    TResult: task.TResult,
                    onSuccess: (cBarcodes) {
                      try {
                        final width = inputImage.getWidth().toDouble();
                        final height = inputImage.getHeight().toDouble();
                        final barcodes = cBarcodes
                            .map(
                                (cBarcode) => cBarcode.toBarcode(width, height))
                            .whereType<Barcode>()
                            .toList();
                        final reply = _DetectReply(message.id, barcodes, null);
                        sendPort.send(reply);
                      } catch (e) {
                        final reply = _DetectReply(message.id, [], e);
                        sendPort.send(reply);
                      }
                    },
                  ),
                );
                final onFailureListener = jni.OnFailureListener.implement(
                  jni.$OnFailureListenerImpl(
                    onFailure: (exception) {
                      try {
                        throw '$exception';
                      } catch (e) {
                        final reply = _DetectReply(message.id, [], e);
                        sendPort.send(reply);
                      }
                    },
                  ),
                );
                task
                    .addOnSuccessListener(onSuccessListener)
                    .addOnFailureListener(onFailureListener);
              } catch (e) {
                final reply = _DetectReply(message.id, [], e);
                sendPort.send(reply);
              }
            } else {
              throw UnsupportedError(
                'Unsupported message type: ${message.runtimeType}',
              );
            }
          },
        );

      // Send the port to the main isolate on which we can receive requests.
      sendPort.send(helperReceivePort.sendPort);
    },
    receivePort.sendPort,
  );

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();
