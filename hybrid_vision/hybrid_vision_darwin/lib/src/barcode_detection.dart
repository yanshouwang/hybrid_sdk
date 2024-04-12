import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_core/hybrid_core.dart';
import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';

import 'ffi.dart';
import 'ffi.g.dart';

base class DarwinBarcodeDetectionImpl extends BarcodeDetectionImpl {
  @override
  BarcodeDetector createDetector({
    List<BarcodeFormat>? formats,
  }) {
    final symbologies = formats == null || formats.isEmpty
        ? null
        : formats
            .map((format) => format.toVNBarcodeSymbologies())
            .expand((symbologyPtrs) => symbologyPtrs)
            .map((symbologyPtr) =>
                DartVNBarcodeSymbology.castFromPointer(visionLib, symbologyPtr))
            .toList()
            .toNSArray();
    return DarwinBarcodeDetector(
      symbologies: symbologies,
    );
  }
}

class DarwinBarcodeDetector implements BarcodeDetector {
  final NSArray? symbologies;

  DarwinBarcodeDetector({
    this.symbologies,
  });

  @override
  Future<List<Barcode>> detect(VisionImage image) async {
    final sendPort = await _helperIsolateSendPort;
    final int id = _detectId++;
    final _DetectCommand command = _DetectCommand(
      id,
      symbologies?.pointer.address,
      image,
    );
    final completer = Completer<List<Barcode>>();
    _detectCompleters[id] = completer;
    sendPort.send(command);
    return completer.future;
  }
}

extension on BarcodeFormat {
  List<VNBarcodeSymbology> toVNBarcodeSymbologies() {
    switch (this) {
      case BarcodeFormat.aztec:
        return [
          visionLib.VNBarcodeSymbologyAztec,
        ];
      case BarcodeFormat.codabar:
        return (atLeastiOS15_0 || atLeastmacOS12_0)
            ? [
                visionLib.VNBarcodeSymbologyCodabar,
              ]
            : [];
      case BarcodeFormat.code128:
        return [
          visionLib.VNBarcodeSymbologyCode128,
        ];
      case BarcodeFormat.code39:
        return [
          visionLib.VNBarcodeSymbologyCode39,
          visionLib.VNBarcodeSymbologyCode39Checksum,
          visionLib.VNBarcodeSymbologyCode39FullASCII,
          visionLib.VNBarcodeSymbologyCode39FullASCIIChecksum,
        ];
      case BarcodeFormat.code93:
        return [
          visionLib.VNBarcodeSymbologyCode93,
          visionLib.VNBarcodeSymbologyCode93i,
        ];
      case BarcodeFormat.dataMatrix:
        return [
          visionLib.VNBarcodeSymbologyDataMatrix,
        ];
      case BarcodeFormat.ean13:
        return [
          visionLib.VNBarcodeSymbologyEAN13,
        ];
      case BarcodeFormat.ean8:
        return [
          visionLib.VNBarcodeSymbologyEAN8,
        ];
      case BarcodeFormat.gs1DataBar:
        return (atLeastiOS15_0 || atLeastmacOS12_0)
            ? [
                visionLib.VNBarcodeSymbologyGS1DataBar,
                visionLib.VNBarcodeSymbologyGS1DataBarExpanded,
                visionLib.VNBarcodeSymbologyGS1DataBarLimited,
              ]
            : [];
      case BarcodeFormat.itf:
        return [
          visionLib.VNBarcodeSymbologyITF14,
          visionLib.VNBarcodeSymbologyI2of5,
          visionLib.VNBarcodeSymbologyI2of5Checksum,
        ];
      case BarcodeFormat.msiPlessey:
        return (atLeastiOS17_0 || atLeastmacOS14_0)
            ? [
                visionLib.VNBarcodeSymbologyMSIPlessey,
              ]
            : [];
      case BarcodeFormat.pdf417:
        return [
          visionLib.VNBarcodeSymbologyPDF417,
          if (atLeastiOS15_0 || atLeastmacOS12_0)
            visionLib.VNBarcodeSymbologyMicroPDF417,
        ];
      case BarcodeFormat.qrCode:
        return [
          visionLib.VNBarcodeSymbologyQR,
          if (atLeastiOS15_0 || atLeastmacOS12_0)
            visionLib.VNBarcodeSymbologyMicroQR,
        ];
      case BarcodeFormat.upcE:
        return [
          visionLib.VNBarcodeSymbologyUPCE,
        ];
      default:
        return [];
    }
  }
}

