import 'dart:ffi';

import 'ffi.g.dart';

const _foundationPath =
    '/System/Library/Frameworks/Foundation.framework/Foundation';
final _foundationLib = DynamicLibrary.open(_foundationPath);
final foundationLib = HybridCoreDarwinLibrary(_foundationLib);
