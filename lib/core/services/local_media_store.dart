import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';

/// Stores photos captured offline as files and keeps only paths in SQLite.
///
/// Base64 is produced at flush time so a full day of registrations does not
/// bloat the database or hold large strings in memory.
class LocalMediaStore extends GetxService {
  LocalMediaStore(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();
  static const _folder = 'ob_offline_media';

  Directory? _dir;

  Future<Directory> _mediaDir() async {
    final cached = _dir;
    if (cached != null) return cached;
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, _folder));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _dir = dir;
    return dir;
  }

  /// Persists [bytes] and returns the media id to embed in an outbox payload.
  Future<String> save(Uint8List bytes, {required String purpose}) async {
    final dir = await _mediaDir();
    final id = _uuid.v4();
    final file = File(p.join(dir.path, '$id.jpg'));
    await file.writeAsBytes(bytes, flush: true);
    await _db.insertMedia(
      MediaFilesCompanion.insert(
        id: id,
        path: file.path,
        purpose: purpose,
        createdAt: DateTime.now(),
      ),
    );
    return id;
  }

  Future<Uint8List?> readBytes(String id) async {
    final row = await _db.mediaById(id);
    if (row == null) return null;
    final file = File(row.path);
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  Future<String?> readBase64(String id) async {
    final bytes = await readBytes(id);
    if (bytes == null) return null;
    return base64Encode(bytes);
  }

  /// Removes files and rows once the owning outbox entry is synced.
  Future<void> discard(Iterable<String> ids) async {
    for (final id in ids) {
      final row = await _db.mediaById(id);
      if (row == null) continue;
      final file = File(row.path);
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (_) {
          // Leave the file behind; the row is dropped either way.
        }
      }
    }
    await _db.deleteMedia(ids);
  }
}