extension on VNBarcodeObservation {
  Rect get boundingBox {
    return using(
      (arena) {
        final boundingBoxPtr = arena<CGRect>();
        getBoundingBox(boundingBoxPtr);
        return boundingBoxPtr.ref.toRect();
      },
    );
  }

  Barcode? toBarcode() {
    final format = symbology.toBarcodeFormat();
    if (format == null) {
      return null;
    }
    final value = payloadStringValue?.toString();
    return Barcode(
      format: format,
      boundingBox: boundingBox,
      value: value,
    );
  }
}

extension on DartVNBarcodeSymbology {
  bool equals(VNBarcodeSymbology other) =>
      DartVNBarcodeSymbology.castFromPointer(visionLib, other)
          .isEqualToString_(this);

  bool get equalsAztec => equals(visionLib.VNBarcodeSymbologyAztec);
  bool get equalsCodabar =>
      (atLeastiOS15_0 || atLeastmacOS12_0) &&
      equals(visionLib.VNBarcodeSymbologyCodabar);
  bool get equalsCode128 => equals(visionLib.VNBarcodeSymbologyCode128);
  bool get equalsCode39 =>
      equals(visionLib.VNBarcodeSymbologyCode39) ||
      equals(visionLib.VNBarcodeSymbologyCode39Checksum) ||
      equals(visionLib.VNBarcodeSymbologyCode39FullASCII) ||
      equals(visionLib.VNBarcodeSymbologyCode39FullASCIIChecksum);
  bool get equalsCode93 =>
      equals(visionLib.VNBarcodeSymbologyCode93) ||
      equals(visionLib.VNBarcodeSymbologyCode93i);
  bool get equalsDataMatrix => equals(visionLib.VNBarcodeSymbologyDataMatrix);
  bool get equalsEAN13 => equals(visionLib.VNBarcodeSymbologyEAN13);
  bool get equalsEAN8 => equals(visionLib.VNBarcodeSymbologyEAN8);
  bool get equalsGS1DataBar => (atLeastiOS15_0 || atLeastmacOS12_0)
      ? equals(visionLib.VNBarcodeSymbologyGS1DataBar) ||
          equals(visionLib.VNBarcodeSymbologyGS1DataBarExpanded) ||
          equals(visionLib.VNBarcodeSymbologyGS1DataBarLimited)
      : false;
  bool get equalsITF =>
      equals(visionLib.VNBarcodeSymbologyITF14) ||
      equals(visionLib.VNBarcodeSymbologyI2of5) ||
      equals(visionLib.VNBarcodeSymbologyI2of5Checksum);
  bool get equalsMSIPlessey =>
      (atLeastiOS17_0 || atLeastmacOS14_0) &&
      equals(visionLib.VNBarcodeSymbologyMSIPlessey);
  bool get equalsPDF417 => (atLeastiOS15_0 || atLeastmacOS12_0)
      ? equals(visionLib.VNBarcodeSymbologyPDF417) ||
          equals(visionLib.VNBarcodeSymbologyMicroPDF417)
      : equals(visionLib.VNBarcodeSymbologyPDF417);
  bool get equalsQrCode => (atLeastiOS15_0 || atLeastmacOS12_0)
      ? equals(visionLib.VNBarcodeSymbologyQR) ||
          equals(visionLib.VNBarcodeSymbologyMicroQR)
      : equals(visionLib.VNBarcodeSymbologyQR);
  bool get equalsUPCE => equals(visionLib.VNBarcodeSymbologyUPCE);

