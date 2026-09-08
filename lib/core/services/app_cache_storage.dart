import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Fast file-backed JSON cache for bulk payloads (not secrets).
class AppCacheStorage {
  AppCacheStorage();

  Directory? _cacheDir;

  Future<Directory> _dir() async {
    if (_cacheDir != null) return _cacheDir!;
    final base = await getApplicationSupportDirectory();
    _cacheDir = Directory(p.join(base.path, 'app_cache'));
    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }
    return _cacheDir!;
  }

  String _safeKey(String key) => key.replaceAll(RegExp(r'[^\w\-.]'), '_');

  Future<File> _fileFor(String key) async {
    final dir = await _dir();
    return File(p.join(dir.path, '${_safeKey(key)}.json'));
  }

  Future<File> _metaFileFor(String key) async {
    final dir = await _dir();
    return File(p.join(dir.path, '${_safeKey(key)}.meta.json'));
  }

  Future<void> saveMap(String key, Map<String, dynamic> data) async {
    final file = await _fileFor(key);
    await file.writeAsString(jsonEncode(data));
    await _writeMeta(key, DateTime.now());
  }

  Future<void> saveList(String key, List<Map<String, dynamic>> items) async {
    await saveMap(key, {'items': items});
  }

  Future<Map<String, dynamic>?> readMap(String key) async {
    final file = await _fileFor(key);
    if (!await file.exists()) return null;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  Future<List<Map<String, dynamic>>> readList(String key) async {
    final map = await readMap(key);
    if (map == null) return const [];
    final raw = map['items'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
  }

  Future<DateTime?> readUpdatedAt(String key) async {
    final meta = await _metaFileFor(key);
    if (!await meta.exists()) return null;
    try {
      final decoded = jsonDecode(await meta.readAsString());
      if (decoded is Map) {
        return DateTime.tryParse(decoded['updated_at']?.toString() ?? '');
      }
    } catch (_) {}
    return null;
  }

  Future<void> _writeMeta(String key, DateTime updatedAt) async {
    final meta = await _metaFileFor(key);
    await meta.writeAsString(
      jsonEncode({'updated_at': updatedAt.toUtc().toIso8601String()}),
    );
  }

  Future<void> delete(String key) async {
    final file = await _fileFor(key);
    final meta = await _metaFileFor(key);
    if (await file.exists()) await file.delete();
    if (await meta.exists()) await meta.delete();
  }

  Future<void> clearKeys(Iterable<String> keys) async {
    for (final key in keys) {
      await delete(key);
    }
  }

  /// One-time import from secure storage JSON strings.
  Future<void> importFromSecureStorage({
    required String key,
    required Future<String?> Function() readLegacy,
  }) async {
    if (await readMap(key) != null) return;
    final raw = await readLegacy();
    if (raw == null || raw.trim().isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        await saveMap(key, decoded);
      } else if (decoded is Map) {
        await saveMap(key, Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
  }
}
