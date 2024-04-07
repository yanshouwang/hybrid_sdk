import 'dart:ffi';

import 'ffi.g.dart';

const foundationPath =
    '/System/Library/Frameworks/Foundation.framework/Foundation';
final foundationLib = DynamicLibrary.open(foundationPath);
final foundation = HybridCore(foundationLib);
