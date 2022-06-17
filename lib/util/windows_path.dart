import 'dart:io';

String? getWindowsFolder() {
  if (Platform.isWindows) {
    return Platform.environment["WINDIR"];
  }

  return null;
}
