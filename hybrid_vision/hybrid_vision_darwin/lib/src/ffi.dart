import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';

import 'package:ffi/ffi.dart';
import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';

import 'ffi.g.dart';

const _visionPath = '/System/Library/Frameworks/Vision.framework/Vision';
final _visionLib = DynamicLibrary.open(_visionPath);
final visionLib = HybridVisionDarwinLibrary(_visionLib);

extension MemoryVisionImageX on MemoryVisionImage {
  VNImageRequestHandler toVNImageRequestHandler() {
    final imageData = memory.toNSData();
    final orientation = rotationDegrees;
    final options = NSDictionary.alloc(visionLib).init();
    return VNImageRequestHandler.alloc(visionLib)
        .initWithData_orientation_options_(imageData, orientation, options);
  }
}

extension UriVisionImageX on UriVisionImage {
  VNImageRequestHandler toVNImageRequestHandler() {
    final imageURL = uri.toNSURL();
    final orientation = rotationDegrees;
    final options = NSDictionary.alloc(visionLib).init();
    return VNImageRequestHandler.alloc(visionLib)
        .initWithURL_orientation_options_(imageURL, orientation, options);
  }
}

extension UriX on Uri {
  NSURL toNSURL() {
    final urlString = toString().toNSString(visionLib);
    final url = NSURL.alloc(visionLib).initWithString_(urlString);
    return ArgumentError.checkNotNull(url);
  }
}

extension NSObjectListX on List<NSObject> {
  NSArray toNSArray() {
    final array = NSMutableArray.alloc(visionLib).initWithCapacity_(length);
    for (var i = 0; i < length; i++) {
      final object = this[i];
      array.insertObject_atIndex_(object, i);
    }
    return array;
  }
}

extension Uint8ListX on Uint8List {
  NSData toNSData() {
    return using((arena) {
      final bytesPtr = arena<Uint8>(length);
      bytesPtr.asTypedList(length).setAll(0, this);
      return NSData.dataWithBytes_length_(
        visionLib,
        bytesPtr.cast(),
        length,
      );
    });
  }
}

extension NSArrayX on NSArray {
  List<String> toStrings() {
    final strings = <String>[];
    for (var i = 0; i < count; i++) {
      final object = objectAtIndex_(i);
      final string = NSString.castFrom(object).toString();
      strings.add(string);
    }
    return strings;
  }
}

extension NSDataX on NSData {
  Uint8List toUint8List() {
    if (bytes.address == 0) {
      return Uint8List(0);
    } else {
      return bytes.cast<Uint8>().asTypedList(length);
    }
  }
}

extension CGPointX on CGPoint {
  Offset toOffset() => Offset(x, y);
}

extension CGRectX on CGRect {
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

extension NSErrorX on NSError {
  Object toError() {
    return '$code: $localizedDescription';
  }
}
