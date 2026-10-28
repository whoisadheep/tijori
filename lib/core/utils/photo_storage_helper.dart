import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

abstract final class PhotoStorageHelper {
  static const _uuid = Uuid();
  static const _subDirName = 'tijori_vault_photos';

  /// Prompts the user to pick an image file and persists a copy in the
  /// local application documents directory. Returns the absolute file path,
  /// or null if the user canceled.
  static Future<String?> pickAndSaveCollateralPhoto() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'heic'],
        allowMultiple: false,
        dialogTitle: 'Select Collateral Ornament Photo',
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final sourcePath = result.files.single.path;
      if (sourcePath == null) return null;

      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) return null;

      // Ensure target directory exists
      final docsDir = await getApplicationDocumentsDirectory();
      final targetDir = Directory(p.join(docsDir.path, _subDirName));
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      // Generate a unique, sanitized local filename
      final ext = p.extension(sourcePath).toLowerCase();
      final fileName = 'pawn_${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4().substring(0, 8)}$ext';
      final targetPath = p.join(targetDir.path, fileName);

      // Copy source file to application sandbox
      await sourceFile.copy(targetPath);
      return targetPath;
    } catch (e) {
      debugPrint('[PhotoStorageHelper] Error picking or saving photo: $e');
      return null;
    }
  }

  /// Verifies if a given local file path exists on disk.
  static bool photoExists(String? path) {
    if (path == null || path.trim().isEmpty) return false;
    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }

  /// Reads image bytes synchronously if file exists, else returns null.
  static Uint8List? readPhotoBytes(String? path) {
    if (!photoExists(path)) return null;
    try {
      return File(path!).readAsBytesSync();
    } catch (_) {
      return null;
    }
  }
}
