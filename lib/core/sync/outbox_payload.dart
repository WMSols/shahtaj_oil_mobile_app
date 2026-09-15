/// Payload helpers shared by every queued write.
///
/// Offline payloads carry two kinds of placeholder:
/// * negative ids for records the server has not created yet, and
/// * `{'__media': '<id>'}` maps standing in for photo bytes on disk.
///
/// Both are replaced immediately before the request goes out, so handlers
/// always receive a payload with real server ids and real base64 strings.
library;

/// Thrown when a negative id in a payload has no server id yet.
class UnresolvedLocalIdException implements Exception {
  UnresolvedLocalIdException(this.entityType, this.localId);

  final String entityType;
  final int localId;

  @override
  String toString() =>
      'Waiting for server $entityType id (local $localId) before syncing.';
}

/// Thrown when a referenced photo file is gone.
class MissingMediaException implements Exception {
  MissingMediaException(this.mediaId);

  final String mediaId;

  @override
  String toString() => 'Captured photo $mediaId is no longer on device.';
}

abstract class OutboxPayload {
  OutboxPayload._();

  static const mediaKey = '__media';

  /// Payload keys that hold ids the server owns, mapped to their entity type.
  static const _idKeys = <String, String>{
    'visit_id': 'visit',
    'task_id': 'task',
    'shop_id': 'shop',
  };

  static Map<String, dynamic> mediaRef(String id) => {mediaKey: id};

  static String? mediaIdOf(Object? value) {
    if (value is Map && value.length == 1 && value[mediaKey] is String) {
      return value[mediaKey] as String;
    }
    return null;
  }

  /// Every media id referenced anywhere inside [payload].
  static List<String> collectMediaIds(Object? payload) {
    final ids = <String>[];
    void walk(Object? node) {
      final mediaId = mediaIdOf(node);
      if (mediaId != null) {
        ids.add(mediaId);
        return;
      }
      if (node is Map) {
        for (final value in node.values) {
          walk(value);
        }
      } else if (node is List) {
        for (final value in node) {
          walk(value);
        }
      }
    }

    walk(payload);
    return ids;
  }

  /// Reads a negative local id from [value], preserving int or string form.
  static int? localIdOf(Object? value) {
    final parsed = value is num
        ? value.toInt()
        : int.tryParse(value?.toString() ?? '');
    if (parsed == null || parsed >= 0) return null;
    return parsed;
  }

  /// Replaces local ids and media refs throughout [payload].
  ///
  /// Throws [UnresolvedLocalIdException] when an id cannot be translated yet,
  /// which keeps the entry queued instead of sending a bad request.
  static Future<Map<String, dynamic>> resolve(
    Map<String, dynamic> payload, {
    required Future<int?> Function(String entityType, int localId)
    lookupServerId,
    required Future<String?> Function(String mediaId) readMediaBase64,
  }) async {
    Future<Object?> walk(String? key, Object? node) async {
      final mediaId = mediaIdOf(node);
      if (mediaId != null) {
        final base64 = await readMediaBase64(mediaId);
        if (base64 == null) throw MissingMediaException(mediaId);
        return base64;
      }

      if (node is Map) {
        final result = <String, dynamic>{};
        for (final entry in node.entries) {
          result[entry.key.toString()] = await walk(
            entry.key.toString(),
            entry.value,
          );
        }
        return result;
      }

      if (node is List) {
        final result = <Object?>[];
        for (final value in node) {
          result.add(await walk(key, value));
        }
        return result;
      }

      final entityType = key == null ? null : _idKeys[key];
      if (entityType != null) {
        final localId = localIdOf(node);
        if (localId != null) {
          final serverId = await lookupServerId(entityType, localId);
          if (serverId == null) {
            throw UnresolvedLocalIdException(entityType, localId);
          }
          return node is String ? '$serverId' : serverId;
        }
      }

      return node;
    }

    final resolved = await walk(null, payload);
    return Map<String, dynamic>.from(resolved as Map);
  }
}
