import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Renders a photo ref as network, asset, base64, or [placeholder].
///
/// Ignores non-loadable values (empty, presence flags like `"available"`).
class AppRefImage extends StatelessWidget {
  const AppRefImage({
    super.key,
    required this.ref,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  final String? ref;
  final BoxFit fit;
  final Widget? placeholder;

  static bool isLoadable(String? value) {
    if (value == null) return false;
    final text = value.trim();
    if (text.isEmpty) return false;
    final lower = text.toLowerCase();
    if (lower == 'available' || lower == 'true' || lower == 'false') {
      return false;
    }
    if (lower.startsWith('http://') ||
        lower.startsWith('https://') ||
        lower.startsWith('assets/') ||
        lower.startsWith('data:image')) {
      return true;
    }
    return tryDecodeBase64(text) != null;
  }

  static Uint8List? tryDecodeBase64(String value) {
    var text = value.trim();
    if (text.isEmpty) return null;

    final dataUri = RegExp(
      r'^data:image\/[a-zA-Z0-9.+-]+;base64,',
      caseSensitive: false,
    ).firstMatch(text);
    if (dataUri != null) {
      text = text.substring(dataUri.end);
    }

    // Skip short / non-base64 strings (flags, ids). `/` is valid in base64
    // (JPEG payloads often start with `/9j/`).
    if (text.length < 64) return null;
    if (text.contains('://') || text.contains('\\')) return null;
    if (!RegExp(r'^[A-Za-z0-9+/=\s]+$').hasMatch(text)) return null;

    try {
      final bytes = base64Decode(text.replaceAll(RegExp(r'\s'), ''));
      // JPEG / PNG / GIF / WEBP magic bytes — reject random base64.
      if (bytes.length < 8) return null;
      final isJpeg = bytes[0] == 0xFF && bytes[1] == 0xD8;
      final isPng =
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47;
      final isGif = bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46;
      final isWebp =
          bytes.length >= 12 &&
          bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46;
      if (!(isJpeg || isPng || isGif || isWebp)) return null;
      return bytes;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = ref?.trim();
    if (value == null || value.isEmpty) {
      return placeholder ?? const SizedBox.shrink();
    }

    final lower = value.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return Image.network(
        value,
        fit: fit,
        errorBuilder: (_, _, _) => placeholder ?? const SizedBox.shrink(),
      );
    }

    if (lower.startsWith('assets/')) {
      return Image.asset(
        value,
        fit: fit,
        errorBuilder: (_, _, _) => placeholder ?? const SizedBox.shrink(),
      );
    }

    final bytes = tryDecodeBase64(value);
    if (bytes != null) {
      return Image.memory(
        bytes,
        fit: fit,
        errorBuilder: (_, _, _) => placeholder ?? const SizedBox.shrink(),
      );
    }

    return placeholder ?? const SizedBox.shrink();
  }
}
