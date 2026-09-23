// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientRequestIdMeta = const VerificationMeta(
    'clientRequestId',
  );
  @override
  late final GeneratedColumn<String> clientRequestId = GeneratedColumn<String>(
    'client_request_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('queued'),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dependsOnMeta = const VerificationMeta(
    'dependsOn',
  );
  @override
  late final GeneratedColumn<String> dependsOn = GeneratedColumn<String>(
    'depends_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localEntityIdMeta = const VerificationMeta(
    'localEntityId',
  );
  @override
  late final GeneratedColumn<int> localEntityId = GeneratedColumn<int>(
    'local_entity_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaIdsMeta = const VerificationMeta(
    'mediaIds',
  );
  @override
  late final GeneratedColumn<String> mediaIds = GeneratedColumn<String>(
    'media_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    role,
    action,
    payloadJson,
    clientRequestId,
    status,
    attempts,
    lastError,
    createdAt,
    syncedAt,
    dependsOn,
    userId,
    entityType,
    localEntityId,
    mediaIds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('client_request_id')) {
      context.handle(
        _clientRequestIdMeta,
        clientRequestId.isAcceptableOrUnknown(
          data['client_request_id']!,
          _clientRequestIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientRequestIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('depends_on')) {
      context.handle(
        _dependsOnMeta,
        dependsOn.isAcceptableOrUnknown(data['depends_on']!, _dependsOnMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    }
    if (data.containsKey('local_entity_id')) {
      context.handle(
        _localEntityIdMeta,
        localEntityId.isAcceptableOrUnknown(
          data['local_entity_id']!,
          _localEntityIdMeta,
        ),
      );
    }
    if (data.containsKey('media_ids')) {
      context.handle(
        _mediaIdsMeta,
        mediaIds.isAcceptableOrUnknown(data['media_ids']!, _mediaIdsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      clientRequestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_request_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      dependsOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}depends_on'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      ),
      localEntityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_entity_id'],
      ),
      mediaIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_ids'],
      ),
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final String id;
  final String role;
  final String action;
  final String payloadJson;
  final String clientRequestId;
  final String status;
  final int attempts;
  final String? lastError;
  final DateTime createdAt;
  final DateTime? syncedAt;

  /// Outbox id this entry must wait for (verify-on-site before check-in).
  final String? dependsOn;

  /// Owner of the queued work. Flush only runs entries for the signed-in user.
  final String? userId;

  /// Local record this entry creates on the server (`visit` / `shop`).
  final String? entityType;
  final int? localEntityId;

  /// Comma separated [MediaFiles] ids referenced by the payload.
  final String? mediaIds;
  const OutboxEntry({
    required this.id,
    required this.role,
    required this.action,
    required this.payloadJson,
    required this.clientRequestId,
    required this.status,
    required this.attempts,
    this.lastError,
    required this.createdAt,
    this.syncedAt,
    this.dependsOn,
    this.userId,
    this.entityType,
    this.localEntityId,
    this.mediaIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['role'] = Variable<String>(role);
    map['action'] = Variable<String>(action);
    map['payload_json'] = Variable<String>(payloadJson);
    map['client_request_id'] = Variable<String>(clientRequestId);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || dependsOn != null) {
      map['depends_on'] = Variable<String>(dependsOn);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || localEntityId != null) {
      map['local_entity_id'] = Variable<int>(localEntityId);
    }
    if (!nullToAbsent || mediaIds != null) {
      map['media_ids'] = Variable<String>(mediaIds);
    }
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      id: Value(id),
      role: Value(role),
      action: Value(action),
      payloadJson: Value(payloadJson),
      clientRequestId: Value(clientRequestId),
      status: Value(status),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      dependsOn: dependsOn == null && nullToAbsent
          ? const Value.absent()
          : Value(dependsOn),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      localEntityId: localEntityId == null && nullToAbsent
          ? const Value.absent()
          : Value(localEntityId),
      mediaIds: mediaIds == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaIds),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<String>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      action: serializer.fromJson<String>(json['action']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      clientRequestId: serializer.fromJson<String>(json['clientRequestId']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      dependsOn: serializer.fromJson<String?>(json['dependsOn']),
      userId: serializer.fromJson<String?>(json['userId']),
      entityType: serializer.fromJson<String?>(json['entityType']),
      localEntityId: serializer.fromJson<int?>(json['localEntityId']),
      mediaIds: serializer.fromJson<String?>(json['mediaIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'role': serializer.toJson<String>(role),
      'action': serializer.toJson<String>(action),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'clientRequestId': serializer.toJson<String>(clientRequestId),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'dependsOn': serializer.toJson<String?>(dependsOn),
      'userId': serializer.toJson<String?>(userId),
      'entityType': serializer.toJson<String?>(entityType),
      'localEntityId': serializer.toJson<int?>(localEntityId),
      'mediaIds': serializer.toJson<String?>(mediaIds),
    };
  }

  OutboxEntry copyWith({
    String? id,
    String? role,
    String? action,
    String? payloadJson,
    String? clientRequestId,
    String? status,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
    Value<String?> dependsOn = const Value.absent(),
    Value<String?> userId = const Value.absent(),
    Value<String?> entityType = const Value.absent(),
    Value<int?> localEntityId = const Value.absent(),
    Value<String?> mediaIds = const Value.absent(),
  }) => OutboxEntry(
    id: id ?? this.id,
    role: role ?? this.role,
    action: action ?? this.action,
    payloadJson: payloadJson ?? this.payloadJson,
    clientRequestId: clientRequestId ?? this.clientRequestId,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    dependsOn: dependsOn.present ? dependsOn.value : this.dependsOn,
    userId: userId.present ? userId.value : this.userId,
    entityType: entityType.present ? entityType.value : this.entityType,
    localEntityId: localEntityId.present
        ? localEntityId.value
        : this.localEntityId,
    mediaIds: mediaIds.present ? mediaIds.value : this.mediaIds,
  );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      action: data.action.present ? data.action.value : this.action,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      clientRequestId: data.clientRequestId.present
          ? data.clientRequestId.value
          : this.clientRequestId,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      dependsOn: data.dependsOn.present ? data.dependsOn.value : this.dependsOn,
      userId: data.userId.present ? data.userId.value : this.userId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      localEntityId: data.localEntityId.present
          ? data.localEntityId.value
          : this.localEntityId,
      mediaIds: data.mediaIds.present ? data.mediaIds.value : this.mediaIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('action: $action, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('clientRequestId: $clientRequestId, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('dependsOn: $dependsOn, ')
          ..write('userId: $userId, ')
          ..write('entityType: $entityType, ')
          ..write('localEntityId: $localEntityId, ')
          ..write('mediaIds: $mediaIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    role,
    action,
    payloadJson,
    clientRequestId,
    status,
    attempts,
    lastError,
    createdAt,
    syncedAt,
    dependsOn,
    userId,
    entityType,
    localEntityId,
    mediaIds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.role == this.role &&
          other.action == this.action &&
          other.payloadJson == this.payloadJson &&
          other.clientRequestId == this.clientRequestId &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt &&
          other.dependsOn == this.dependsOn &&
          other.userId == this.userId &&
          other.entityType == this.entityType &&
          other.localEntityId == this.localEntityId &&
          other.mediaIds == this.mediaIds);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<String> id;
  final Value<String> role;
  final Value<String> action;
  final Value<String> payloadJson;
  final Value<String> clientRequestId;
  final Value<String> status;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<String?> dependsOn;
  final Value<String?> userId;
  final Value<String?> entityType;
  final Value<int?> localEntityId;
  final Value<String?> mediaIds;
  final Value<int> rowid;
  const OutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.action = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.clientRequestId = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.dependsOn = const Value.absent(),
    this.userId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.localEntityId = const Value.absent(),
    this.mediaIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    required String id,
    required String role,
    required String action,
    required String payloadJson,
    required String clientRequestId,
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    this.syncedAt = const Value.absent(),
    this.dependsOn = const Value.absent(),
    this.userId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.localEntityId = const Value.absent(),
    this.mediaIds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       role = Value(role),
       action = Value(action),
       payloadJson = Value(payloadJson),
       clientRequestId = Value(clientRequestId),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<String>? id,
    Expression<String>? role,
    Expression<String>? action,
    Expression<String>? payloadJson,
    Expression<String>? clientRequestId,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<String>? dependsOn,
    Expression<String>? userId,
    Expression<String>? entityType,
    Expression<int>? localEntityId,
    Expression<String>? mediaIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (action != null) 'action': action,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (clientRequestId != null) 'client_request_id': clientRequestId,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (dependsOn != null) 'depends_on': dependsOn,
      if (userId != null) 'user_id': userId,
      if (entityType != null) 'entity_type': entityType,
      if (localEntityId != null) 'local_entity_id': localEntityId,
      if (mediaIds != null) 'media_ids': mediaIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? role,
    Value<String>? action,
    Value<String>? payloadJson,
    Value<String>? clientRequestId,
    Value<String>? status,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
    Value<String?>? dependsOn,
    Value<String?>? userId,
    Value<String?>? entityType,
    Value<int?>? localEntityId,
    Value<String?>? mediaIds,
    Value<int>? rowid,
  }) {
    return OutboxEntriesCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      action: action ?? this.action,
      payloadJson: payloadJson ?? this.payloadJson,
      clientRequestId: clientRequestId ?? this.clientRequestId,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      dependsOn: dependsOn ?? this.dependsOn,
      userId: userId ?? this.userId,
      entityType: entityType ?? this.entityType,
      localEntityId: localEntityId ?? this.localEntityId,
      mediaIds: mediaIds ?? this.mediaIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (clientRequestId.present) {
      map['client_request_id'] = Variable<String>(clientRequestId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (dependsOn.present) {
      map['depends_on'] = Variable<String>(dependsOn.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (localEntityId.present) {
      map['local_entity_id'] = Variable<int>(localEntityId.value);
    }
    if (mediaIds.present) {
      map['media_ids'] = Variable<String>(mediaIds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('action: $action, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('clientRequestId: $clientRequestId, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('dependsOn: $dependsOn, ')
          ..write('userId: $userId, ')
          ..write('entityType: $entityType, ')
          ..write('localEntityId: $localEntityId, ')
          ..write('mediaIds: $mediaIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisitCartLinesTable extends VisitCartLines
    with TableInfo<$VisitCartLinesTable, VisitCartLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitCartLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<int> visitId = GeneratedColumn<int>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<int> lineId = GeneratedColumn<int>(
    'line_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceUnitMeta = const VerificationMeta(
    'priceUnit',
  );
  @override
  late final GeneratedColumn<double> priceUnit = GeneratedColumn<double>(
    'price_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLocalOnlyMeta = const VerificationMeta(
    'isLocalOnly',
  );
  @override
  late final GeneratedColumn<bool> isLocalOnly = GeneratedColumn<bool>(
    'is_local_only',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_local_only" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    visitId,
    lineId,
    productId,
    productName,
    quantity,
    priceUnit,
    unit,
    isLocalOnly,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visit_cart_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisitCartLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('line_id')) {
      context.handle(
        _lineIdMeta,
        lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lineIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price_unit')) {
      context.handle(
        _priceUnitMeta,
        priceUnit.isAcceptableOrUnknown(data['price_unit']!, _priceUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_priceUnitMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('is_local_only')) {
      context.handle(
        _isLocalOnlyMeta,
        isLocalOnly.isAcceptableOrUnknown(
          data['is_local_only']!,
          _isLocalOnlyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {visitId, lineId};
  @override
  VisitCartLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisitCartLine(
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_id'],
      )!,
      lineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      priceUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_unit'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      isLocalOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_local_only'],
      )!,
    );
  }

  @override
  $VisitCartLinesTable createAlias(String alias) {
    return $VisitCartLinesTable(attachedDatabase, alias);
  }
}

class VisitCartLine extends DataClass implements Insertable<VisitCartLine> {
  final int visitId;
  final int lineId;
  final int productId;
  final String productName;
  final double quantity;
  final double priceUnit;
  final String? unit;
  final bool isLocalOnly;
  const VisitCartLine({
    required this.visitId,
    required this.lineId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceUnit,
    this.unit,
    required this.isLocalOnly,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['visit_id'] = Variable<int>(visitId);
    map['line_id'] = Variable<int>(lineId);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<double>(quantity);
    map['price_unit'] = Variable<double>(priceUnit);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['is_local_only'] = Variable<bool>(isLocalOnly);
    return map;
  }

  VisitCartLinesCompanion toCompanion(bool nullToAbsent) {
    return VisitCartLinesCompanion(
      visitId: Value(visitId),
      lineId: Value(lineId),
      productId: Value(productId),
      productName: Value(productName),
      quantity: Value(quantity),
      priceUnit: Value(priceUnit),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      isLocalOnly: Value(isLocalOnly),
    );
  }

  factory VisitCartLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisitCartLine(
      visitId: serializer.fromJson<int>(json['visitId']),
      lineId: serializer.fromJson<int>(json['lineId']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      priceUnit: serializer.fromJson<double>(json['priceUnit']),
      unit: serializer.fromJson<String?>(json['unit']),
      isLocalOnly: serializer.fromJson<bool>(json['isLocalOnly']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'visitId': serializer.toJson<int>(visitId),
      'lineId': serializer.toJson<int>(lineId),
      'productId': serializer.toJson<int>(productId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<double>(quantity),
      'priceUnit': serializer.toJson<double>(priceUnit),
      'unit': serializer.toJson<String?>(unit),
      'isLocalOnly': serializer.toJson<bool>(isLocalOnly),
    };
  }

  VisitCartLine copyWith({
    int? visitId,
    int? lineId,
    int? productId,
    String? productName,
    double? quantity,
    double? priceUnit,
    Value<String?> unit = const Value.absent(),
    bool? isLocalOnly,
  }) => VisitCartLine(
    visitId: visitId ?? this.visitId,
    lineId: lineId ?? this.lineId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    priceUnit: priceUnit ?? this.priceUnit,
    unit: unit.present ? unit.value : this.unit,
    isLocalOnly: isLocalOnly ?? this.isLocalOnly,
  );
  VisitCartLine copyWithCompanion(VisitCartLinesCompanion data) {
    return VisitCartLine(
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      priceUnit: data.priceUnit.present ? data.priceUnit.value : this.priceUnit,
      unit: data.unit.present ? data.unit.value : this.unit,
      isLocalOnly: data.isLocalOnly.present
          ? data.isLocalOnly.value
          : this.isLocalOnly,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisitCartLine(')
          ..write('visitId: $visitId, ')
          ..write('lineId: $lineId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('priceUnit: $priceUnit, ')
          ..write('unit: $unit, ')
          ..write('isLocalOnly: $isLocalOnly')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    visitId,
    lineId,
    productId,
    productName,
    quantity,
    priceUnit,
    unit,
    isLocalOnly,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisitCartLine &&
          other.visitId == this.visitId &&
          other.lineId == this.lineId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.priceUnit == this.priceUnit &&
          other.unit == this.unit &&
          other.isLocalOnly == this.isLocalOnly);
}

class VisitCartLinesCompanion extends UpdateCompanion<VisitCartLine> {
  final Value<int> visitId;
  final Value<int> lineId;
  final Value<int> productId;
  final Value<String> productName;
  final Value<double> quantity;
  final Value<double> priceUnit;
  final Value<String?> unit;
  final Value<bool> isLocalOnly;
  final Value<int> rowid;
  const VisitCartLinesCompanion({
    this.visitId = const Value.absent(),
    this.lineId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceUnit = const Value.absent(),
    this.unit = const Value.absent(),
    this.isLocalOnly = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisitCartLinesCompanion.insert({
    required int visitId,
    required int lineId,
    required int productId,
    required String productName,
    required double quantity,
    required double priceUnit,
    this.unit = const Value.absent(),
    this.isLocalOnly = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : visitId = Value(visitId),
       lineId = Value(lineId),
       productId = Value(productId),
       productName = Value(productName),
       quantity = Value(quantity),
       priceUnit = Value(priceUnit);
  static Insertable<VisitCartLine> custom({
    Expression<int>? visitId,
    Expression<int>? lineId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<double>? quantity,
    Expression<double>? priceUnit,
    Expression<String>? unit,
    Expression<bool>? isLocalOnly,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (visitId != null) 'visit_id': visitId,
      if (lineId != null) 'line_id': lineId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (priceUnit != null) 'price_unit': priceUnit,
      if (unit != null) 'unit': unit,
      if (isLocalOnly != null) 'is_local_only': isLocalOnly,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisitCartLinesCompanion copyWith({
    Value<int>? visitId,
    Value<int>? lineId,
    Value<int>? productId,
    Value<String>? productName,
    Value<double>? quantity,
    Value<double>? priceUnit,
    Value<String?>? unit,
    Value<bool>? isLocalOnly,
    Value<int>? rowid,
  }) {
    return VisitCartLinesCompanion(
      visitId: visitId ?? this.visitId,
      lineId: lineId ?? this.lineId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      priceUnit: priceUnit ?? this.priceUnit,
      unit: unit ?? this.unit,
      isLocalOnly: isLocalOnly ?? this.isLocalOnly,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (visitId.present) {
      map['visit_id'] = Variable<int>(visitId.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<int>(lineId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (priceUnit.present) {
      map['price_unit'] = Variable<double>(priceUnit.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (isLocalOnly.present) {
      map['is_local_only'] = Variable<bool>(isLocalOnly.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitCartLinesCompanion(')
          ..write('visitId: $visitId, ')
          ..write('lineId: $lineId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('priceUnit: $priceUnit, ')
          ..write('unit: $unit, ')
          ..write('isLocalOnly: $isLocalOnly, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisitProductsTable extends VisitProducts
    with TableInfo<$VisitProductsTable, VisitProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<int> visitId = GeneratedColumn<int>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonPayloadMeta = const VerificationMeta(
    'jsonPayload',
  );
  @override
  late final GeneratedColumn<String> jsonPayload = GeneratedColumn<String>(
    'json_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [visitId, productId, jsonPayload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visit_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisitProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('json_payload')) {
      context.handle(
        _jsonPayloadMeta,
        jsonPayload.isAcceptableOrUnknown(
          data['json_payload']!,
          _jsonPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jsonPayloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {visitId, productId};
  @override
  VisitProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisitProduct(
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      jsonPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json_payload'],
      )!,
    );
  }

  @override
  $VisitProductsTable createAlias(String alias) {
    return $VisitProductsTable(attachedDatabase, alias);
  }
}

class VisitProduct extends DataClass implements Insertable<VisitProduct> {
  final int visitId;
  final int productId;
  final String jsonPayload;
  const VisitProduct({
    required this.visitId,
    required this.productId,
    required this.jsonPayload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['visit_id'] = Variable<int>(visitId);
    map['product_id'] = Variable<int>(productId);
    map['json_payload'] = Variable<String>(jsonPayload);
    return map;
  }

  VisitProductsCompanion toCompanion(bool nullToAbsent) {
    return VisitProductsCompanion(
      visitId: Value(visitId),
      productId: Value(productId),
      jsonPayload: Value(jsonPayload),
    );
  }

  factory VisitProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisitProduct(
      visitId: serializer.fromJson<int>(json['visitId']),
      productId: serializer.fromJson<int>(json['productId']),
      jsonPayload: serializer.fromJson<String>(json['jsonPayload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'visitId': serializer.toJson<int>(visitId),
      'productId': serializer.toJson<int>(productId),
      'jsonPayload': serializer.toJson<String>(jsonPayload),
    };
  }

  VisitProduct copyWith({int? visitId, int? productId, String? jsonPayload}) =>
      VisitProduct(
        visitId: visitId ?? this.visitId,
        productId: productId ?? this.productId,
        jsonPayload: jsonPayload ?? this.jsonPayload,
      );
  VisitProduct copyWithCompanion(VisitProductsCompanion data) {
    return VisitProduct(
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      productId: data.productId.present ? data.productId.value : this.productId,
      jsonPayload: data.jsonPayload.present
          ? data.jsonPayload.value
          : this.jsonPayload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisitProduct(')
          ..write('visitId: $visitId, ')
          ..write('productId: $productId, ')
          ..write('jsonPayload: $jsonPayload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(visitId, productId, jsonPayload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisitProduct &&
          other.visitId == this.visitId &&
          other.productId == this.productId &&
          other.jsonPayload == this.jsonPayload);
}

class VisitProductsCompanion extends UpdateCompanion<VisitProduct> {
  final Value<int> visitId;
  final Value<int> productId;
  final Value<String> jsonPayload;
  final Value<int> rowid;
  const VisitProductsCompanion({
    this.visitId = const Value.absent(),
    this.productId = const Value.absent(),
    this.jsonPayload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisitProductsCompanion.insert({
    required int visitId,
    required int productId,
    required String jsonPayload,
    this.rowid = const Value.absent(),
  }) : visitId = Value(visitId),
       productId = Value(productId),
       jsonPayload = Value(jsonPayload);
  static Insertable<VisitProduct> custom({
    Expression<int>? visitId,
    Expression<int>? productId,
    Expression<String>? jsonPayload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (visitId != null) 'visit_id': visitId,
      if (productId != null) 'product_id': productId,
      if (jsonPayload != null) 'json_payload': jsonPayload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisitProductsCompanion copyWith({
    Value<int>? visitId,
    Value<int>? productId,
    Value<String>? jsonPayload,
    Value<int>? rowid,
  }) {
    return VisitProductsCompanion(
      visitId: visitId ?? this.visitId,
      productId: productId ?? this.productId,
      jsonPayload: jsonPayload ?? this.jsonPayload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (visitId.present) {
      map['visit_id'] = Variable<int>(visitId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (jsonPayload.present) {
      map['json_payload'] = Variable<String>(jsonPayload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitProductsCompanion(')
          ..write('visitId: $visitId, ')
          ..write('productId: $productId, ')
          ..write('jsonPayload: $jsonPayload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisitOrderLinesTable extends VisitOrderLines
    with TableInfo<$VisitOrderLinesTable, VisitOrderLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitOrderLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<int> visitId = GeneratedColumn<int>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<int> lineId = GeneratedColumn<int>(
    'line_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceUnitMeta = const VerificationMeta(
    'priceUnit',
  );
  @override
  late final GeneratedColumn<double> priceUnit = GeneratedColumn<double>(
    'price_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    visitId,
    lineId,
    productId,
    productName,
    quantity,
    priceUnit,
    unit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visit_order_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisitOrderLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('line_id')) {
      context.handle(
        _lineIdMeta,
        lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lineIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price_unit')) {
      context.handle(
        _priceUnitMeta,
        priceUnit.isAcceptableOrUnknown(data['price_unit']!, _priceUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_priceUnitMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {visitId, lineId};
  @override
  VisitOrderLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisitOrderLine(
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visit_id'],
      )!,
      lineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      priceUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_unit'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
    );
  }

  @override
  $VisitOrderLinesTable createAlias(String alias) {
    return $VisitOrderLinesTable(attachedDatabase, alias);
  }
}

class VisitOrderLine extends DataClass implements Insertable<VisitOrderLine> {
  final int visitId;
  final int lineId;
  final int productId;
  final String productName;
  final double quantity;
  final double priceUnit;
  final String? unit;
  const VisitOrderLine({
    required this.visitId,
    required this.lineId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceUnit,
    this.unit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['visit_id'] = Variable<int>(visitId);
    map['line_id'] = Variable<int>(lineId);
    map['product_id'] = Variable<int>(productId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<double>(quantity);
    map['price_unit'] = Variable<double>(priceUnit);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    return map;
  }

  VisitOrderLinesCompanion toCompanion(bool nullToAbsent) {
    return VisitOrderLinesCompanion(
      visitId: Value(visitId),
      lineId: Value(lineId),
      productId: Value(productId),
      productName: Value(productName),
      quantity: Value(quantity),
      priceUnit: Value(priceUnit),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
    );
  }

  factory VisitOrderLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisitOrderLine(
      visitId: serializer.fromJson<int>(json['visitId']),
      lineId: serializer.fromJson<int>(json['lineId']),
      productId: serializer.fromJson<int>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      priceUnit: serializer.fromJson<double>(json['priceUnit']),
      unit: serializer.fromJson<String?>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'visitId': serializer.toJson<int>(visitId),
      'lineId': serializer.toJson<int>(lineId),
      'productId': serializer.toJson<int>(productId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<double>(quantity),
      'priceUnit': serializer.toJson<double>(priceUnit),
      'unit': serializer.toJson<String?>(unit),
    };
  }

  VisitOrderLine copyWith({
    int? visitId,
    int? lineId,
    int? productId,
    String? productName,
    double? quantity,
    double? priceUnit,
    Value<String?> unit = const Value.absent(),
  }) => VisitOrderLine(
    visitId: visitId ?? this.visitId,
    lineId: lineId ?? this.lineId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    priceUnit: priceUnit ?? this.priceUnit,
    unit: unit.present ? unit.value : this.unit,
  );
  VisitOrderLine copyWithCompanion(VisitOrderLinesCompanion data) {
    return VisitOrderLine(
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      priceUnit: data.priceUnit.present ? data.priceUnit.value : this.priceUnit,
      unit: data.unit.present ? data.unit.value : this.unit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisitOrderLine(')
          ..write('visitId: $visitId, ')
          ..write('lineId: $lineId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('priceUnit: $priceUnit, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    visitId,
    lineId,
    productId,
    productName,
    quantity,
    priceUnit,
    unit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisitOrderLine &&
          other.visitId == this.visitId &&
          other.lineId == this.lineId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.priceUnit == this.priceUnit &&
          other.unit == this.unit);
}

class VisitOrderLinesCompanion extends UpdateCompanion<VisitOrderLine> {
  final Value<int> visitId;
  final Value<int> lineId;
  final Value<int> productId;
  final Value<String> productName;
  final Value<double> quantity;
  final Value<double> priceUnit;
  final Value<String?> unit;
  final Value<int> rowid;
  const VisitOrderLinesCompanion({
    this.visitId = const Value.absent(),
    this.lineId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceUnit = const Value.absent(),
    this.unit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisitOrderLinesCompanion.insert({
    required int visitId,
    required int lineId,
    required int productId,
    required String productName,
    required double quantity,
    required double priceUnit,
    this.unit = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : visitId = Value(visitId),
       lineId = Value(lineId),
       productId = Value(productId),
       productName = Value(productName),
       quantity = Value(quantity),
       priceUnit = Value(priceUnit);
  static Insertable<VisitOrderLine> custom({
    Expression<int>? visitId,
    Expression<int>? lineId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<double>? quantity,
    Expression<double>? priceUnit,
    Expression<String>? unit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (visitId != null) 'visit_id': visitId,
      if (lineId != null) 'line_id': lineId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (priceUnit != null) 'price_unit': priceUnit,
      if (unit != null) 'unit': unit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisitOrderLinesCompanion copyWith({
    Value<int>? visitId,
    Value<int>? lineId,
    Value<int>? productId,
    Value<String>? productName,
    Value<double>? quantity,
    Value<double>? priceUnit,
    Value<String?>? unit,
    Value<int>? rowid,
  }) {
    return VisitOrderLinesCompanion(
      visitId: visitId ?? this.visitId,
      lineId: lineId ?? this.lineId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      priceUnit: priceUnit ?? this.priceUnit,
      unit: unit ?? this.unit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (visitId.present) {
      map['visit_id'] = Variable<int>(visitId.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<int>(lineId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (priceUnit.present) {
      map['price_unit'] = Variable<double>(priceUnit.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitOrderLinesCompanion(')
          ..write('visitId: $visitId, ')
          ..write('lineId: $lineId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('priceUnit: $priceUnit, ')
          ..write('unit: $unit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdMappingsTable extends IdMappings
    with TableInfo<$IdMappingsTable, IdMapping> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    entityType,
    localId,
    serverId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'id_mappings';
  @override
  VerificationContext validateIntegrity(
    Insertable<IdMapping> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityType, localId};
  @override
  IdMapping map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IdMapping(
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $IdMappingsTable createAlias(String alias) {
    return $IdMappingsTable(attachedDatabase, alias);
  }
}

class IdMapping extends DataClass implements Insertable<IdMapping> {
  final String entityType;
  final int localId;
  final int serverId;
  final DateTime createdAt;
  const IdMapping({
    required this.entityType,
    required this.localId,
    required this.serverId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['local_id'] = Variable<int>(localId);
    map['server_id'] = Variable<int>(serverId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IdMappingsCompanion toCompanion(bool nullToAbsent) {
    return IdMappingsCompanion(
      entityType: Value(entityType),
      localId: Value(localId),
      serverId: Value(serverId),
      createdAt: Value(createdAt),
    );
  }

  factory IdMapping.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IdMapping(
      entityType: serializer.fromJson<String>(json['entityType']),
      localId: serializer.fromJson<int>(json['localId']),
      serverId: serializer.fromJson<int>(json['serverId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'localId': serializer.toJson<int>(localId),
      'serverId': serializer.toJson<int>(serverId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  IdMapping copyWith({
    String? entityType,
    int? localId,
    int? serverId,
    DateTime? createdAt,
  }) => IdMapping(
    entityType: entityType ?? this.entityType,
    localId: localId ?? this.localId,
    serverId: serverId ?? this.serverId,
    createdAt: createdAt ?? this.createdAt,
  );
  IdMapping copyWithCompanion(IdMappingsCompanion data) {
    return IdMapping(
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IdMapping(')
          ..write('entityType: $entityType, ')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityType, localId, serverId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IdMapping &&
          other.entityType == this.entityType &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.createdAt == this.createdAt);
}

class IdMappingsCompanion extends UpdateCompanion<IdMapping> {
  final Value<String> entityType;
  final Value<int> localId;
  final Value<int> serverId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const IdMappingsCompanion({
    this.entityType = const Value.absent(),
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdMappingsCompanion.insert({
    required String entityType,
    required int localId,
    required int serverId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : entityType = Value(entityType),
       localId = Value(localId),
       serverId = Value(serverId),
       createdAt = Value(createdAt);
  static Insertable<IdMapping> custom({
    Expression<String>? entityType,
    Expression<int>? localId,
    Expression<int>? serverId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdMappingsCompanion copyWith({
    Value<String>? entityType,
    Value<int>? localId,
    Value<int>? serverId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return IdMappingsCompanion(
      entityType: entityType ?? this.entityType,
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdMappingsCompanion(')
          ..write('entityType: $entityType, ')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalVisitsTable extends LocalVisits
    with TableInfo<$LocalVisitsTable, LocalVisit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVisitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localVisitIdMeta = const VerificationMeta(
    'localVisitId',
  );
  @override
  late final GeneratedColumn<int> localVisitId = GeneratedColumn<int>(
    'local_visit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverVisitIdMeta = const VerificationMeta(
    'serverVisitId',
  );
  @override
  late final GeneratedColumn<int> serverVisitId = GeneratedColumn<int>(
    'server_visit_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
    'shop_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopNameMeta = const VerificationMeta(
    'shopName',
  );
  @override
  late final GeneratedColumn<String> shopName = GeneratedColumn<String>(
    'shop_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkedInAtMeta = const VerificationMeta(
    'checkedInAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedInAt = GeneratedColumn<DateTime>(
    'checked_in_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('check_in'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderNumberMeta = const VerificationMeta(
    'orderNumber',
  );
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
    'order_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pendingSyncMeta = const VerificationMeta(
    'pendingSync',
  );
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
    'pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _approvalStateMeta = const VerificationMeta(
    'approvalState',
  );
  @override
  late final GeneratedColumn<String> approvalState = GeneratedColumn<String>(
    'approval_state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localVisitId,
    serverVisitId,
    taskId,
    shopId,
    shopName,
    latitude,
    longitude,
    checkedInAt,
    kind,
    status,
    outcome,
    notes,
    orderNumber,
    subtotal,
    pendingSync,
    approvalState,
    userId,
    createdAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_visits';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVisit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_visit_id')) {
      context.handle(
        _localVisitIdMeta,
        localVisitId.isAcceptableOrUnknown(
          data['local_visit_id']!,
          _localVisitIdMeta,
        ),
      );
    }
    if (data.containsKey('server_visit_id')) {
      context.handle(
        _serverVisitIdMeta,
        serverVisitId.isAcceptableOrUnknown(
          data['server_visit_id']!,
          _serverVisitIdMeta,
        ),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('shop_id')) {
      context.handle(
        _shopIdMeta,
        shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shopIdMeta);
    }
    if (data.containsKey('shop_name')) {
      context.handle(
        _shopNameMeta,
        shopName.isAcceptableOrUnknown(data['shop_name']!, _shopNameMeta),
      );
    } else if (isInserting) {
      context.missing(_shopNameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('checked_in_at')) {
      context.handle(
        _checkedInAtMeta,
        checkedInAt.isAcceptableOrUnknown(
          data['checked_in_at']!,
          _checkedInAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkedInAtMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('order_number')) {
      context.handle(
        _orderNumberMeta,
        orderNumber.isAcceptableOrUnknown(
          data['order_number']!,
          _orderNumberMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
        _pendingSyncMeta,
        pendingSync.isAcceptableOrUnknown(
          data['pending_sync']!,
          _pendingSyncMeta,
        ),
      );
    }
    if (data.containsKey('approval_state')) {
      context.handle(
        _approvalStateMeta,
        approvalState.isAcceptableOrUnknown(
          data['approval_state']!,
          _approvalStateMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localVisitId};
  @override
  LocalVisit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVisit(
      localVisitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_visit_id'],
      )!,
      serverVisitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_visit_id'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      shopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_id'],
      )!,
      shopName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_name'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      checkedInAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_in_at'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      orderNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_number'],
      ),
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      ),
      pendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_sync'],
      )!,
      approvalState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approval_state'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $LocalVisitsTable createAlias(String alias) {
    return $LocalVisitsTable(attachedDatabase, alias);
  }
}

class LocalVisit extends DataClass implements Insertable<LocalVisit> {
  final int localVisitId;
  final int? serverVisitId;
  final int taskId;
  final String shopId;
  final String shopName;
  final double latitude;
  final double longitude;
  final DateTime checkedInAt;

  /// `check_in` or `verify_then_check_in`.
  final String kind;

  /// `active` or `completed`.
  final String status;

  /// `order_placed` or `ended_without_order`.
  final String? outcome;
  final String? notes;
  final String? orderNumber;
  final double? subtotal;

  /// True while place-order / end-visit is still waiting to sync.
  final bool pendingSync;
  final String? approvalState;
  final String? userId;
  final DateTime createdAt;
  final DateTime? completedAt;
  const LocalVisit({
    required this.localVisitId,
    this.serverVisitId,
    required this.taskId,
    required this.shopId,
    required this.shopName,
    required this.latitude,
    required this.longitude,
    required this.checkedInAt,
    required this.kind,
    required this.status,
    this.outcome,
    this.notes,
    this.orderNumber,
    this.subtotal,
    required this.pendingSync,
    this.approvalState,
    this.userId,
    required this.createdAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_visit_id'] = Variable<int>(localVisitId);
    if (!nullToAbsent || serverVisitId != null) {
      map['server_visit_id'] = Variable<int>(serverVisitId);
    }
    map['task_id'] = Variable<int>(taskId);
    map['shop_id'] = Variable<String>(shopId);
    map['shop_name'] = Variable<String>(shopName);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['checked_in_at'] = Variable<DateTime>(checkedInAt);
    map['kind'] = Variable<String>(kind);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || outcome != null) {
      map['outcome'] = Variable<String>(outcome);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || orderNumber != null) {
      map['order_number'] = Variable<String>(orderNumber);
    }
    if (!nullToAbsent || subtotal != null) {
      map['subtotal'] = Variable<double>(subtotal);
    }
    map['pending_sync'] = Variable<bool>(pendingSync);
    if (!nullToAbsent || approvalState != null) {
      map['approval_state'] = Variable<String>(approvalState);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  LocalVisitsCompanion toCompanion(bool nullToAbsent) {
    return LocalVisitsCompanion(
      localVisitId: Value(localVisitId),
      serverVisitId: serverVisitId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVisitId),
      taskId: Value(taskId),
      shopId: Value(shopId),
      shopName: Value(shopName),
      latitude: Value(latitude),
      longitude: Value(longitude),
      checkedInAt: Value(checkedInAt),
      kind: Value(kind),
      status: Value(status),
      outcome: outcome == null && nullToAbsent
          ? const Value.absent()
          : Value(outcome),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      orderNumber: orderNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(orderNumber),
      subtotal: subtotal == null && nullToAbsent
          ? const Value.absent()
          : Value(subtotal),
      pendingSync: Value(pendingSync),
      approvalState: approvalState == null && nullToAbsent
          ? const Value.absent()
          : Value(approvalState),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory LocalVisit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVisit(
      localVisitId: serializer.fromJson<int>(json['localVisitId']),
      serverVisitId: serializer.fromJson<int?>(json['serverVisitId']),
      taskId: serializer.fromJson<int>(json['taskId']),
      shopId: serializer.fromJson<String>(json['shopId']),
      shopName: serializer.fromJson<String>(json['shopName']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      checkedInAt: serializer.fromJson<DateTime>(json['checkedInAt']),
      kind: serializer.fromJson<String>(json['kind']),
      status: serializer.fromJson<String>(json['status']),
      outcome: serializer.fromJson<String?>(json['outcome']),
      notes: serializer.fromJson<String?>(json['notes']),
      orderNumber: serializer.fromJson<String?>(json['orderNumber']),
      subtotal: serializer.fromJson<double?>(json['subtotal']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
      approvalState: serializer.fromJson<String?>(json['approvalState']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localVisitId': serializer.toJson<int>(localVisitId),
      'serverVisitId': serializer.toJson<int?>(serverVisitId),
      'taskId': serializer.toJson<int>(taskId),
      'shopId': serializer.toJson<String>(shopId),
      'shopName': serializer.toJson<String>(shopName),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'checkedInAt': serializer.toJson<DateTime>(checkedInAt),
      'kind': serializer.toJson<String>(kind),
      'status': serializer.toJson<String>(status),
      'outcome': serializer.toJson<String?>(outcome),
      'notes': serializer.toJson<String?>(notes),
      'orderNumber': serializer.toJson<String?>(orderNumber),
      'subtotal': serializer.toJson<double?>(subtotal),
      'pendingSync': serializer.toJson<bool>(pendingSync),
      'approvalState': serializer.toJson<String?>(approvalState),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  LocalVisit copyWith({
    int? localVisitId,
    Value<int?> serverVisitId = const Value.absent(),
    int? taskId,
    String? shopId,
    String? shopName,
    double? latitude,
    double? longitude,
    DateTime? checkedInAt,
    String? kind,
    String? status,
    Value<String?> outcome = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> orderNumber = const Value.absent(),
    Value<double?> subtotal = const Value.absent(),
    bool? pendingSync,
    Value<String?> approvalState = const Value.absent(),
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => LocalVisit(
    localVisitId: localVisitId ?? this.localVisitId,
    serverVisitId: serverVisitId.present
        ? serverVisitId.value
        : this.serverVisitId,
    taskId: taskId ?? this.taskId,
    shopId: shopId ?? this.shopId,
    shopName: shopName ?? this.shopName,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    checkedInAt: checkedInAt ?? this.checkedInAt,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    outcome: outcome.present ? outcome.value : this.outcome,
    notes: notes.present ? notes.value : this.notes,
    orderNumber: orderNumber.present ? orderNumber.value : this.orderNumber,
    subtotal: subtotal.present ? subtotal.value : this.subtotal,
    pendingSync: pendingSync ?? this.pendingSync,
    approvalState: approvalState.present
        ? approvalState.value
        : this.approvalState,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  LocalVisit copyWithCompanion(LocalVisitsCompanion data) {
    return LocalVisit(
      localVisitId: data.localVisitId.present
          ? data.localVisitId.value
          : this.localVisitId,
      serverVisitId: data.serverVisitId.present
          ? data.serverVisitId.value
          : this.serverVisitId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      shopName: data.shopName.present ? data.shopName.value : this.shopName,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      checkedInAt: data.checkedInAt.present
          ? data.checkedInAt.value
          : this.checkedInAt,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      notes: data.notes.present ? data.notes.value : this.notes,
      orderNumber: data.orderNumber.present
          ? data.orderNumber.value
          : this.orderNumber,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      pendingSync: data.pendingSync.present
          ? data.pendingSync.value
          : this.pendingSync,
      approvalState: data.approvalState.present
          ? data.approvalState.value
          : this.approvalState,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisit(')
          ..write('localVisitId: $localVisitId, ')
          ..write('serverVisitId: $serverVisitId, ')
          ..write('taskId: $taskId, ')
          ..write('shopId: $shopId, ')
          ..write('shopName: $shopName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('checkedInAt: $checkedInAt, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('outcome: $outcome, ')
          ..write('notes: $notes, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('subtotal: $subtotal, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('approvalState: $approvalState, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localVisitId,
    serverVisitId,
    taskId,
    shopId,
    shopName,
    latitude,
    longitude,
    checkedInAt,
    kind,
    status,
    outcome,
    notes,
    orderNumber,
    subtotal,
    pendingSync,
    approvalState,
    userId,
    createdAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVisit &&
          other.localVisitId == this.localVisitId &&
          other.serverVisitId == this.serverVisitId &&
          other.taskId == this.taskId &&
          other.shopId == this.shopId &&
          other.shopName == this.shopName &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.checkedInAt == this.checkedInAt &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.outcome == this.outcome &&
          other.notes == this.notes &&
          other.orderNumber == this.orderNumber &&
          other.subtotal == this.subtotal &&
          other.pendingSync == this.pendingSync &&
          other.approvalState == this.approvalState &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class LocalVisitsCompanion extends UpdateCompanion<LocalVisit> {
  final Value<int> localVisitId;
  final Value<int?> serverVisitId;
  final Value<int> taskId;
  final Value<String> shopId;
  final Value<String> shopName;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> checkedInAt;
  final Value<String> kind;
  final Value<String> status;
  final Value<String?> outcome;
  final Value<String?> notes;
  final Value<String?> orderNumber;
  final Value<double?> subtotal;
  final Value<bool> pendingSync;
  final Value<String?> approvalState;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  const LocalVisitsCompanion({
    this.localVisitId = const Value.absent(),
    this.serverVisitId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.shopId = const Value.absent(),
    this.shopName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.checkedInAt = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.outcome = const Value.absent(),
    this.notes = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.approvalState = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  LocalVisitsCompanion.insert({
    this.localVisitId = const Value.absent(),
    this.serverVisitId = const Value.absent(),
    required int taskId,
    required String shopId,
    required String shopName,
    required double latitude,
    required double longitude,
    required DateTime checkedInAt,
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.outcome = const Value.absent(),
    this.notes = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.approvalState = const Value.absent(),
    this.userId = const Value.absent(),
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
  }) : taskId = Value(taskId),
       shopId = Value(shopId),
       shopName = Value(shopName),
       latitude = Value(latitude),
       longitude = Value(longitude),
       checkedInAt = Value(checkedInAt),
       createdAt = Value(createdAt);
  static Insertable<LocalVisit> custom({
    Expression<int>? localVisitId,
    Expression<int>? serverVisitId,
    Expression<int>? taskId,
    Expression<String>? shopId,
    Expression<String>? shopName,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? checkedInAt,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<String>? outcome,
    Expression<String>? notes,
    Expression<String>? orderNumber,
    Expression<double>? subtotal,
    Expression<bool>? pendingSync,
    Expression<String>? approvalState,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (localVisitId != null) 'local_visit_id': localVisitId,
      if (serverVisitId != null) 'server_visit_id': serverVisitId,
      if (taskId != null) 'task_id': taskId,
      if (shopId != null) 'shop_id': shopId,
      if (shopName != null) 'shop_name': shopName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (checkedInAt != null) 'checked_in_at': checkedInAt,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (outcome != null) 'outcome': outcome,
      if (notes != null) 'notes': notes,
      if (orderNumber != null) 'order_number': orderNumber,
      if (subtotal != null) 'subtotal': subtotal,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (approvalState != null) 'approval_state': approvalState,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  LocalVisitsCompanion copyWith({
    Value<int>? localVisitId,
    Value<int?>? serverVisitId,
    Value<int>? taskId,
    Value<String>? shopId,
    Value<String>? shopName,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<DateTime>? checkedInAt,
    Value<String>? kind,
    Value<String>? status,
    Value<String?>? outcome,
    Value<String?>? notes,
    Value<String?>? orderNumber,
    Value<double?>? subtotal,
    Value<bool>? pendingSync,
    Value<String?>? approvalState,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
  }) {
    return LocalVisitsCompanion(
      localVisitId: localVisitId ?? this.localVisitId,
      serverVisitId: serverVisitId ?? this.serverVisitId,
      taskId: taskId ?? this.taskId,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      outcome: outcome ?? this.outcome,
      notes: notes ?? this.notes,
      orderNumber: orderNumber ?? this.orderNumber,
      subtotal: subtotal ?? this.subtotal,
      pendingSync: pendingSync ?? this.pendingSync,
      approvalState: approvalState ?? this.approvalState,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localVisitId.present) {
      map['local_visit_id'] = Variable<int>(localVisitId.value);
    }
    if (serverVisitId.present) {
      map['server_visit_id'] = Variable<int>(serverVisitId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (shopName.present) {
      map['shop_name'] = Variable<String>(shopName.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (checkedInAt.present) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    if (approvalState.present) {
      map['approval_state'] = Variable<String>(approvalState.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisitsCompanion(')
          ..write('localVisitId: $localVisitId, ')
          ..write('serverVisitId: $serverVisitId, ')
          ..write('taskId: $taskId, ')
          ..write('shopId: $shopId, ')
          ..write('shopName: $shopName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('checkedInAt: $checkedInAt, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('outcome: $outcome, ')
          ..write('notes: $notes, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('subtotal: $subtotal, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('approvalState: $approvalState, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $LocalShopsTable extends LocalShops
    with TableInfo<$LocalShopsTable, LocalShop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalShopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localShopIdMeta = const VerificationMeta(
    'localShopId',
  );
  @override
  late final GeneratedColumn<int> localShopId = GeneratedColumn<int>(
    'local_shop_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverShopIdMeta = const VerificationMeta(
    'serverShopId',
  );
  @override
  late final GeneratedColumn<int> serverShopId = GeneratedColumn<int>(
    'server_shop_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerNameMeta = const VerificationMeta(
    'ownerName',
  );
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
    'owner_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerPhoneMeta = const VerificationMeta(
    'ownerPhone',
  );
  @override
  late final GeneratedColumn<String> ownerPhone = GeneratedColumn<String>(
    'owner_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerCnicMeta = const VerificationMeta(
    'ownerCnic',
  );
  @override
  late final GeneratedColumn<String> ownerCnic = GeneratedColumn<String>(
    'owner_cnic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shopCategoryMeta = const VerificationMeta(
    'shopCategory',
  );
  @override
  late final GeneratedColumn<String> shopCategory = GeneratedColumn<String>(
    'shop_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localShopId,
    serverShopId,
    name,
    ownerName,
    ownerPhone,
    ownerCnic,
    latitude,
    longitude,
    shopCategory,
    payloadJson,
    status,
    userId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_shops';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalShop> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_shop_id')) {
      context.handle(
        _localShopIdMeta,
        localShopId.isAcceptableOrUnknown(
          data['local_shop_id']!,
          _localShopIdMeta,
        ),
      );
    }
    if (data.containsKey('server_shop_id')) {
      context.handle(
        _serverShopIdMeta,
        serverShopId.isAcceptableOrUnknown(
          data['server_shop_id']!,
          _serverShopIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('owner_name')) {
      context.handle(
        _ownerNameMeta,
        ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta),
      );
    }
    if (data.containsKey('owner_phone')) {
      context.handle(
        _ownerPhoneMeta,
        ownerPhone.isAcceptableOrUnknown(data['owner_phone']!, _ownerPhoneMeta),
      );
    }
    if (data.containsKey('owner_cnic')) {
      context.handle(
        _ownerCnicMeta,
        ownerCnic.isAcceptableOrUnknown(data['owner_cnic']!, _ownerCnicMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('shop_category')) {
      context.handle(
        _shopCategoryMeta,
        shopCategory.isAcceptableOrUnknown(
          data['shop_category']!,
          _shopCategoryMeta,
        ),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localShopId};
  @override
  LocalShop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalShop(
      localShopId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_shop_id'],
      )!,
      serverShopId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_shop_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ownerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_name'],
      ),
      ownerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_phone'],
      ),
      ownerCnic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_cnic'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      shopCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_category'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalShopsTable createAlias(String alias) {
    return $LocalShopsTable(attachedDatabase, alias);
  }
}

class LocalShop extends DataClass implements Insertable<LocalShop> {
  final int localShopId;
  final int? serverShopId;
  final String name;
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerCnic;
  final double? latitude;
  final double? longitude;
  final String? shopCategory;
  final String payloadJson;
  final String status;
  final String? userId;
  final DateTime createdAt;
  const LocalShop({
    required this.localShopId,
    this.serverShopId,
    required this.name,
    this.ownerName,
    this.ownerPhone,
    this.ownerCnic,
    this.latitude,
    this.longitude,
    this.shopCategory,
    required this.payloadJson,
    required this.status,
    this.userId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_shop_id'] = Variable<int>(localShopId);
    if (!nullToAbsent || serverShopId != null) {
      map['server_shop_id'] = Variable<int>(serverShopId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || ownerName != null) {
      map['owner_name'] = Variable<String>(ownerName);
    }
    if (!nullToAbsent || ownerPhone != null) {
      map['owner_phone'] = Variable<String>(ownerPhone);
    }
    if (!nullToAbsent || ownerCnic != null) {
      map['owner_cnic'] = Variable<String>(ownerCnic);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || shopCategory != null) {
      map['shop_category'] = Variable<String>(shopCategory);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalShopsCompanion toCompanion(bool nullToAbsent) {
    return LocalShopsCompanion(
      localShopId: Value(localShopId),
      serverShopId: serverShopId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverShopId),
      name: Value(name),
      ownerName: ownerName == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerName),
      ownerPhone: ownerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerPhone),
      ownerCnic: ownerCnic == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerCnic),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      shopCategory: shopCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(shopCategory),
      payloadJson: Value(payloadJson),
      status: Value(status),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
    );
  }

  factory LocalShop.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalShop(
      localShopId: serializer.fromJson<int>(json['localShopId']),
      serverShopId: serializer.fromJson<int?>(json['serverShopId']),
      name: serializer.fromJson<String>(json['name']),
      ownerName: serializer.fromJson<String?>(json['ownerName']),
      ownerPhone: serializer.fromJson<String?>(json['ownerPhone']),
      ownerCnic: serializer.fromJson<String?>(json['ownerCnic']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      shopCategory: serializer.fromJson<String?>(json['shopCategory']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localShopId': serializer.toJson<int>(localShopId),
      'serverShopId': serializer.toJson<int?>(serverShopId),
      'name': serializer.toJson<String>(name),
      'ownerName': serializer.toJson<String?>(ownerName),
      'ownerPhone': serializer.toJson<String?>(ownerPhone),
      'ownerCnic': serializer.toJson<String?>(ownerCnic),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'shopCategory': serializer.toJson<String?>(shopCategory),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalShop copyWith({
    int? localShopId,
    Value<int?> serverShopId = const Value.absent(),
    String? name,
    Value<String?> ownerName = const Value.absent(),
    Value<String?> ownerPhone = const Value.absent(),
    Value<String?> ownerCnic = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> shopCategory = const Value.absent(),
    String? payloadJson,
    String? status,
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
  }) => LocalShop(
    localShopId: localShopId ?? this.localShopId,
    serverShopId: serverShopId.present ? serverShopId.value : this.serverShopId,
    name: name ?? this.name,
    ownerName: ownerName.present ? ownerName.value : this.ownerName,
    ownerPhone: ownerPhone.present ? ownerPhone.value : this.ownerPhone,
    ownerCnic: ownerCnic.present ? ownerCnic.value : this.ownerCnic,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    shopCategory: shopCategory.present ? shopCategory.value : this.shopCategory,
    payloadJson: payloadJson ?? this.payloadJson,
    status: status ?? this.status,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalShop copyWithCompanion(LocalShopsCompanion data) {
    return LocalShop(
      localShopId: data.localShopId.present
          ? data.localShopId.value
          : this.localShopId,
      serverShopId: data.serverShopId.present
          ? data.serverShopId.value
          : this.serverShopId,
      name: data.name.present ? data.name.value : this.name,
      ownerName: data.ownerName.present ? data.ownerName.value : this.ownerName,
      ownerPhone: data.ownerPhone.present
          ? data.ownerPhone.value
          : this.ownerPhone,
      ownerCnic: data.ownerCnic.present ? data.ownerCnic.value : this.ownerCnic,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      shopCategory: data.shopCategory.present
          ? data.shopCategory.value
          : this.shopCategory,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalShop(')
          ..write('localShopId: $localShopId, ')
          ..write('serverShopId: $serverShopId, ')
          ..write('name: $name, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerPhone: $ownerPhone, ')
          ..write('ownerCnic: $ownerCnic, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('shopCategory: $shopCategory, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localShopId,
    serverShopId,
    name,
    ownerName,
    ownerPhone,
    ownerCnic,
    latitude,
    longitude,
    shopCategory,
    payloadJson,
    status,
    userId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalShop &&
          other.localShopId == this.localShopId &&
          other.serverShopId == this.serverShopId &&
          other.name == this.name &&
          other.ownerName == this.ownerName &&
          other.ownerPhone == this.ownerPhone &&
          other.ownerCnic == this.ownerCnic &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.shopCategory == this.shopCategory &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt);
}

class LocalShopsCompanion extends UpdateCompanion<LocalShop> {
  final Value<int> localShopId;
  final Value<int?> serverShopId;
  final Value<String> name;
  final Value<String?> ownerName;
  final Value<String?> ownerPhone;
  final Value<String?> ownerCnic;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> shopCategory;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  const LocalShopsCompanion({
    this.localShopId = const Value.absent(),
    this.serverShopId = const Value.absent(),
    this.name = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.ownerPhone = const Value.absent(),
    this.ownerCnic = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.shopCategory = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LocalShopsCompanion.insert({
    this.localShopId = const Value.absent(),
    this.serverShopId = const Value.absent(),
    required String name,
    this.ownerName = const Value.absent(),
    this.ownerPhone = const Value.absent(),
    this.ownerCnic = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.shopCategory = const Value.absent(),
    required String payloadJson,
    this.status = const Value.absent(),
    this.userId = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<LocalShop> custom({
    Expression<int>? localShopId,
    Expression<int>? serverShopId,
    Expression<String>? name,
    Expression<String>? ownerName,
    Expression<String>? ownerPhone,
    Expression<String>? ownerCnic,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? shopCategory,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (localShopId != null) 'local_shop_id': localShopId,
      if (serverShopId != null) 'server_shop_id': serverShopId,
      if (name != null) 'name': name,
      if (ownerName != null) 'owner_name': ownerName,
      if (ownerPhone != null) 'owner_phone': ownerPhone,
      if (ownerCnic != null) 'owner_cnic': ownerCnic,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (shopCategory != null) 'shop_category': shopCategory,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LocalShopsCompanion copyWith({
    Value<int>? localShopId,
    Value<int?>? serverShopId,
    Value<String>? name,
    Value<String?>? ownerName,
    Value<String?>? ownerPhone,
    Value<String?>? ownerCnic,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? shopCategory,
    Value<String>? payloadJson,
    Value<String>? status,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
  }) {
    return LocalShopsCompanion(
      localShopId: localShopId ?? this.localShopId,
      serverShopId: serverShopId ?? this.serverShopId,
      name: name ?? this.name,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerCnic: ownerCnic ?? this.ownerCnic,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      shopCategory: shopCategory ?? this.shopCategory,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localShopId.present) {
      map['local_shop_id'] = Variable<int>(localShopId.value);
    }
    if (serverShopId.present) {
      map['server_shop_id'] = Variable<int>(serverShopId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (ownerPhone.present) {
      map['owner_phone'] = Variable<String>(ownerPhone.value);
    }
    if (ownerCnic.present) {
      map['owner_cnic'] = Variable<String>(ownerCnic.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (shopCategory.present) {
      map['shop_category'] = Variable<String>(shopCategory.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalShopsCompanion(')
          ..write('localShopId: $localShopId, ')
          ..write('serverShopId: $serverShopId, ')
          ..write('name: $name, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerPhone: $ownerPhone, ')
          ..write('ownerCnic: $ownerCnic, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('shopCategory: $shopCategory, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LocalTaskOverridesTable extends LocalTaskOverrides
    with TableInfo<$LocalTaskOverridesTable, LocalTaskOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTaskOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visitTagMeta = const VerificationMeta(
    'visitTag',
  );
  @override
  late final GeneratedColumn<String> visitTag = GeneratedColumn<String>(
    'visit_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsShopSetupMeta = const VerificationMeta(
    'needsShopSetup',
  );
  @override
  late final GeneratedColumn<bool> needsShopSetup = GeneratedColumn<bool>(
    'needs_shop_setup',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_shop_setup" IN (0, 1))',
    ),
  );
  static const VerificationMeta _fieldVerifiedMeta = const VerificationMeta(
    'fieldVerified',
  );
  @override
  late final GeneratedColumn<bool> fieldVerified = GeneratedColumn<bool>(
    'field_verified',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("field_verified" IN (0, 1))',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    taskId,
    status,
    notes,
    visitTag,
    needsShopSetup,
    fieldVerified,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_task_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTaskOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('visit_tag')) {
      context.handle(
        _visitTagMeta,
        visitTag.isAcceptableOrUnknown(data['visit_tag']!, _visitTagMeta),
      );
    }
    if (data.containsKey('needs_shop_setup')) {
      context.handle(
        _needsShopSetupMeta,
        needsShopSetup.isAcceptableOrUnknown(
          data['needs_shop_setup']!,
          _needsShopSetupMeta,
        ),
      );
    }
    if (data.containsKey('field_verified')) {
      context.handle(
        _fieldVerifiedMeta,
        fieldVerified.isAcceptableOrUnknown(
          data['field_verified']!,
          _fieldVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  LocalTaskOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTaskOverride(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      visitTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_tag'],
      ),
      needsShopSetup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_shop_setup'],
      ),
      fieldVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}field_verified'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalTaskOverridesTable createAlias(String alias) {
    return $LocalTaskOverridesTable(attachedDatabase, alias);
  }
}

class LocalTaskOverride extends DataClass
    implements Insertable<LocalTaskOverride> {
  final int taskId;
  final String? status;
  final String? notes;
  final String? visitTag;
  final bool? needsShopSetup;
  final bool? fieldVerified;
  final DateTime updatedAt;
  const LocalTaskOverride({
    required this.taskId,
    this.status,
    this.notes,
    this.visitTag,
    this.needsShopSetup,
    this.fieldVerified,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<int>(taskId);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || visitTag != null) {
      map['visit_tag'] = Variable<String>(visitTag);
    }
    if (!nullToAbsent || needsShopSetup != null) {
      map['needs_shop_setup'] = Variable<bool>(needsShopSetup);
    }
    if (!nullToAbsent || fieldVerified != null) {
      map['field_verified'] = Variable<bool>(fieldVerified);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalTaskOverridesCompanion toCompanion(bool nullToAbsent) {
    return LocalTaskOverridesCompanion(
      taskId: Value(taskId),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      visitTag: visitTag == null && nullToAbsent
          ? const Value.absent()
          : Value(visitTag),
      needsShopSetup: needsShopSetup == null && nullToAbsent
          ? const Value.absent()
          : Value(needsShopSetup),
      fieldVerified: fieldVerified == null && nullToAbsent
          ? const Value.absent()
          : Value(fieldVerified),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalTaskOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTaskOverride(
      taskId: serializer.fromJson<int>(json['taskId']),
      status: serializer.fromJson<String?>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      visitTag: serializer.fromJson<String?>(json['visitTag']),
      needsShopSetup: serializer.fromJson<bool?>(json['needsShopSetup']),
      fieldVerified: serializer.fromJson<bool?>(json['fieldVerified']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<int>(taskId),
      'status': serializer.toJson<String?>(status),
      'notes': serializer.toJson<String?>(notes),
      'visitTag': serializer.toJson<String?>(visitTag),
      'needsShopSetup': serializer.toJson<bool?>(needsShopSetup),
      'fieldVerified': serializer.toJson<bool?>(fieldVerified),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalTaskOverride copyWith({
    int? taskId,
    Value<String?> status = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> visitTag = const Value.absent(),
    Value<bool?> needsShopSetup = const Value.absent(),
    Value<bool?> fieldVerified = const Value.absent(),
    DateTime? updatedAt,
  }) => LocalTaskOverride(
    taskId: taskId ?? this.taskId,
    status: status.present ? status.value : this.status,
    notes: notes.present ? notes.value : this.notes,
    visitTag: visitTag.present ? visitTag.value : this.visitTag,
    needsShopSetup: needsShopSetup.present
        ? needsShopSetup.value
        : this.needsShopSetup,
    fieldVerified: fieldVerified.present
        ? fieldVerified.value
        : this.fieldVerified,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalTaskOverride copyWithCompanion(LocalTaskOverridesCompanion data) {
    return LocalTaskOverride(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      visitTag: data.visitTag.present ? data.visitTag.value : this.visitTag,
      needsShopSetup: data.needsShopSetup.present
          ? data.needsShopSetup.value
          : this.needsShopSetup,
      fieldVerified: data.fieldVerified.present
          ? data.fieldVerified.value
          : this.fieldVerified,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTaskOverride(')
          ..write('taskId: $taskId, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('visitTag: $visitTag, ')
          ..write('needsShopSetup: $needsShopSetup, ')
          ..write('fieldVerified: $fieldVerified, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    taskId,
    status,
    notes,
    visitTag,
    needsShopSetup,
    fieldVerified,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTaskOverride &&
          other.taskId == this.taskId &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.visitTag == this.visitTag &&
          other.needsShopSetup == this.needsShopSetup &&
          other.fieldVerified == this.fieldVerified &&
          other.updatedAt == this.updatedAt);
}

class LocalTaskOverridesCompanion extends UpdateCompanion<LocalTaskOverride> {
  final Value<int> taskId;
  final Value<String?> status;
  final Value<String?> notes;
  final Value<String?> visitTag;
  final Value<bool?> needsShopSetup;
  final Value<bool?> fieldVerified;
  final Value<DateTime> updatedAt;
  const LocalTaskOverridesCompanion({
    this.taskId = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.visitTag = const Value.absent(),
    this.needsShopSetup = const Value.absent(),
    this.fieldVerified = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LocalTaskOverridesCompanion.insert({
    this.taskId = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.visitTag = const Value.absent(),
    this.needsShopSetup = const Value.absent(),
    this.fieldVerified = const Value.absent(),
    required DateTime updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<LocalTaskOverride> custom({
    Expression<int>? taskId,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? visitTag,
    Expression<bool>? needsShopSetup,
    Expression<bool>? fieldVerified,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (visitTag != null) 'visit_tag': visitTag,
      if (needsShopSetup != null) 'needs_shop_setup': needsShopSetup,
      if (fieldVerified != null) 'field_verified': fieldVerified,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LocalTaskOverridesCompanion copyWith({
    Value<int>? taskId,
    Value<String?>? status,
    Value<String?>? notes,
    Value<String?>? visitTag,
    Value<bool?>? needsShopSetup,
    Value<bool?>? fieldVerified,
    Value<DateTime>? updatedAt,
  }) {
    return LocalTaskOverridesCompanion(
      taskId: taskId ?? this.taskId,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      visitTag: visitTag ?? this.visitTag,
      needsShopSetup: needsShopSetup ?? this.needsShopSetup,
      fieldVerified: fieldVerified ?? this.fieldVerified,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (visitTag.present) {
      map['visit_tag'] = Variable<String>(visitTag.value);
    }
    if (needsShopSetup.present) {
      map['needs_shop_setup'] = Variable<bool>(needsShopSetup.value);
    }
    if (fieldVerified.present) {
      map['field_verified'] = Variable<bool>(fieldVerified.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTaskOverridesCompanion(')
          ..write('taskId: $taskId, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('visitTag: $visitTag, ')
          ..write('needsShopSetup: $needsShopSetup, ')
          ..write('fieldVerified: $fieldVerified, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CachedDocsTable extends CachedDocs
    with TableInfo<$CachedDocsTable, CachedDoc> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedDocsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonPayloadMeta = const VerificationMeta(
    'jsonPayload',
  );
  @override
  late final GeneratedColumn<String> jsonPayload = GeneratedColumn<String>(
    'json_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, jsonPayload, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_docs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedDoc> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('json_payload')) {
      context.handle(
        _jsonPayloadMeta,
        jsonPayload.isAcceptableOrUnknown(
          data['json_payload']!,
          _jsonPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jsonPayloadMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CachedDoc map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedDoc(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      jsonPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json_payload'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedDocsTable createAlias(String alias) {
    return $CachedDocsTable(attachedDatabase, alias);
  }
}

class CachedDoc extends DataClass implements Insertable<CachedDoc> {
  final String key;
  final String jsonPayload;
  final DateTime updatedAt;
  const CachedDoc({
    required this.key,
    required this.jsonPayload,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['json_payload'] = Variable<String>(jsonPayload);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedDocsCompanion toCompanion(bool nullToAbsent) {
    return CachedDocsCompanion(
      key: Value(key),
      jsonPayload: Value(jsonPayload),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedDoc.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedDoc(
      key: serializer.fromJson<String>(json['key']),
      jsonPayload: serializer.fromJson<String>(json['jsonPayload']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'jsonPayload': serializer.toJson<String>(jsonPayload),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedDoc copyWith({String? key, String? jsonPayload, DateTime? updatedAt}) =>
      CachedDoc(
        key: key ?? this.key,
        jsonPayload: jsonPayload ?? this.jsonPayload,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CachedDoc copyWithCompanion(CachedDocsCompanion data) {
    return CachedDoc(
      key: data.key.present ? data.key.value : this.key,
      jsonPayload: data.jsonPayload.present
          ? data.jsonPayload.value
          : this.jsonPayload,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedDoc(')
          ..write('key: $key, ')
          ..write('jsonPayload: $jsonPayload, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, jsonPayload, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedDoc &&
          other.key == this.key &&
          other.jsonPayload == this.jsonPayload &&
          other.updatedAt == this.updatedAt);
}

class CachedDocsCompanion extends UpdateCompanion<CachedDoc> {
  final Value<String> key;
  final Value<String> jsonPayload;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedDocsCompanion({
    this.key = const Value.absent(),
    this.jsonPayload = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedDocsCompanion.insert({
    required String key,
    required String jsonPayload,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       jsonPayload = Value(jsonPayload),
       updatedAt = Value(updatedAt);
  static Insertable<CachedDoc> custom({
    Expression<String>? key,
    Expression<String>? jsonPayload,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (jsonPayload != null) 'json_payload': jsonPayload,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedDocsCompanion copyWith({
    Value<String>? key,
    Value<String>? jsonPayload,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedDocsCompanion(
      key: key ?? this.key,
      jsonPayload: jsonPayload ?? this.jsonPayload,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (jsonPayload.present) {
      map['json_payload'] = Variable<String>(jsonPayload.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedDocsCompanion(')
          ..write('key: $key, ')
          ..write('jsonPayload: $jsonPayload, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogProductsTable extends CatalogProducts
    with TableInfo<$CatalogProductsTable, CatalogProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('global'),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonPayloadMeta = const VerificationMeta(
    'jsonPayload',
  );
  @override
  late final GeneratedColumn<String> jsonPayload = GeneratedColumn<String>(
    'json_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    scope,
    productId,
    jsonPayload,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('json_payload')) {
      context.handle(
        _jsonPayloadMeta,
        jsonPayload.isAcceptableOrUnknown(
          data['json_payload']!,
          _jsonPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jsonPayloadMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scope, productId};
  @override
  CatalogProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogProduct(
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      jsonPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json_payload'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CatalogProductsTable createAlias(String alias) {
    return $CatalogProductsTable(attachedDatabase, alias);
  }
}

class CatalogProduct extends DataClass implements Insertable<CatalogProduct> {
  final String scope;
  final int productId;
  final String jsonPayload;
  final DateTime updatedAt;
  const CatalogProduct({
    required this.scope,
    required this.productId,
    required this.jsonPayload,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope'] = Variable<String>(scope);
    map['product_id'] = Variable<int>(productId);
    map['json_payload'] = Variable<String>(jsonPayload);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CatalogProductsCompanion toCompanion(bool nullToAbsent) {
    return CatalogProductsCompanion(
      scope: Value(scope),
      productId: Value(productId),
      jsonPayload: Value(jsonPayload),
      updatedAt: Value(updatedAt),
    );
  }

  factory CatalogProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogProduct(
      scope: serializer.fromJson<String>(json['scope']),
      productId: serializer.fromJson<int>(json['productId']),
      jsonPayload: serializer.fromJson<String>(json['jsonPayload']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scope': serializer.toJson<String>(scope),
      'productId': serializer.toJson<int>(productId),
      'jsonPayload': serializer.toJson<String>(jsonPayload),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CatalogProduct copyWith({
    String? scope,
    int? productId,
    String? jsonPayload,
    DateTime? updatedAt,
  }) => CatalogProduct(
    scope: scope ?? this.scope,
    productId: productId ?? this.productId,
    jsonPayload: jsonPayload ?? this.jsonPayload,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CatalogProduct copyWithCompanion(CatalogProductsCompanion data) {
    return CatalogProduct(
      scope: data.scope.present ? data.scope.value : this.scope,
      productId: data.productId.present ? data.productId.value : this.productId,
      jsonPayload: data.jsonPayload.present
          ? data.jsonPayload.value
          : this.jsonPayload,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogProduct(')
          ..write('scope: $scope, ')
          ..write('productId: $productId, ')
          ..write('jsonPayload: $jsonPayload, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(scope, productId, jsonPayload, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogProduct &&
          other.scope == this.scope &&
          other.productId == this.productId &&
          other.jsonPayload == this.jsonPayload &&
          other.updatedAt == this.updatedAt);
}

class CatalogProductsCompanion extends UpdateCompanion<CatalogProduct> {
  final Value<String> scope;
  final Value<int> productId;
  final Value<String> jsonPayload;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CatalogProductsCompanion({
    this.scope = const Value.absent(),
    this.productId = const Value.absent(),
    this.jsonPayload = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogProductsCompanion.insert({
    this.scope = const Value.absent(),
    required int productId,
    required String jsonPayload,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : productId = Value(productId),
       jsonPayload = Value(jsonPayload),
       updatedAt = Value(updatedAt);
  static Insertable<CatalogProduct> custom({
    Expression<String>? scope,
    Expression<int>? productId,
    Expression<String>? jsonPayload,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scope != null) 'scope': scope,
      if (productId != null) 'product_id': productId,
      if (jsonPayload != null) 'json_payload': jsonPayload,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogProductsCompanion copyWith({
    Value<String>? scope,
    Value<int>? productId,
    Value<String>? jsonPayload,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CatalogProductsCompanion(
      scope: scope ?? this.scope,
      productId: productId ?? this.productId,
      jsonPayload: jsonPayload ?? this.jsonPayload,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (jsonPayload.present) {
      map['json_payload'] = Variable<String>(jsonPayload.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogProductsCompanion(')
          ..write('scope: $scope, ')
          ..write('productId: $productId, ')
          ..write('jsonPayload: $jsonPayload, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaFilesTable extends MediaFiles
    with TableInfo<$MediaFilesTable, MediaFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, path, purpose, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    } else if (isInserting) {
      context.missing(_purposeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MediaFilesTable createAlias(String alias) {
    return $MediaFilesTable(attachedDatabase, alias);
  }
}

class MediaFile extends DataClass implements Insertable<MediaFile> {
  final String id;
  final String path;
  final String purpose;
  final DateTime createdAt;
  const MediaFile({
    required this.id,
    required this.path,
    required this.purpose,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['path'] = Variable<String>(path);
    map['purpose'] = Variable<String>(purpose);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MediaFilesCompanion toCompanion(bool nullToAbsent) {
    return MediaFilesCompanion(
      id: Value(id),
      path: Value(path),
      purpose: Value(purpose),
      createdAt: Value(createdAt),
    );
  }

  factory MediaFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaFile(
      id: serializer.fromJson<String>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      purpose: serializer.fromJson<String>(json['purpose']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'path': serializer.toJson<String>(path),
      'purpose': serializer.toJson<String>(purpose),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MediaFile copyWith({
    String? id,
    String? path,
    String? purpose,
    DateTime? createdAt,
  }) => MediaFile(
    id: id ?? this.id,
    path: path ?? this.path,
    purpose: purpose ?? this.purpose,
    createdAt: createdAt ?? this.createdAt,
  );
  MediaFile copyWithCompanion(MediaFilesCompanion data) {
    return MediaFile(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaFile(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('purpose: $purpose, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, purpose, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaFile &&
          other.id == this.id &&
          other.path == this.path &&
          other.purpose == this.purpose &&
          other.createdAt == this.createdAt);
}

class MediaFilesCompanion extends UpdateCompanion<MediaFile> {
  final Value<String> id;
  final Value<String> path;
  final Value<String> purpose;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MediaFilesCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.purpose = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaFilesCompanion.insert({
    required String id,
    required String path,
    required String purpose,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       path = Value(path),
       purpose = Value(purpose),
       createdAt = Value(createdAt);
  static Insertable<MediaFile> custom({
    Expression<String>? id,
    Expression<String>? path,
    Expression<String>? purpose,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (purpose != null) 'purpose': purpose,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaFilesCompanion copyWith({
    Value<String>? id,
    Value<String>? path,
    Value<String>? purpose,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MediaFilesCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      purpose: purpose ?? this.purpose,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaFilesCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('purpose: $purpose, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopMediaTable extends ShopMedia
    with TableInfo<$ShopMediaTable, ShopMediaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopMediaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _shopIdMeta = const VerificationMeta('shopId');
  @override
  late final GeneratedColumn<String> shopId = GeneratedColumn<String>(
    'shop_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<String> slot = GeneratedColumn<String>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
    'media_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [shopId, slot, mediaId, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShopMediaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('shop_id')) {
      context.handle(
        _shopIdMeta,
        shopId.isAcceptableOrUnknown(data['shop_id']!, _shopIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shopIdMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {shopId, slot};
  @override
  ShopMediaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopMediaRow(
      shopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop_id'],
      )!,
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slot'],
      )!,
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ShopMediaTable createAlias(String alias) {
    return $ShopMediaTable(attachedDatabase, alias);
  }
}

class ShopMediaRow extends DataClass implements Insertable<ShopMediaRow> {
  final String shopId;
  final String slot;
  final String mediaId;
  final DateTime updatedAt;
  const ShopMediaRow({
    required this.shopId,
    required this.slot,
    required this.mediaId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['shop_id'] = Variable<String>(shopId);
    map['slot'] = Variable<String>(slot);
    map['media_id'] = Variable<String>(mediaId);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ShopMediaCompanion toCompanion(bool nullToAbsent) {
    return ShopMediaCompanion(
      shopId: Value(shopId),
      slot: Value(slot),
      mediaId: Value(mediaId),
      updatedAt: Value(updatedAt),
    );
  }

  factory ShopMediaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopMediaRow(
      shopId: serializer.fromJson<String>(json['shopId']),
      slot: serializer.fromJson<String>(json['slot']),
      mediaId: serializer.fromJson<String>(json['mediaId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'shopId': serializer.toJson<String>(shopId),
      'slot': serializer.toJson<String>(slot),
      'mediaId': serializer.toJson<String>(mediaId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ShopMediaRow copyWith({
    String? shopId,
    String? slot,
    String? mediaId,
    DateTime? updatedAt,
  }) => ShopMediaRow(
    shopId: shopId ?? this.shopId,
    slot: slot ?? this.slot,
    mediaId: mediaId ?? this.mediaId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ShopMediaRow copyWithCompanion(ShopMediaCompanion data) {
    return ShopMediaRow(
      shopId: data.shopId.present ? data.shopId.value : this.shopId,
      slot: data.slot.present ? data.slot.value : this.slot,
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopMediaRow(')
          ..write('shopId: $shopId, ')
          ..write('slot: $slot, ')
          ..write('mediaId: $mediaId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(shopId, slot, mediaId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopMediaRow &&
          other.shopId == this.shopId &&
          other.slot == this.slot &&
          other.mediaId == this.mediaId &&
          other.updatedAt == this.updatedAt);
}

class ShopMediaCompanion extends UpdateCompanion<ShopMediaRow> {
  final Value<String> shopId;
  final Value<String> slot;
  final Value<String> mediaId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ShopMediaCompanion({
    this.shopId = const Value.absent(),
    this.slot = const Value.absent(),
    this.mediaId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopMediaCompanion.insert({
    required String shopId,
    required String slot,
    required String mediaId,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : shopId = Value(shopId),
       slot = Value(slot),
       mediaId = Value(mediaId),
       updatedAt = Value(updatedAt);
  static Insertable<ShopMediaRow> custom({
    Expression<String>? shopId,
    Expression<String>? slot,
    Expression<String>? mediaId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (shopId != null) 'shop_id': shopId,
      if (slot != null) 'slot': slot,
      if (mediaId != null) 'media_id': mediaId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopMediaCompanion copyWith({
    Value<String>? shopId,
    Value<String>? slot,
    Value<String>? mediaId,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ShopMediaCompanion(
      shopId: shopId ?? this.shopId,
      slot: slot ?? this.slot,
      mediaId: mediaId ?? this.mediaId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (shopId.present) {
      map['shop_id'] = Variable<String>(shopId.value);
    }
    if (slot.present) {
      map['slot'] = Variable<String>(slot.value);
    }
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopMediaCompanion(')
          ..write('shopId: $shopId, ')
          ..write('slot: $slot, ')
          ..write('mediaId: $mediaId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TelemetrySentTable extends TelemetrySent
    with TableInfo<$TelemetrySentTable, TelemetrySentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TelemetrySentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientRequestIdMeta = const VerificationMeta(
    'clientRequestId',
  );
  @override
  late final GeneratedColumn<String> clientRequestId = GeneratedColumn<String>(
    'client_request_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [clientRequestId, sentAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'telemetry_sent';
  @override
  VerificationContext validateIntegrity(
    Insertable<TelemetrySentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_request_id')) {
      context.handle(
        _clientRequestIdMeta,
        clientRequestId.isAcceptableOrUnknown(
          data['client_request_id']!,
          _clientRequestIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientRequestIdMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientRequestId};
  @override
  TelemetrySentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TelemetrySentData(
      clientRequestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_request_id'],
      )!,
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      )!,
    );
  }

  @override
  $TelemetrySentTable createAlias(String alias) {
    return $TelemetrySentTable(attachedDatabase, alias);
  }
}

class TelemetrySentData extends DataClass
    implements Insertable<TelemetrySentData> {
  final String clientRequestId;
  final DateTime sentAt;
  const TelemetrySentData({
    required this.clientRequestId,
    required this.sentAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_request_id'] = Variable<String>(clientRequestId);
    map['sent_at'] = Variable<DateTime>(sentAt);
    return map;
  }

  TelemetrySentCompanion toCompanion(bool nullToAbsent) {
    return TelemetrySentCompanion(
      clientRequestId: Value(clientRequestId),
      sentAt: Value(sentAt),
    );
  }

  factory TelemetrySentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TelemetrySentData(
      clientRequestId: serializer.fromJson<String>(json['clientRequestId']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientRequestId': serializer.toJson<String>(clientRequestId),
      'sentAt': serializer.toJson<DateTime>(sentAt),
    };
  }

  TelemetrySentData copyWith({String? clientRequestId, DateTime? sentAt}) =>
      TelemetrySentData(
        clientRequestId: clientRequestId ?? this.clientRequestId,
        sentAt: sentAt ?? this.sentAt,
      );
  TelemetrySentData copyWithCompanion(TelemetrySentCompanion data) {
    return TelemetrySentData(
      clientRequestId: data.clientRequestId.present
          ? data.clientRequestId.value
          : this.clientRequestId,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TelemetrySentData(')
          ..write('clientRequestId: $clientRequestId, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(clientRequestId, sentAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TelemetrySentData &&
          other.clientRequestId == this.clientRequestId &&
          other.sentAt == this.sentAt);
}

class TelemetrySentCompanion extends UpdateCompanion<TelemetrySentData> {
  final Value<String> clientRequestId;
  final Value<DateTime> sentAt;
  final Value<int> rowid;
  const TelemetrySentCompanion({
    this.clientRequestId = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TelemetrySentCompanion.insert({
    required String clientRequestId,
    required DateTime sentAt,
    this.rowid = const Value.absent(),
  }) : clientRequestId = Value(clientRequestId),
       sentAt = Value(sentAt);
  static Insertable<TelemetrySentData> custom({
    Expression<String>? clientRequestId,
    Expression<DateTime>? sentAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientRequestId != null) 'client_request_id': clientRequestId,
      if (sentAt != null) 'sent_at': sentAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TelemetrySentCompanion copyWith({
    Value<String>? clientRequestId,
    Value<DateTime>? sentAt,
    Value<int>? rowid,
  }) {
    return TelemetrySentCompanion(
      clientRequestId: clientRequestId ?? this.clientRequestId,
      sentAt: sentAt ?? this.sentAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientRequestId.present) {
      map['client_request_id'] = Variable<String>(clientRequestId.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TelemetrySentCompanion(')
          ..write('clientRequestId: $clientRequestId, ')
          ..write('sentAt: $sentAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final $VisitCartLinesTable visitCartLines = $VisitCartLinesTable(this);
  late final $VisitProductsTable visitProducts = $VisitProductsTable(this);
  late final $VisitOrderLinesTable visitOrderLines = $VisitOrderLinesTable(
    this,
  );
  late final $IdMappingsTable idMappings = $IdMappingsTable(this);
  late final $LocalVisitsTable localVisits = $LocalVisitsTable(this);
  late final $LocalShopsTable localShops = $LocalShopsTable(this);
  late final $LocalTaskOverridesTable localTaskOverrides =
      $LocalTaskOverridesTable(this);
  late final $CachedDocsTable cachedDocs = $CachedDocsTable(this);
  late final $CatalogProductsTable catalogProducts = $CatalogProductsTable(
    this,
  );
  late final $MediaFilesTable mediaFiles = $MediaFilesTable(this);
  late final $ShopMediaTable shopMedia = $ShopMediaTable(this);
  late final $TelemetrySentTable telemetrySent = $TelemetrySentTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    outboxEntries,
    visitCartLines,
    visitProducts,
    visitOrderLines,
    idMappings,
    localVisits,
    localShops,
    localTaskOverrides,
    cachedDocs,
    catalogProducts,
    mediaFiles,
    shopMedia,
    telemetrySent,
  ];
}

typedef $$OutboxEntriesTableCreateCompanionBuilder =
    OutboxEntriesCompanion Function({
      required String id,
      required String role,
      required String action,
      required String payloadJson,
      required String clientRequestId,
      Value<String> status,
      Value<int> attempts,
      Value<String?> lastError,
      required DateTime createdAt,
      Value<DateTime?> syncedAt,
      Value<String?> dependsOn,
      Value<String?> userId,
      Value<String?> entityType,
      Value<int?> localEntityId,
      Value<String?> mediaIds,
      Value<int> rowid,
    });
typedef $$OutboxEntriesTableUpdateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<String> id,
      Value<String> role,
      Value<String> action,
      Value<String> payloadJson,
      Value<String> clientRequestId,
      Value<String> status,
      Value<int> attempts,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
      Value<String?> dependsOn,
      Value<String?> userId,
      Value<String?> entityType,
      Value<int?> localEntityId,
      Value<String?> mediaIds,
      Value<int> rowid,
    });

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dependsOn => $composableBuilder(
    column: $table.dependsOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localEntityId => $composableBuilder(
    column: $table.localEntityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaIds => $composableBuilder(
    column: $table.mediaIds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dependsOn => $composableBuilder(
    column: $table.dependsOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localEntityId => $composableBuilder(
    column: $table.localEntityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaIds => $composableBuilder(
    column: $table.mediaIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get dependsOn =>
      $composableBuilder(column: $table.dependsOn, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get localEntityId => $composableBuilder(
    column: $table.localEntityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaIds =>
      $composableBuilder(column: $table.mediaIds, builder: (column) => column);
}

class $$OutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxEntriesTable,
          OutboxEntry,
          $$OutboxEntriesTableFilterComposer,
          $$OutboxEntriesTableOrderingComposer,
          $$OutboxEntriesTableAnnotationComposer,
          $$OutboxEntriesTableCreateCompanionBuilder,
          $$OutboxEntriesTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxEntriesTableTableManager(_$AppDatabase db, $OutboxEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> clientRequestId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> dependsOn = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<int?> localEntityId = const Value.absent(),
                Value<String?> mediaIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxEntriesCompanion(
                id: id,
                role: role,
                action: action,
                payloadJson: payloadJson,
                clientRequestId: clientRequestId,
                status: status,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
                syncedAt: syncedAt,
                dependsOn: dependsOn,
                userId: userId,
                entityType: entityType,
                localEntityId: localEntityId,
                mediaIds: mediaIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String role,
                required String action,
                required String payloadJson,
                required String clientRequestId,
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String?> dependsOn = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> entityType = const Value.absent(),
                Value<int?> localEntityId = const Value.absent(),
                Value<String?> mediaIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxEntriesCompanion.insert(
                id: id,
                role: role,
                action: action,
                payloadJson: payloadJson,
                clientRequestId: clientRequestId,
                status: status,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
                syncedAt: syncedAt,
                dependsOn: dependsOn,
                userId: userId,
                entityType: entityType,
                localEntityId: localEntityId,
                mediaIds: mediaIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxEntriesTable,
      OutboxEntry,
      $$OutboxEntriesTableFilterComposer,
      $$OutboxEntriesTableOrderingComposer,
      $$OutboxEntriesTableAnnotationComposer,
      $$OutboxEntriesTableCreateCompanionBuilder,
      $$OutboxEntriesTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$VisitCartLinesTableCreateCompanionBuilder =
    VisitCartLinesCompanion Function({
      required int visitId,
      required int lineId,
      required int productId,
      required String productName,
      required double quantity,
      required double priceUnit,
      Value<String?> unit,
      Value<bool> isLocalOnly,
      Value<int> rowid,
    });
typedef $$VisitCartLinesTableUpdateCompanionBuilder =
    VisitCartLinesCompanion Function({
      Value<int> visitId,
      Value<int> lineId,
      Value<int> productId,
      Value<String> productName,
      Value<double> quantity,
      Value<double> priceUnit,
      Value<String?> unit,
      Value<bool> isLocalOnly,
      Value<int> rowid,
    });

class $$VisitCartLinesTableFilterComposer
    extends Composer<_$AppDatabase, $VisitCartLinesTable> {
  $$VisitCartLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceUnit => $composableBuilder(
    column: $table.priceUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocalOnly => $composableBuilder(
    column: $table.isLocalOnly,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VisitCartLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitCartLinesTable> {
  $$VisitCartLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceUnit => $composableBuilder(
    column: $table.priceUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocalOnly => $composableBuilder(
    column: $table.isLocalOnly,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VisitCartLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitCartLinesTable> {
  $$VisitCartLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<int> get lineId =>
      $composableBuilder(column: $table.lineId, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get priceUnit =>
      $composableBuilder(column: $table.priceUnit, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isLocalOnly => $composableBuilder(
    column: $table.isLocalOnly,
    builder: (column) => column,
  );
}

class $$VisitCartLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitCartLinesTable,
          VisitCartLine,
          $$VisitCartLinesTableFilterComposer,
          $$VisitCartLinesTableOrderingComposer,
          $$VisitCartLinesTableAnnotationComposer,
          $$VisitCartLinesTableCreateCompanionBuilder,
          $$VisitCartLinesTableUpdateCompanionBuilder,
          (
            VisitCartLine,
            BaseReferences<_$AppDatabase, $VisitCartLinesTable, VisitCartLine>,
          ),
          VisitCartLine,
          PrefetchHooks Function()
        > {
  $$VisitCartLinesTableTableManager(
    _$AppDatabase db,
    $VisitCartLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitCartLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitCartLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitCartLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> visitId = const Value.absent(),
                Value<int> lineId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> priceUnit = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<bool> isLocalOnly = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitCartLinesCompanion(
                visitId: visitId,
                lineId: lineId,
                productId: productId,
                productName: productName,
                quantity: quantity,
                priceUnit: priceUnit,
                unit: unit,
                isLocalOnly: isLocalOnly,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int visitId,
                required int lineId,
                required int productId,
                required String productName,
                required double quantity,
                required double priceUnit,
                Value<String?> unit = const Value.absent(),
                Value<bool> isLocalOnly = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitCartLinesCompanion.insert(
                visitId: visitId,
                lineId: lineId,
                productId: productId,
                productName: productName,
                quantity: quantity,
                priceUnit: priceUnit,
                unit: unit,
                isLocalOnly: isLocalOnly,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VisitCartLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitCartLinesTable,
      VisitCartLine,
      $$VisitCartLinesTableFilterComposer,
      $$VisitCartLinesTableOrderingComposer,
      $$VisitCartLinesTableAnnotationComposer,
      $$VisitCartLinesTableCreateCompanionBuilder,
      $$VisitCartLinesTableUpdateCompanionBuilder,
      (
        VisitCartLine,
        BaseReferences<_$AppDatabase, $VisitCartLinesTable, VisitCartLine>,
      ),
      VisitCartLine,
      PrefetchHooks Function()
    >;
typedef $$VisitProductsTableCreateCompanionBuilder =
    VisitProductsCompanion Function({
      required int visitId,
      required int productId,
      required String jsonPayload,
      Value<int> rowid,
    });
typedef $$VisitProductsTableUpdateCompanionBuilder =
    VisitProductsCompanion Function({
      Value<int> visitId,
      Value<int> productId,
      Value<String> jsonPayload,
      Value<int> rowid,
    });

class $$VisitProductsTableFilterComposer
    extends Composer<_$AppDatabase, $VisitProductsTable> {
  $$VisitProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jsonPayload => $composableBuilder(
    column: $table.jsonPayload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VisitProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitProductsTable> {
  $$VisitProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jsonPayload => $composableBuilder(
    column: $table.jsonPayload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VisitProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitProductsTable> {
  $$VisitProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get jsonPayload => $composableBuilder(
    column: $table.jsonPayload,
    builder: (column) => column,
  );
}

class $$VisitProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitProductsTable,
          VisitProduct,
          $$VisitProductsTableFilterComposer,
          $$VisitProductsTableOrderingComposer,
          $$VisitProductsTableAnnotationComposer,
          $$VisitProductsTableCreateCompanionBuilder,
          $$VisitProductsTableUpdateCompanionBuilder,
          (
            VisitProduct,
            BaseReferences<_$AppDatabase, $VisitProductsTable, VisitProduct>,
          ),
          VisitProduct,
          PrefetchHooks Function()
        > {
  $$VisitProductsTableTableManager(_$AppDatabase db, $VisitProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> visitId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> jsonPayload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitProductsCompanion(
                visitId: visitId,
                productId: productId,
                jsonPayload: jsonPayload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int visitId,
                required int productId,
                required String jsonPayload,
                Value<int> rowid = const Value.absent(),
              }) => VisitProductsCompanion.insert(
                visitId: visitId,
                productId: productId,
                jsonPayload: jsonPayload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VisitProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitProductsTable,
      VisitProduct,
      $$VisitProductsTableFilterComposer,
      $$VisitProductsTableOrderingComposer,
      $$VisitProductsTableAnnotationComposer,
      $$VisitProductsTableCreateCompanionBuilder,
      $$VisitProductsTableUpdateCompanionBuilder,
      (
        VisitProduct,
        BaseReferences<_$AppDatabase, $VisitProductsTable, VisitProduct>,
      ),
      VisitProduct,
      PrefetchHooks Function()
    >;
typedef $$VisitOrderLinesTableCreateCompanionBuilder =
    VisitOrderLinesCompanion Function({
      required int visitId,
      required int lineId,
      required int productId,
      required String productName,
      required double quantity,
      required double priceUnit,
      Value<String?> unit,
      Value<int> rowid,
    });
typedef $$VisitOrderLinesTableUpdateCompanionBuilder =
    VisitOrderLinesCompanion Function({
      Value<int> visitId,
      Value<int> lineId,
      Value<int> productId,
      Value<String> productName,
      Value<double> quantity,
      Value<double> priceUnit,
      Value<String?> unit,
      Value<int> rowid,
    });

class $$VisitOrderLinesTableFilterComposer
    extends Composer<_$AppDatabase, $VisitOrderLinesTable> {
  $$VisitOrderLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get priceUnit => $composableBuilder(
    column: $table.priceUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VisitOrderLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitOrderLinesTable> {
  $$VisitOrderLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get priceUnit => $composableBuilder(
    column: $table.priceUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VisitOrderLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitOrderLinesTable> {
  $$VisitOrderLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get visitId =>
      $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<int> get lineId =>
      $composableBuilder(column: $table.lineId, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get priceUnit =>
      $composableBuilder(column: $table.priceUnit, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);
}

class $$VisitOrderLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitOrderLinesTable,
          VisitOrderLine,
          $$VisitOrderLinesTableFilterComposer,
          $$VisitOrderLinesTableOrderingComposer,
          $$VisitOrderLinesTableAnnotationComposer,
          $$VisitOrderLinesTableCreateCompanionBuilder,
          $$VisitOrderLinesTableUpdateCompanionBuilder,
          (
            VisitOrderLine,
            BaseReferences<
              _$AppDatabase,
              $VisitOrderLinesTable,
              VisitOrderLine
            >,
          ),
          VisitOrderLine,
          PrefetchHooks Function()
        > {
  $$VisitOrderLinesTableTableManager(
    _$AppDatabase db,
    $VisitOrderLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitOrderLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitOrderLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitOrderLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> visitId = const Value.absent(),
                Value<int> lineId = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> priceUnit = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitOrderLinesCompanion(
                visitId: visitId,
                lineId: lineId,
                productId: productId,
                productName: productName,
                quantity: quantity,
                priceUnit: priceUnit,
                unit: unit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int visitId,
                required int lineId,
                required int productId,
                required String productName,
                required double quantity,
                required double priceUnit,
                Value<String?> unit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitOrderLinesCompanion.insert(
                visitId: visitId,
                lineId: lineId,
                productId: productId,
                productName: productName,
                quantity: quantity,
                priceUnit: priceUnit,
                unit: unit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VisitOrderLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitOrderLinesTable,
      VisitOrderLine,
      $$VisitOrderLinesTableFilterComposer,
      $$VisitOrderLinesTableOrderingComposer,
      $$VisitOrderLinesTableAnnotationComposer,
      $$VisitOrderLinesTableCreateCompanionBuilder,
      $$VisitOrderLinesTableUpdateCompanionBuilder,
      (
        VisitOrderLine,
        BaseReferences<_$AppDatabase, $VisitOrderLinesTable, VisitOrderLine>,
      ),
      VisitOrderLine,
      PrefetchHooks Function()
    >;
typedef $$IdMappingsTableCreateCompanionBuilder =
    IdMappingsCompanion Function({
      required String entityType,
      required int localId,
      required int serverId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$IdMappingsTableUpdateCompanionBuilder =
    IdMappingsCompanion Function({
      Value<String> entityType,
      Value<int> localId,
      Value<int> serverId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$IdMappingsTableFilterComposer
    extends Composer<_$AppDatabase, $IdMappingsTable> {
  $$IdMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IdMappingsTableOrderingComposer
    extends Composer<_$AppDatabase, $IdMappingsTable> {
  $$IdMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IdMappingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdMappingsTable> {
  $$IdMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$IdMappingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdMappingsTable,
          IdMapping,
          $$IdMappingsTableFilterComposer,
          $$IdMappingsTableOrderingComposer,
          $$IdMappingsTableAnnotationComposer,
          $$IdMappingsTableCreateCompanionBuilder,
          $$IdMappingsTableUpdateCompanionBuilder,
          (
            IdMapping,
            BaseReferences<_$AppDatabase, $IdMappingsTable, IdMapping>,
          ),
          IdMapping,
          PrefetchHooks Function()
        > {
  $$IdMappingsTableTableManager(_$AppDatabase db, $IdMappingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdMappingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdMappingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdMappingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityType = const Value.absent(),
                Value<int> localId = const Value.absent(),
                Value<int> serverId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdMappingsCompanion(
                entityType: entityType,
                localId: localId,
                serverId: serverId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityType,
                required int localId,
                required int serverId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => IdMappingsCompanion.insert(
                entityType: entityType,
                localId: localId,
                serverId: serverId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IdMappingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdMappingsTable,
      IdMapping,
      $$IdMappingsTableFilterComposer,
      $$IdMappingsTableOrderingComposer,
      $$IdMappingsTableAnnotationComposer,
      $$IdMappingsTableCreateCompanionBuilder,
      $$IdMappingsTableUpdateCompanionBuilder,
      (IdMapping, BaseReferences<_$AppDatabase, $IdMappingsTable, IdMapping>),
      IdMapping,
      PrefetchHooks Function()
    >;
typedef $$LocalVisitsTableCreateCompanionBuilder =
    LocalVisitsCompanion Function({
      Value<int> localVisitId,
      Value<int?> serverVisitId,
      required int taskId,
      required String shopId,
      required String shopName,
      required double latitude,
      required double longitude,
      required DateTime checkedInAt,
      Value<String> kind,
      Value<String> status,
      Value<String?> outcome,
      Value<String?> notes,
      Value<String?> orderNumber,
      Value<double?> subtotal,
      Value<bool> pendingSync,
      Value<String?> approvalState,
      Value<String?> userId,
      required DateTime createdAt,
      Value<DateTime?> completedAt,
    });
typedef $$LocalVisitsTableUpdateCompanionBuilder =
    LocalVisitsCompanion Function({
      Value<int> localVisitId,
      Value<int?> serverVisitId,
      Value<int> taskId,
      Value<String> shopId,
      Value<String> shopName,
      Value<double> latitude,
      Value<double> longitude,
      Value<DateTime> checkedInAt,
      Value<String> kind,
      Value<String> status,
      Value<String?> outcome,
      Value<String?> notes,
      Value<String?> orderNumber,
      Value<double?> subtotal,
      Value<bool> pendingSync,
      Value<String?> approvalState,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
    });

class $$LocalVisitsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalVisitsTable> {
  $$LocalVisitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localVisitId => $composableBuilder(
    column: $table.localVisitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverVisitId => $composableBuilder(
    column: $table.serverVisitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopId => $composableBuilder(
    column: $table.shopId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopName => $composableBuilder(
    column: $table.shopName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvalState => $composableBuilder(
    column: $table.approvalState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVisitsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalVisitsTable> {
  $$LocalVisitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localVisitId => $composableBuilder(
    column: $table.localVisitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverVisitId => $composableBuilder(
    column: $table.serverVisitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopId => $composableBuilder(
    column: $table.shopId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopName => $composableBuilder(
    column: $table.shopName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvalState => $composableBuilder(
    column: $table.approvalState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVisitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalVisitsTable> {
  $$LocalVisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localVisitId => $composableBuilder(
    column: $table.localVisitId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverVisitId => $composableBuilder(
    column: $table.serverVisitId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get shopName =>
      $composableBuilder(column: $table.shopName, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => column,
  );

  GeneratedColumn<String> get approvalState => $composableBuilder(
    column: $table.approvalState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$LocalVisitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalVisitsTable,
          LocalVisit,
          $$LocalVisitsTableFilterComposer,
          $$LocalVisitsTableOrderingComposer,
          $$LocalVisitsTableAnnotationComposer,
          $$LocalVisitsTableCreateCompanionBuilder,
          $$LocalVisitsTableUpdateCompanionBuilder,
          (
            LocalVisit,
            BaseReferences<_$AppDatabase, $LocalVisitsTable, LocalVisit>,
          ),
          LocalVisit,
          PrefetchHooks Function()
        > {
  $$LocalVisitsTableTableManager(_$AppDatabase db, $LocalVisitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalVisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalVisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalVisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> localVisitId = const Value.absent(),
                Value<int?> serverVisitId = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<String> shopId = const Value.absent(),
                Value<String> shopName = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<DateTime> checkedInAt = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> orderNumber = const Value.absent(),
                Value<double?> subtotal = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<String?> approvalState = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => LocalVisitsCompanion(
                localVisitId: localVisitId,
                serverVisitId: serverVisitId,
                taskId: taskId,
                shopId: shopId,
                shopName: shopName,
                latitude: latitude,
                longitude: longitude,
                checkedInAt: checkedInAt,
                kind: kind,
                status: status,
                outcome: outcome,
                notes: notes,
                orderNumber: orderNumber,
                subtotal: subtotal,
                pendingSync: pendingSync,
                approvalState: approvalState,
                userId: userId,
                createdAt: createdAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> localVisitId = const Value.absent(),
                Value<int?> serverVisitId = const Value.absent(),
                required int taskId,
                required String shopId,
                required String shopName,
                required double latitude,
                required double longitude,
                required DateTime checkedInAt,
                Value<String> kind = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> orderNumber = const Value.absent(),
                Value<double?> subtotal = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<String?> approvalState = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> completedAt = const Value.absent(),
              }) => LocalVisitsCompanion.insert(
                localVisitId: localVisitId,
                serverVisitId: serverVisitId,
                taskId: taskId,
                shopId: shopId,
                shopName: shopName,
                latitude: latitude,
                longitude: longitude,
                checkedInAt: checkedInAt,
                kind: kind,
                status: status,
                outcome: outcome,
                notes: notes,
                orderNumber: orderNumber,
                subtotal: subtotal,
                pendingSync: pendingSync,
                approvalState: approvalState,
                userId: userId,
                createdAt: createdAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVisitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalVisitsTable,
      LocalVisit,
      $$LocalVisitsTableFilterComposer,
      $$LocalVisitsTableOrderingComposer,
      $$LocalVisitsTableAnnotationComposer,
      $$LocalVisitsTableCreateCompanionBuilder,
      $$LocalVisitsTableUpdateCompanionBuilder,
      (
        LocalVisit,
        BaseReferences<_$AppDatabase, $LocalVisitsTable, LocalVisit>,
      ),
      LocalVisit,
      PrefetchHooks Function()
    >;
typedef $$LocalShopsTableCreateCompanionBuilder =
    LocalShopsCompanion Function({
      Value<int> localShopId,
      Value<int?> serverShopId,
      required String name,
      Value<String?> ownerName,
      Value<String?> ownerPhone,
      Value<String?> ownerCnic,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> shopCategory,
      required String payloadJson,
      Value<String> status,
      Value<String?> userId,
      required DateTime createdAt,
    });
typedef $$LocalShopsTableUpdateCompanionBuilder =
    LocalShopsCompanion Function({
      Value<int> localShopId,
      Value<int?> serverShopId,
      Value<String> name,
      Value<String?> ownerName,
      Value<String?> ownerPhone,
      Value<String?> ownerCnic,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> shopCategory,
      Value<String> payloadJson,
      Value<String> status,
      Value<String?> userId,
      Value<DateTime> createdAt,
    });

class $$LocalShopsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalShopsTable> {
  $$LocalShopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localShopId => $composableBuilder(
    column: $table.localShopId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverShopId => $composableBuilder(
    column: $table.serverShopId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerPhone => $composableBuilder(
    column: $table.ownerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerCnic => $composableBuilder(
    column: $table.ownerCnic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shopCategory => $composableBuilder(
    column: $table.shopCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalShopsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalShopsTable> {
  $$LocalShopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localShopId => $composableBuilder(
    column: $table.localShopId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverShopId => $composableBuilder(
    column: $table.serverShopId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerPhone => $composableBuilder(
    column: $table.ownerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerCnic => $composableBuilder(
    column: $table.ownerCnic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shopCategory => $composableBuilder(
    column: $table.shopCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalShopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalShopsTable> {
  $$LocalShopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localShopId => $composableBuilder(
    column: $table.localShopId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get serverShopId => $composableBuilder(
    column: $table.serverShopId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get ownerName =>
      $composableBuilder(column: $table.ownerName, builder: (column) => column);

  GeneratedColumn<String> get ownerPhone => $composableBuilder(
    column: $table.ownerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerCnic =>
      $composableBuilder(column: $table.ownerCnic, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get shopCategory => $composableBuilder(
    column: $table.shopCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalShopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalShopsTable,
          LocalShop,
          $$LocalShopsTableFilterComposer,
          $$LocalShopsTableOrderingComposer,
          $$LocalShopsTableAnnotationComposer,
          $$LocalShopsTableCreateCompanionBuilder,
          $$LocalShopsTableUpdateCompanionBuilder,
          (
            LocalShop,
            BaseReferences<_$AppDatabase, $LocalShopsTable, LocalShop>,
          ),
          LocalShop,
          PrefetchHooks Function()
        > {
  $$LocalShopsTableTableManager(_$AppDatabase db, $LocalShopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalShopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalShopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalShopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> localShopId = const Value.absent(),
                Value<int?> serverShopId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> ownerName = const Value.absent(),
                Value<String?> ownerPhone = const Value.absent(),
                Value<String?> ownerCnic = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> shopCategory = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LocalShopsCompanion(
                localShopId: localShopId,
                serverShopId: serverShopId,
                name: name,
                ownerName: ownerName,
                ownerPhone: ownerPhone,
                ownerCnic: ownerCnic,
                latitude: latitude,
                longitude: longitude,
                shopCategory: shopCategory,
                payloadJson: payloadJson,
                status: status,
                userId: userId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> localShopId = const Value.absent(),
                Value<int?> serverShopId = const Value.absent(),
                required String name,
                Value<String?> ownerName = const Value.absent(),
                Value<String?> ownerPhone = const Value.absent(),
                Value<String?> ownerCnic = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> shopCategory = const Value.absent(),
                required String payloadJson,
                Value<String> status = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                required DateTime createdAt,
              }) => LocalShopsCompanion.insert(
                localShopId: localShopId,
                serverShopId: serverShopId,
                name: name,
                ownerName: ownerName,
                ownerPhone: ownerPhone,
                ownerCnic: ownerCnic,
                latitude: latitude,
                longitude: longitude,
                shopCategory: shopCategory,
                payloadJson: payloadJson,
                status: status,
                userId: userId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalShopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalShopsTable,
      LocalShop,
      $$LocalShopsTableFilterComposer,
      $$LocalShopsTableOrderingComposer,
      $$LocalShopsTableAnnotationComposer,
      $$LocalShopsTableCreateCompanionBuilder,
      $$LocalShopsTableUpdateCompanionBuilder,
      (LocalShop, BaseReferences<_$AppDatabase, $LocalShopsTable, LocalShop>),
      LocalShop,
      PrefetchHooks Function()
    >;
typedef $$LocalTaskOverridesTableCreateCompanionBuilder =
    LocalTaskOverridesCompanion Function({
      Value<int> taskId,
      Value<String?> status,
      Value<String?> notes,
      Value<String?> visitTag,
      Value<bool?> needsShopSetup,
      Value<bool?> fieldVerified,
      required DateTime updatedAt,
    });
typedef $$LocalTaskOverridesTableUpdateCompanionBuilder =
    LocalTaskOverridesCompanion Function({
      Value<int> taskId,
      Value<String?> status,
      Value<String?> notes,
      Value<String?> visitTag,
      Value<bool?> needsShopSetup,
      Value<bool?> fieldVerified,
      Value<DateTime> updatedAt,
    });

class $$LocalTaskOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalTaskOverridesTable> {
  $$LocalTaskOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitTag => $composableBuilder(
    column: $table.visitTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsShopSetup => $composableBuilder(
    column: $table.needsShopSetup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fieldVerified => $composableBuilder(
    column: $table.fieldVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTaskOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalTaskOverridesTable> {
  $$LocalTaskOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitTag => $composableBuilder(
    column: $table.visitTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsShopSetup => $composableBuilder(
    column: $table.needsShopSetup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fieldVerified => $composableBuilder(
    column: $table.fieldVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTaskOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalTaskOverridesTable> {
  $$LocalTaskOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get visitTag =>
      $composableBuilder(column: $table.visitTag, builder: (column) => column);

  GeneratedColumn<bool> get needsShopSetup => $composableBuilder(
    column: $table.needsShopSetup,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get fieldVerified => $composableBuilder(
    column: $table.fieldVerified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalTaskOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalTaskOverridesTable,
          LocalTaskOverride,
          $$LocalTaskOverridesTableFilterComposer,
          $$LocalTaskOverridesTableOrderingComposer,
          $$LocalTaskOverridesTableAnnotationComposer,
          $$LocalTaskOverridesTableCreateCompanionBuilder,
          $$LocalTaskOverridesTableUpdateCompanionBuilder,
          (
            LocalTaskOverride,
            BaseReferences<
              _$AppDatabase,
              $LocalTaskOverridesTable,
              LocalTaskOverride
            >,
          ),
          LocalTaskOverride,
          PrefetchHooks Function()
        > {
  $$LocalTaskOverridesTableTableManager(
    _$AppDatabase db,
    $LocalTaskOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTaskOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTaskOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTaskOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> taskId = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> visitTag = const Value.absent(),
                Value<bool?> needsShopSetup = const Value.absent(),
                Value<bool?> fieldVerified = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LocalTaskOverridesCompanion(
                taskId: taskId,
                status: status,
                notes: notes,
                visitTag: visitTag,
                needsShopSetup: needsShopSetup,
                fieldVerified: fieldVerified,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> taskId = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> visitTag = const Value.absent(),
                Value<bool?> needsShopSetup = const Value.absent(),
                Value<bool?> fieldVerified = const Value.absent(),
                required DateTime updatedAt,
              }) => LocalTaskOverridesCompanion.insert(
                taskId: taskId,
                status: status,
                notes: notes,
                visitTag: visitTag,
                needsShopSetup: needsShopSetup,
                fieldVerified: fieldVerified,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTaskOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalTaskOverridesTable,
      LocalTaskOverride,
      $$LocalTaskOverridesTableFilterComposer,
      $$LocalTaskOverridesTableOrderingComposer,
      $$LocalTaskOverridesTableAnnotationComposer,
      $$LocalTaskOverridesTableCreateCompanionBuilder,
      $$LocalTaskOverridesTableUpdateCompanionBuilder,
      (
        LocalTaskOverride,
        BaseReferences<
          _$AppDatabase,
          $LocalTaskOverridesTable,
          LocalTaskOverride
        >,
      ),
      LocalTaskOverride,
      PrefetchHooks Function()
    >;
typedef $$CachedDocsTableCreateCompanionBuilder =
    CachedDocsCompanion Function({
      required String key,
      required String jsonPayload,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CachedDocsTableUpdateCompanionBuilder =
    CachedDocsCompanion Function({
      Value<String> key,
      Value<String> jsonPayload,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CachedDocsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedDocsTable> {
  $$CachedDocsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jsonPayload => $composableBuilder(
    column: $table.jsonPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedDocsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedDocsTable> {
  $$CachedDocsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jsonPayload => $composableBuilder(
    column: $table.jsonPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedDocsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedDocsTable> {
  $$CachedDocsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get jsonPayload => $composableBuilder(
    column: $table.jsonPayload,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedDocsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedDocsTable,
          CachedDoc,
          $$CachedDocsTableFilterComposer,
          $$CachedDocsTableOrderingComposer,
          $$CachedDocsTableAnnotationComposer,
          $$CachedDocsTableCreateCompanionBuilder,
          $$CachedDocsTableUpdateCompanionBuilder,
          (
            CachedDoc,
            BaseReferences<_$AppDatabase, $CachedDocsTable, CachedDoc>,
          ),
          CachedDoc,
          PrefetchHooks Function()
        > {
  $$CachedDocsTableTableManager(_$AppDatabase db, $CachedDocsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedDocsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedDocsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedDocsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> jsonPayload = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedDocsCompanion(
                key: key,
                jsonPayload: jsonPayload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String jsonPayload,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedDocsCompanion.insert(
                key: key,
                jsonPayload: jsonPayload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedDocsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedDocsTable,
      CachedDoc,
      $$CachedDocsTableFilterComposer,
      $$CachedDocsTableOrderingComposer,
      $$CachedDocsTableAnnotationComposer,
      $$CachedDocsTableCreateCompanionBuilder,
      $$CachedDocsTableUpdateCompanionBuilder,
      (CachedDoc, BaseReferences<_$AppDatabase, $CachedDocsTable, CachedDoc>),
      CachedDoc,
      PrefetchHooks Function()
    >;
typedef $$CatalogProductsTableCreateCompanionBuilder =
    CatalogProductsCompanion Function({
      Value<String> scope,
      required int productId,
      required String jsonPayload,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CatalogProductsTableUpdateCompanionBuilder =
    CatalogProductsCompanion Function({
      Value<String> scope,
      Value<int> productId,
      Value<String> jsonPayload,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CatalogProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogProductsTable> {
  $$CatalogProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jsonPayload => $composableBuilder(
    column: $table.jsonPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogProductsTable> {
  $$CatalogProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jsonPayload => $composableBuilder(
    column: $table.jsonPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogProductsTable> {
  $$CatalogProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get jsonPayload => $composableBuilder(
    column: $table.jsonPayload,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CatalogProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogProductsTable,
          CatalogProduct,
          $$CatalogProductsTableFilterComposer,
          $$CatalogProductsTableOrderingComposer,
          $$CatalogProductsTableAnnotationComposer,
          $$CatalogProductsTableCreateCompanionBuilder,
          $$CatalogProductsTableUpdateCompanionBuilder,
          (
            CatalogProduct,
            BaseReferences<
              _$AppDatabase,
              $CatalogProductsTable,
              CatalogProduct
            >,
          ),
          CatalogProduct,
          PrefetchHooks Function()
        > {
  $$CatalogProductsTableTableManager(
    _$AppDatabase db,
    $CatalogProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> scope = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> jsonPayload = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogProductsCompanion(
                scope: scope,
                productId: productId,
                jsonPayload: jsonPayload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> scope = const Value.absent(),
                required int productId,
                required String jsonPayload,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CatalogProductsCompanion.insert(
                scope: scope,
                productId: productId,
                jsonPayload: jsonPayload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogProductsTable,
      CatalogProduct,
      $$CatalogProductsTableFilterComposer,
      $$CatalogProductsTableOrderingComposer,
      $$CatalogProductsTableAnnotationComposer,
      $$CatalogProductsTableCreateCompanionBuilder,
      $$CatalogProductsTableUpdateCompanionBuilder,
      (
        CatalogProduct,
        BaseReferences<_$AppDatabase, $CatalogProductsTable, CatalogProduct>,
      ),
      CatalogProduct,
      PrefetchHooks Function()
    >;
typedef $$MediaFilesTableCreateCompanionBuilder =
    MediaFilesCompanion Function({
      required String id,
      required String path,
      required String purpose,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MediaFilesTableUpdateCompanionBuilder =
    MediaFilesCompanion Function({
      Value<String> id,
      Value<String> path,
      Value<String> purpose,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$MediaFilesTableFilterComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaFilesTable> {
  $$MediaFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MediaFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaFilesTable,
          MediaFile,
          $$MediaFilesTableFilterComposer,
          $$MediaFilesTableOrderingComposer,
          $$MediaFilesTableAnnotationComposer,
          $$MediaFilesTableCreateCompanionBuilder,
          $$MediaFilesTableUpdateCompanionBuilder,
          (
            MediaFile,
            BaseReferences<_$AppDatabase, $MediaFilesTable, MediaFile>,
          ),
          MediaFile,
          PrefetchHooks Function()
        > {
  $$MediaFilesTableTableManager(_$AppDatabase db, $MediaFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaFilesCompanion(
                id: id,
                path: path,
                purpose: purpose,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String path,
                required String purpose,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MediaFilesCompanion.insert(
                id: id,
                path: path,
                purpose: purpose,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaFilesTable,
      MediaFile,
      $$MediaFilesTableFilterComposer,
      $$MediaFilesTableOrderingComposer,
      $$MediaFilesTableAnnotationComposer,
      $$MediaFilesTableCreateCompanionBuilder,
      $$MediaFilesTableUpdateCompanionBuilder,
      (MediaFile, BaseReferences<_$AppDatabase, $MediaFilesTable, MediaFile>),
      MediaFile,
      PrefetchHooks Function()
    >;
typedef $$ShopMediaTableCreateCompanionBuilder =
    ShopMediaCompanion Function({
      required String shopId,
      required String slot,
      required String mediaId,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ShopMediaTableUpdateCompanionBuilder =
    ShopMediaCompanion Function({
      Value<String> shopId,
      Value<String> slot,
      Value<String> mediaId,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ShopMediaTableFilterComposer
    extends Composer<_$AppDatabase, $ShopMediaTable> {
  $$ShopMediaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get shopId => $composableBuilder(
    column: $table.shopId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShopMediaTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopMediaTable> {
  $$ShopMediaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get shopId => $composableBuilder(
    column: $table.shopId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShopMediaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopMediaTable> {
  $$ShopMediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get shopId =>
      $composableBuilder(column: $table.shopId, builder: (column) => column);

  GeneratedColumn<String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get mediaId =>
      $composableBuilder(column: $table.mediaId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ShopMediaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShopMediaTable,
          ShopMediaRow,
          $$ShopMediaTableFilterComposer,
          $$ShopMediaTableOrderingComposer,
          $$ShopMediaTableAnnotationComposer,
          $$ShopMediaTableCreateCompanionBuilder,
          $$ShopMediaTableUpdateCompanionBuilder,
          (
            ShopMediaRow,
            BaseReferences<_$AppDatabase, $ShopMediaTable, ShopMediaRow>,
          ),
          ShopMediaRow,
          PrefetchHooks Function()
        > {
  $$ShopMediaTableTableManager(_$AppDatabase db, $ShopMediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopMediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopMediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopMediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> shopId = const Value.absent(),
                Value<String> slot = const Value.absent(),
                Value<String> mediaId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopMediaCompanion(
                shopId: shopId,
                slot: slot,
                mediaId: mediaId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String shopId,
                required String slot,
                required String mediaId,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ShopMediaCompanion.insert(
                shopId: shopId,
                slot: slot,
                mediaId: mediaId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShopMediaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShopMediaTable,
      ShopMediaRow,
      $$ShopMediaTableFilterComposer,
      $$ShopMediaTableOrderingComposer,
      $$ShopMediaTableAnnotationComposer,
      $$ShopMediaTableCreateCompanionBuilder,
      $$ShopMediaTableUpdateCompanionBuilder,
      (
        ShopMediaRow,
        BaseReferences<_$AppDatabase, $ShopMediaTable, ShopMediaRow>,
      ),
      ShopMediaRow,
      PrefetchHooks Function()
    >;
typedef $$TelemetrySentTableCreateCompanionBuilder =
    TelemetrySentCompanion Function({
      required String clientRequestId,
      required DateTime sentAt,
      Value<int> rowid,
    });
typedef $$TelemetrySentTableUpdateCompanionBuilder =
    TelemetrySentCompanion Function({
      Value<String> clientRequestId,
      Value<DateTime> sentAt,
      Value<int> rowid,
    });

class $$TelemetrySentTableFilterComposer
    extends Composer<_$AppDatabase, $TelemetrySentTable> {
  $$TelemetrySentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TelemetrySentTableOrderingComposer
    extends Composer<_$AppDatabase, $TelemetrySentTable> {
  $$TelemetrySentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TelemetrySentTableAnnotationComposer
    extends Composer<_$AppDatabase, $TelemetrySentTable> {
  $$TelemetrySentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientRequestId => $composableBuilder(
    column: $table.clientRequestId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);
}

class $$TelemetrySentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TelemetrySentTable,
          TelemetrySentData,
          $$TelemetrySentTableFilterComposer,
          $$TelemetrySentTableOrderingComposer,
          $$TelemetrySentTableAnnotationComposer,
          $$TelemetrySentTableCreateCompanionBuilder,
          $$TelemetrySentTableUpdateCompanionBuilder,
          (
            TelemetrySentData,
            BaseReferences<
              _$AppDatabase,
              $TelemetrySentTable,
              TelemetrySentData
            >,
          ),
          TelemetrySentData,
          PrefetchHooks Function()
        > {
  $$TelemetrySentTableTableManager(_$AppDatabase db, $TelemetrySentTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TelemetrySentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TelemetrySentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TelemetrySentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> clientRequestId = const Value.absent(),
                Value<DateTime> sentAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TelemetrySentCompanion(
                clientRequestId: clientRequestId,
                sentAt: sentAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientRequestId,
                required DateTime sentAt,
                Value<int> rowid = const Value.absent(),
              }) => TelemetrySentCompanion.insert(
                clientRequestId: clientRequestId,
                sentAt: sentAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TelemetrySentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TelemetrySentTable,
      TelemetrySentData,
      $$TelemetrySentTableFilterComposer,
      $$TelemetrySentTableOrderingComposer,
      $$TelemetrySentTableAnnotationComposer,
      $$TelemetrySentTableCreateCompanionBuilder,
      $$TelemetrySentTableUpdateCompanionBuilder,
      (
        TelemetrySentData,
        BaseReferences<_$AppDatabase, $TelemetrySentTable, TelemetrySentData>,
      ),
      TelemetrySentData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
  $$VisitCartLinesTableTableManager get visitCartLines =>
      $$VisitCartLinesTableTableManager(_db, _db.visitCartLines);
  $$VisitProductsTableTableManager get visitProducts =>
      $$VisitProductsTableTableManager(_db, _db.visitProducts);
  $$VisitOrderLinesTableTableManager get visitOrderLines =>
      $$VisitOrderLinesTableTableManager(_db, _db.visitOrderLines);
  $$IdMappingsTableTableManager get idMappings =>
      $$IdMappingsTableTableManager(_db, _db.idMappings);
  $$LocalVisitsTableTableManager get localVisits =>
      $$LocalVisitsTableTableManager(_db, _db.localVisits);
  $$LocalShopsTableTableManager get localShops =>
      $$LocalShopsTableTableManager(_db, _db.localShops);
  $$LocalTaskOverridesTableTableManager get localTaskOverrides =>
      $$LocalTaskOverridesTableTableManager(_db, _db.localTaskOverrides);
  $$CachedDocsTableTableManager get cachedDocs =>
      $$CachedDocsTableTableManager(_db, _db.cachedDocs);
  $$CatalogProductsTableTableManager get catalogProducts =>
      $$CatalogProductsTableTableManager(_db, _db.catalogProducts);
  $$MediaFilesTableTableManager get mediaFiles =>
      $$MediaFilesTableTableManager(_db, _db.mediaFiles);
  $$ShopMediaTableTableManager get shopMedia =>
      $$ShopMediaTableTableManager(_db, _db.shopMedia);
  $$TelemetrySentTableTableManager get telemetrySent =>
      $$TelemetrySentTableTableManager(_db, _db.telemetrySent);
}
