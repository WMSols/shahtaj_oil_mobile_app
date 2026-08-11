import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Compresses camera/gallery bytes for reliable uploads.
class AppImageCompress {
  AppImageCompress._();

  static const int maxEdge = 1600;
  static const int defaultQuality = 72;
  static const int minBytesToCompress = 180 * 1024;

  /// Returns compressed JPEG bytes, or [bytes] if compression is unnecessary/fails.
  static Future<Uint8List> compress(
    Uint8List bytes, {
    int maxWidth = maxEdge,
    int maxHeight = maxEdge,
    int quality = defaultQuality,
  }) async {
    if (bytes.lengthInBytes < minBytesToCompress) return bytes;

    try {
      final out = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: maxWidth,
        minHeight: maxHeight,
        quality: quality,
        format: CompressFormat.jpeg,
      );
      if (out.isEmpty) return bytes;
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
}
