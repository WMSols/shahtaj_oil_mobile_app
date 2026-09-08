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
          ..write('syncedAt: $syncedAt')
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
          other.syncedAt == this.syncedAt);
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final $VisitCartLinesTable visitCartLines = $VisitCartLinesTable(this);
  late final $VisitProductsTable visitProducts = $VisitProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    outboxEntries,
    visitCartLines,
    visitProducts,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
  $$VisitCartLinesTableTableManager get visitCartLines =>
      $$VisitCartLinesTableTableManager(_db, _db.visitCartLines);
  $$VisitProductsTableTableManager get visitProducts =>
      $$VisitProductsTableTableManager(_db, _db.visitProducts);
}