  BarcodeFormat? toBarcodeFormat() {
    if (equalsAztec) {
      return BarcodeFormat.aztec;
    } else if (equalsCodabar) {
      return BarcodeFormat.codabar;
    } else if (equalsCode128) {
      return BarcodeFormat.code128;
    } else if (equalsCode39) {
      return BarcodeFormat.code39;
    } else if (equalsCode93) {
      return BarcodeFormat.code93;
    } else if (equalsDataMatrix) {
      return BarcodeFormat.dataMatrix;
    } else if (equalsEAN13) {
      return BarcodeFormat.ean13;
    } else if (equalsEAN8) {
      return BarcodeFormat.ean8;
    } else if (equalsGS1DataBar) {
      return BarcodeFormat.gs1DataBar;
    } else if (equalsITF) {
      return BarcodeFormat.itf;
    } else if (equalsMSIPlessey) {
      return BarcodeFormat.msiPlessey;
    } else if (equalsPDF417) {
      return BarcodeFormat.pdf417;
    } else if (equalsQrCode) {
      return BarcodeFormat.qrCode;
    } else if (equalsUPCE) {
      return BarcodeFormat.upcE;
    } else {
      return null;
    }
  }
}

extension on NSArray {
  List<Barcode> toBarcodes() {
    final barcodes = <Barcode>[];
    for (var i = 0; i < count; i++) {
      final object = objectAtIndex_(i);
      final barcode = VNBarcodeObservation.castFrom(object).toBarcode();
      if (barcode == null) {
        continue;
      }
      barcodes.add(barcode);
    }
    return barcodes;
  }
}

class _IsolateMessage {
  final SendPort sendPort;
  final RootIsolateToken token;

  _IsolateMessage({
    required this.sendPort,
    required this.token,
  });
}

class _DetectCommand {
  final int id;
  final int? symbologiesAddress;
  final VisionImage image;

  const _DetectCommand(
    this.id,
    this.symbologiesAddress,
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
    (message) {
      final sendPort = message.sendPort;
      final token = message.token;
      // Register the background isolate with the root isolate.
      BackgroundIsolateBinaryMessenger.ensureInitialized(token);
      final helperReceivePort = ReceivePort()
        ..listen(
          (message) async {
            // On the helper isolate listen to requests and respond to them.
            if (message is _DetectCommand) {
              try {
                final image = message.image;
                final handler = image is MemoryVisionImage
                    ? image.toVNImageRequestHandler()
                    : image is UriVisionImage
                        ? image.toVNImageRequestHandler()
                        : throw TypeError();
                final completionHandler =
                    DartVNRequestCompletionHandler.listener(
                  visionLib,
                  (request, error) {
                    try {
                      if (error == null) {
                        final barcodes = request.results?.toBarcodes() ?? [];
                        final reply = _DetectReply(message.id, barcodes, null);
                        sendPort.send(reply);
                      } else {
                        throw error.toError();
                      }
                    } catch (e) {
                      final reply = _DetectReply(message.id, [], e);
                      sendPort.send(reply);
                    }
                  },
                );
                final request = VNDetectBarcodesRequest.alloc(visionLib)
                    .initWithCompletionHandler_(completionHandler);
                final symbologiesAddress = message.symbologiesAddress;
                if (symbologiesAddress != null) {
                  final symbologiesPtr =
                      Pointer<ObjCObject>.fromAddress(symbologiesAddress);
                  final symbologies =
                      NSArray.castFromPointer(visionLib, symbologiesPtr);
                  request.symbologies = symbologies;
                }
                final requests = [request].toNSArray();
                final error = using((arena) {
                  final errorPtr = arena<Pointer<ObjCObject>>();
                  return handler.performRequests_error_(requests, errorPtr)
                      ? null
                      : NSError.castFromPointer(visionLib, errorPtr.value)
                          .toError();
                });
                if (error == null) {
                  return;
                }
                throw error;
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
    _IsolateMessage(
      sendPort: receivePort.sendPort,
      token: ArgumentError.checkNotNull(RootIsolateToken.instance),
    ),
  );

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();

final atLeastiOS15_0 = atLeastiOSVersion(15.0);
final atLeastiOS17_0 = atLeastiOSVersion(17.0);
final atLeastmacOS12_0 = atLeastmacOSVersion(12.0);
final atLeastmacOS14_0 = atLeastmacOSVersion(14.0);

bool atLeastiOSVersion(double number) {
  final os = OS.instance;
  if (os is iOS) {
    final version = DarwinVersion.number(number);
    return os.atLeastVersion(version);
  }
  return false;
}

bool atLeastmacOSVersion(double number) {
  final os = OS.instance;
  if (os is macOS) {
    final version = DarwinVersion.number(number);
    return os.atLeastVersion(version);
  }
  return false;
}
