import 'dart:typed_data';
import 'dart:ui';

import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';

import 'ffi.dart' as ffi;

const _visionPath = '/System/Library/Frameworks/Vision.framework/Vision';
final _visionLib = ffi.DynamicLibrary.open(_visionPath);
final vision = ffi.HybridVision(_visionLib);

extension MemoryVisionImageX on MemoryVisionImage {
  ffi.VNImageRequestHandler toVNImageRequestHandler() {
    final imageData = memory.toNSData();
    final orientation = rotationDegrees;
    final options = ffi.NSDictionary.alloc(vision).init();
    return ffi.VNImageRequestHandler.alloc(vision)
        .initWithData_orientation_options_(imageData, orientation, options);
  }
}

extension UriVisionImageX on UriVisionImage {
  ffi.VNImageRequestHandler toVNImageRequestHandler() {
    final imageURL = uri.toNSURL();
    final orientation = rotationDegrees;
    final options = ffi.NSDictionary.alloc(vision).init();
    return ffi.VNImageRequestHandler.alloc(vision)
        .initWithURL_orientation_options_(imageURL, orientation, options);
  }
}

extension UriX on Uri {
  ffi.NSURL toNSURL() {
    final urlString = toString().toNSString(vision);
    final url = ffi.NSURL.alloc(vision).initWithString_(urlString);
    return ArgumentError.checkNotNull(url);
  }
}

extension NSObjectListX on List<ffi.NSObject> {
  ffi.NSArray toNSArray() {
    final array = ffi.NSMutableArray.alloc(vision).initWithCapacity_(length);
    for (var i = 0; i < length; i++) {
      final object = this[i];
      array.insertObject_atIndex_(object, i);
    }
    return array;
  }
}

extension Uint8ListX on Uint8List {
  ffi.NSData toNSData() {
    return ffi.using(
      (arena) {
        final bytesPtr = arena<ffi.Uint8>(length);
        bytesPtr.asTypedList(length).setAll(0, this);
        return ffi.NSData.dataWithBytes_length_(
          vision,
          bytesPtr.cast(),
          length,
        );
      },
    );
  }
}

extension NSArrayX on ffi.NSArray {
  List<String> toStrings() {
    final strings = <String>[];
    for (var i = 0; i < count; i++) {
      final object = objectAtIndex_(i);
      final string = ffi.NSString.castFrom(object).toString();
      strings.add(string);
    }
    return strings;
  }
}

extension NSDataX on ffi.NSData {
  Uint8List toUint8List() {
    if (bytes.address == 0) {
      return Uint8List(0);
    } else {
      return bytes.cast<ffi.Uint8>().asTypedList(length);
    }
  }
}

extension CGPointX on ffi.CGPoint {
  Offset toOffset() => Offset(x, y);
}

extension CGRectX on ffi.CGRect {
  Rect toRect() {
    final origin = this.origin;
    final size = this.size;
    final left = origin.x;
    // Vision/CoreML 的坐标原点在图像的左下角
    final top = 1 - origin.y - size.height;
    final width = size.width;
    final height = size.height;
    return Rect.fromLTWH(left, top, width, height);
  }
}

extension NSErrorX on ffi.NSError {
  Object toError() {
    return '$code: $localizedDescription';
  }
}
