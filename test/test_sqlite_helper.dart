import 'dart:ffi';
import 'dart:io';
import 'package:sqlite3/open.dart';

/// Initializes native SQLite dynamic library across Linux, macOS, and Windows.
void initializeTestSqlite() {
  if (Platform.isLinux) {
    try {
      open.overrideFor(
        OperatingSystem.linux,
        () => DynamicLibrary.open('libsqlite3.so.0'),
      );
    } catch (_) {}
  } else if (Platform.isMacOS) {
    try {
      open.overrideFor(
        OperatingSystem.macOS,
        () => DynamicLibrary.open('libsqlite3.dylib'),
      );
    } catch (_) {}
  } else if (Platform.isWindows) {
    try {
      open.overrideFor(
        OperatingSystem.windows,
        () => DynamicLibrary.open('sqlite3.dll'),
      );
    } catch (_) {}
  }
}
