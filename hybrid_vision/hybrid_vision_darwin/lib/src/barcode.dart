import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:hybrid_core/hybrid_core.dart';
import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';

import 'core.dart';
import 'ffi.dart' as ffi;

class BarcodePlatformImpl extends BarcodePlatform {
  @override
  BarcodeDetector createDetector({
    List<BarcodeFormat>? formats,
  }) {
    final symbologies = formats == null || formats.isEmpty
        ? null
        : formats
            .map((format) => format.toVNBarcodeSymbologies())
            .expand((symbologyPtrs) => symbologyPtrs)
            .map((symbologyPtr) => ffi.DartVNBarcodeSymbology.castFromPointer(
                vision, symbologyPtr))
            .toList()
            .toNSArray();
    return BarcodeDetectorImpl(
      symbologies: symbologies,
    );
  }
}

class BarcodeDetectorImpl implements BarcodeDetector {
  final ffi.NSArray? symbologies;

  BarcodeDetectorImpl({
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
  List<ffi.VNBarcodeSymbology> toVNBarcodeSymbologies() {
    switch (this) {
      case BarcodeFormat.aztec:
        return [
          vision.VNBarcodeSymbologyAztec,
        ];
      case BarcodeFormat.codabar:
        return (atLeastiOS15_0 || atLeastmacOS12_0)
            ? [
                vision.VNBarcodeSymbologyCodabar,
              ]
            : [];
      case BarcodeFormat.code128:
        return [
          vision.VNBarcodeSymbologyCode128,
        ];
      case BarcodeFormat.code39:
        return [
          vision.VNBarcodeSymbologyCode39,
          vision.VNBarcodeSymbologyCode39Checksum,
          vision.VNBarcodeSymbologyCode39FullASCII,
          vision.VNBarcodeSymbologyCode39FullASCIIChecksum,
        ];
      case BarcodeFormat.code93:
        return [
          vision.VNBarcodeSymbologyCode93,
          vision.VNBarcodeSymbologyCode93i,
        ];
      case BarcodeFormat.dataMatrix:
        return [
          vision.VNBarcodeSymbologyDataMatrix,
        ];
      case BarcodeFormat.ean13:
        return [
          vision.VNBarcodeSymbologyEAN13,
        ];
      case BarcodeFormat.ean8:
        return [
          vision.VNBarcodeSymbologyEAN8,
        ];
      case BarcodeFormat.gs1DataBar:
        return (atLeastiOS15_0 || atLeastmacOS12_0)
            ? [
                vision.VNBarcodeSymbologyGS1DataBar,
                vision.VNBarcodeSymbologyGS1DataBarExpanded,
                vision.VNBarcodeSymbologyGS1DataBarLimited,
              ]
            : [];
      case BarcodeFormat.itf:
        return [
          vision.VNBarcodeSymbologyITF14,
          vision.VNBarcodeSymbologyI2of5,
          vision.VNBarcodeSymbologyI2of5Checksum,
        ];
      case BarcodeFormat.msiPlessey:
        return (atLeastiOS17_0 || atLeastmacOS14_0)
            ? [
                vision.VNBarcodeSymbologyMSIPlessey,
              ]
            : [];
      case BarcodeFormat.pdf417:
        return [
          vision.VNBarcodeSymbologyPDF417,
          if (atLeastiOS15_0 || atLeastmacOS12_0)
            vision.VNBarcodeSymbologyMicroPDF417,
        ];
      case BarcodeFormat.qrCode:
        return [
          vision.VNBarcodeSymbologyQR,
          if (atLeastiOS15_0 || atLeastmacOS12_0)
            vision.VNBarcodeSymbologyMicroQR,
        ];
      case BarcodeFormat.upcE:
        return [
          vision.VNBarcodeSymbologyUPCE,
        ];
      default:
        return [];
    }
  }
}

extension on ffi.VNBarcodeObservation {
  Rect get boundingBox {
    return ffi.using(
      (arena) {
        final boundingBoxPtr = arena<ffi.CGRect>();
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

extension on ffi.DartVNBarcodeSymbology {
  bool equals(ffi.VNBarcodeSymbology other) =>
      ffi.DartVNBarcodeSymbology.castFromPointer(vision, other)
          .isEqualToString_(this);

  bool get equalsAztec => equals(vision.VNBarcodeSymbologyAztec);
  bool get equalsCodabar =>
      (atLeastiOS15_0 || atLeastmacOS12_0) &&
      equals(vision.VNBarcodeSymbologyCodabar);
  bool get equalsCode128 => equals(vision.VNBarcodeSymbologyCode128);
  bool get equalsCode39 =>
      equals(vision.VNBarcodeSymbologyCode39) ||
      equals(vision.VNBarcodeSymbologyCode39Checksum) ||
      equals(vision.VNBarcodeSymbologyCode39FullASCII) ||
      equals(vision.VNBarcodeSymbologyCode39FullASCIIChecksum);
  bool get equalsCode93 =>
      equals(vision.VNBarcodeSymbologyCode93) ||
      equals(vision.VNBarcodeSymbologyCode93i);
  bool get equalsDataMatrix => equals(vision.VNBarcodeSymbologyDataMatrix);
  bool get equalsEAN13 => equals(vision.VNBarcodeSymbologyEAN13);
  bool get equalsEAN8 => equals(vision.VNBarcodeSymbologyEAN8);
  bool get equalsGS1DataBar => (atLeastiOS15_0 || atLeastmacOS12_0)
      ? equals(vision.VNBarcodeSymbologyGS1DataBar) ||
          equals(vision.VNBarcodeSymbologyGS1DataBarExpanded) ||
          equals(vision.VNBarcodeSymbologyGS1DataBarLimited)
      : false;
  bool get equalsITF =>
      equals(vision.VNBarcodeSymbologyITF14) ||
      equals(vision.VNBarcodeSymbologyI2of5) ||
      equals(vision.VNBarcodeSymbologyI2of5Checksum);
  bool get equalsMSIPlessey =>
      (atLeastiOS17_0 || atLeastmacOS14_0) &&
      equals(vision.VNBarcodeSymbologyMSIPlessey);
  bool get equalsPDF417 => (atLeastiOS15_0 || atLeastmacOS12_0)
      ? equals(vision.VNBarcodeSymbologyPDF417) ||
          equals(vision.VNBarcodeSymbologyMicroPDF417)
      : equals(vision.VNBarcodeSymbologyPDF417);
  bool get equalsQrCode => (atLeastiOS15_0 || atLeastmacOS12_0)
      ? equals(vision.VNBarcodeSymbologyQR) ||
          equals(vision.VNBarcodeSymbologyMicroQR)
      : equals(vision.VNBarcodeSymbologyQR);
  bool get equalsUPCE => equals(vision.VNBarcodeSymbologyUPCE);

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

extension on ffi.NSArray {
  List<Barcode> toBarcodes() {
    final barcodes = <Barcode>[];
    for (var i = 0; i < count; i++) {
      final object = objectAtIndex_(i);
      final barcode = ffi.VNBarcodeObservation.castFrom(object).toBarcode();
      if (barcode == null) {
        continue;
      }
      barcodes.add(barcode);
    }
    return barcodes;
  }
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
    (sendPort) {
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
                    ffi.DartVNRequestCompletionHandler.listener(
                  vision,
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
                final request = ffi.VNDetectBarcodesRequest.alloc(vision)
                    .initWithCompletionHandler_(completionHandler);
                final symbologiesAddress = message.symbologiesAddress;
                if (symbologiesAddress != null) {
                  final symbologiesPtr =
                      ffi.Pointer<ffi.ObjCObject>.fromAddress(
                          symbologiesAddress);
                  final symbologies =
                      ffi.NSArray.castFromPointer(vision, symbologiesPtr);
                  request.symbologies = symbologies;
                }
                final requests = [request].toNSArray();
                final error = ffi.using((arena) {
                  final errorPtr = arena<ffi.Pointer<ffi.ObjCObject>>();
                  return handler.performRequests_error_(requests, errorPtr)
                      ? null
                      : ffi.NSError.castFromPointer(vision, errorPtr.value)
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
    receivePort.sendPort,
  );

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();

final atLeastiOS15_0 = atLeastiOSVersion(15.0);
final atLeastiOS17_0 = atLeastiOSVersion(17.0);
final atLeastmacOS12_0 = atLeastmacOSVersion(12.0);
final atLeastmacOS14_0 = atLeastmacOSVersion(14.0);

bool atLeastiOSVersion(double version) {
  final os = OS();
  if (os is iOS) {
    final version = DarwinOSVersion.number(15.0);
    return os.atLeastVersion(version);
  }
  return false;
}

bool atLeastmacOSVersion(double version) {
  final os = OS();
  if (os is macOS) {
    final version = DarwinOSVersion.number(15.0);
    return os.atLeastVersion(version);
  }
  return false;
}
