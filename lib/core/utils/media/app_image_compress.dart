import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Compresses camera/gallery bytes for reliable, storage-light uploads.
class AppImageCompress {
  AppImageCompress._();

  /// Prefer this for [ImagePicker.pickImage] `imageQuality`.
  static const int pickerQuality = 70;

  static const int maxEdge = 1024;
  static const int defaultQuality = 58;
  static const int minBytesToCompress = 40 * 1024;
  static const int maxOutputBytes = 180 * 1024;
  static const int strictEdge = 800;
  static const int strictQuality = 45;

  /// Returns compressed JPEG bytes, or [bytes] if compression is unnecessary/fails.
  static Future<Uint8List> compress(
    Uint8List bytes, {
    int maxWidth = maxEdge,
    int maxHeight = maxEdge,
    int quality = defaultQuality,
  }) async {
    if (bytes.lengthInBytes < minBytesToCompress) return bytes;

    try {
      var out = await _run(
        bytes,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        quality: quality,
      );
      if (out == null || out.isEmpty) return bytes;

      if (out.length > maxOutputBytes) {
        final stricter = await _run(
          Uint8List.fromList(out),
          maxWidth: strictEdge,
          maxHeight: strictEdge,
          quality: strictQuality,
        );
        if (stricter != null && stricter.isNotEmpty) {
          out = stricter;
        }
      }

      if (kDebugMode) {
        debugPrint(
          'AppImageCompress: ${bytes.lengthInBytes} → ${out.length} bytes',
        );
      }
      return Uint8List.fromList(out);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('AppImageCompress failed: $e\n$st');
      }
      return bytes;
    }
  }

  static Future<List<int>?> _run(
    Uint8List bytes, {
    required int maxWidth,
    required int maxHeight,
    required int quality,
  }) {
    return FlutterImageCompress.compressWithList(
      bytes,
      minWidth: maxWidth,
      minHeight: maxHeight,
      quality: quality,
      format: CompressFormat.jpeg,
    );
  }
}
