import 'dart:ffi' as ffi;
import 'dart:io' show Directory, File, Platform;

import 'package:path/path.dart' as path;

ffi.DynamicLibrary? load_dylib(String libPath) {
  if (!Platform.isWindows) return null;

  final dylibPath = path.join(Directory.current.path, libPath);
  if (!File(dylibPath).existsSync()) {
    print("[Memory] Dylib not found: $dylibPath");
    return null;
  }

  return ffi.DynamicLibrary.open(dylibPath);
}
