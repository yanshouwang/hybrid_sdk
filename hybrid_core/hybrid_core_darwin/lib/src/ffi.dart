import 'dart:ffi';

import 'ffi.g.dart';

const foundationPath =
    '/System/Library/Frameworks/Foundation.framework/Foundation';
final foundationDyLib = DynamicLibrary.open(foundationPath);
final foundationLib = HybridCoreDarwinLibrary(foundationDyLib);
