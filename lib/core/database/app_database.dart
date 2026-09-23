import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class OutboxEntries extends Table {
  TextColumn get id => text()();
  TextColumn get role => text()();
  TextColumn get action => text()();
  TextColumn get payloadJson => text()();
  TextColumn get clientRequestId => text()();
  TextColumn get status => text().withDefault(const Constant('queued'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  /// Outbox id this entry must wait for (verify-on-site before check-in).
  TextColumn get dependsOn => text().nullable()();

  /// Owner of the queued work. Flush only runs entries for the signed-in user.
  TextColumn get userId => text().nullable()();

  /// Local record this entry creates on the server (`visit` / `shop`).
  TextColumn get entityType => text().nullable()();
  IntColumn get localEntityId => integer().nullable()();

  /// Comma separated [MediaFiles] ids referenced by the payload.
  TextColumn get mediaIds => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class VisitCartLines extends Table {
  IntColumn get visitId => integer()();
  IntColumn get lineId => integer()();
  IntColumn get productId => integer()();
  TextColumn get productName => text()();
  RealColumn get quantity => real()();
  RealColumn get priceUnit => real()();
  TextColumn get unit => text().nullable()();
  BoolColumn get isLocalOnly => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {visitId, lineId};
}

class VisitProducts extends Table {
  IntColumn get visitId => integer()();
  IntColumn get productId => integer()();
  TextColumn get jsonPayload => text()();

  @override
  Set<Column<Object>> get primaryKey => {visitId, productId};
}

/// Local negative id to server id translation for anything created offline.
class IdMappings extends Table {
  TextColumn get entityType => text()();
  IntColumn get localId => integer()();
  IntColumn get serverId => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {entityType, localId};
}

/// One row per check-in. [localVisitId] is negative until the server replies.
class LocalVisits extends Table {
  IntColumn get localVisitId => integer()();
  IntColumn get serverVisitId => integer().nullable()();
  IntColumn get taskId => integer()();
  TextColumn get shopId => text()();
  TextColumn get shopName => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get checkedInAt => dateTime()();

  /// `check_in` or `verify_then_check_in`.
  TextColumn get kind => text().withDefault(const Constant('check_in'))();

  /// `active` or `completed`.
  TextColumn get status => text().withDefault(const Constant('active'))();

  /// `order_placed` or `ended_without_order`.
  TextColumn get outcome => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get orderNumber => text().nullable()();
  RealColumn get subtotal => real().nullable()();

  /// True while place-order / end-visit is still waiting to sync.
  BoolColumn get pendingSync => boolean().withDefault(const Constant(false))();

  TextColumn get approvalState => text().nullable()();
  TextColumn get userId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {localVisitId};
}

/// Shops registered offline. Not visitable until [serverShopId] is known.
class LocalShops extends Table {
  IntColumn get localShopId => integer()();
  IntColumn get serverShopId => integer().nullable()();
  TextColumn get name => text()();
  TextColumn get ownerName => text().nullable()();
  TextColumn get ownerPhone => text().nullable()();
  TextColumn get ownerCnic => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get shopCategory => text().nullable()();
  TextColumn get payloadJson => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get userId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {localShopId};
}

/// Local edits layered on top of the server task snapshot.
class LocalTaskOverrides extends Table {
  IntColumn get taskId => integer()();
  TextColumn get status => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get visitTag => text().nullable()();
  BoolColumn get needsShopSetup => boolean().nullable()();
  BoolColumn get fieldVerified => boolean().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {taskId};
}

/// Generic offline snapshot store for API payloads (tasks, shops, visits...).
class CachedDocs extends Table {
  TextColumn get key => text()();
  TextColumn get jsonPayload => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Product catalog. `scope` is `global` today; per-shop scopes stay possible.
class CatalogProducts extends Table {
  TextColumn get scope => text().withDefault(const Constant('global'))();
  IntColumn get productId => integer()();
  TextColumn get jsonPayload => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {scope, productId};
}

/// Durable order lines for History / Order detail after cart is cleared.
class VisitOrderLines extends Table {
  IntColumn get visitId => integer()();
  IntColumn get lineId => integer()();
  IntColumn get productId => integer()();
  TextColumn get productName => text()();
  RealColumn get quantity => real()();
  RealColumn get priceUnit => real()();
  TextColumn get unit => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {visitId, lineId};
}

/// Verification photos for a shop (paths live in [MediaFiles]).
@DataClassName('ShopMediaRow')
class ShopMedia extends Table {
  TextColumn get shopId => text()();
  TextColumn get slot => text()();
  TextColumn get mediaId => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {shopId, slot};
}

/// App-side dedupe for silent telemetry (blocked GPS) already sent today.
class TelemetrySent extends Table {
  TextColumn get clientRequestId => text()();
  DateTimeColumn get sentAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {clientRequestId};
}

/// Photos captured offline. Files live on disk; only paths are stored here.
class MediaFiles extends Table {
  TextColumn get id => text()();
  TextColumn get path => text()();
  TextColumn get purpose => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    OutboxEntries,
    VisitCartLines,
    VisitProducts,
    VisitOrderLines,
    IdMappings,
    LocalVisits,
    LocalShops,
    LocalTaskOverrides,
    CachedDocs,
    CatalogProducts,
    MediaFiles,
    ShopMedia,
    TelemetrySent,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  /// Devices already carry queued orders in v1, so upgrades must be additive.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(idMappings);
        await m.createTable(localVisits);
        await m.createTable(localShops);
        await m.createTable(localTaskOverrides);
        await m.createTable(cachedDocs);
        await m.createTable(catalogProducts);
        await m.createTable(mediaFiles);
        await m.addColumn(outboxEntries, outboxEntries.dependsOn);
        await m.addColumn(outboxEntries, outboxEntries.userId);
        await m.addColumn(outboxEntries, outboxEntries.entityType);
        await m.addColumn(outboxEntries, outboxEntries.localEntityId);
        await m.addColumn(outboxEntries, outboxEntries.mediaIds);
      }
      if (from < 3) {
        await m.createTable(visitOrderLines);
        await m.createTable(shopMedia);
        await m.createTable(telemetrySent);
        await m.addColumn(localVisits, localVisits.subtotal);
        await m.addColumn(localVisits, localVisits.pendingSync);
        await m.addColumn(localVisits, localVisits.approvalState);
      }
    },
  );

  // ---------------------------------------------------------------- outbox

  static const _pendingStatuses = ['queued', 'failed', 'blocked'];
  static const _openStatuses = ['queued', 'failed', 'blocked', 'needsReview'];

  Future<List<OutboxEntry>> pendingOutbox() =>
      (select(outboxEntries)
            ..where((t) => t.status.isIn(_pendingStatuses))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<List<OutboxEntry>> openOutbox() =>
      (select(outboxEntries)
            ..where((t) => t.status.isIn(_openStatuses))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<int> pendingOutboxCount() async {
    final rows = await (select(
      outboxEntries,
    )..where((t) => t.status.isIn(_openStatuses))).get();
    return rows.length;
  }

  Future<OutboxEntry?> outboxById(String id) =>
      (select(outboxEntries)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<OutboxEntry?> outboxByClientRequestId(String clientRequestId) =>
      (select(outboxEntries)
            ..where((t) => t.clientRequestId.equals(clientRequestId))
            ..limit(1))
          .getSingleOrNull();

  static const visitClosingActions = [
    'submit_order',
    'end_visit_without_order',
  ];

  static const visitOpeningActions = ['verify_on_site', 'check_in'];

  /// Newest unsynced entry that closes a visit on the server.
  ///
  /// The next check-in must wait for it, because the API allows only one open
  /// visit at a time. Without this, a day of offline shops could be rejected
  /// as "visit already in progress".
  Future<OutboxEntry?> latestOpenVisitClosingEntry({
    int? excludingLocalVisitId,
  }) async {
    final rows =
        await (select(outboxEntries)
              ..where(
                (t) =>
                    t.action.isIn(visitClosingActions) &
                    t.status.equals('synced').not(),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    for (final row in rows) {
      if (excludingLocalVisitId != null &&
          row.localEntityId == excludingLocalVisitId) {
        continue;
      }
      return row;
    }
    return null;
  }

  /// Newest unsynced verify/check-in (used when a prior visit has no close yet).
  Future<OutboxEntry?> latestOpenVisitOpeningEntry({
    int? excludingLocalVisitId,
  }) async {
    final rows =
        await (select(outboxEntries)
              ..where(
                (t) =>
                    t.action.isIn(visitOpeningActions) &
                    t.status.equals('synced').not(),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    for (final row in rows) {
      if (excludingLocalVisitId != null &&
          row.localEntityId == excludingLocalVisitId) {
        continue;
      }
      return row;
    }
    return null;
  }

  /// Unsynced check-in for a local visit (close steps depend on this).
  Future<OutboxEntry?> openCheckInEntryForVisit(int localVisitId) =>
      (select(outboxEntries)
            ..where(
              (t) =>
                  t.localEntityId.equals(localVisitId) &
                  t.action.equals('check_in') &
                  t.status.equals('synced').not(),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(1))
          .getSingleOrNull();

  /// Points later openings that waited on [fromIds] at [toId] instead
  /// (e.g. after a close is queued, next check-ins must wait on the close).
  Future<void> retargetOutboxDependsOn({
    required Set<String> fromIds,
    required String toId,
    int? excludingLocalVisitId,
    List<String> onlyActions = visitOpeningActions,
  }) async {
    if (fromIds.isEmpty) return;
    final open = await (select(
      outboxEntries,
    )..where((t) => t.status.equals('synced').not())).get();
    for (final entry in open) {
      if (entry.id == toId) continue;
      if (excludingLocalVisitId != null &&
          entry.localEntityId == excludingLocalVisitId) {
        continue;
      }
      if (!onlyActions.contains(entry.action)) continue;
      final dep = entry.dependsOn;
      if (dep == null || !fromIds.contains(dep)) continue;
      await (update(outboxEntries)..where((t) => t.id.equals(entry.id))).write(
        OutboxEntriesCompanion(dependsOn: Value(toId)),
      );
    }
  }

  // ------------------------------------------------------------ cart lines

  Future<void> upsertCartLine(VisitCartLinesCompanion row) =>
      into(visitCartLines).insertOnConflictUpdate(row);

  Future<List<VisitCartLine>> linesForVisit(int visitId) =>
      (select(visitCartLines)..where((t) => t.visitId.equals(visitId))).get();

  Future<void> deleteCartLine({required int visitId, required int lineId}) =>
      (delete(visitCartLines)
            ..where((t) => t.visitId.equals(visitId) & t.lineId.equals(lineId)))
          .go();

  Future<void> clearVisitCart(int visitId) =>
      (delete(visitCartLines)..where((t) => t.visitId.equals(visitId))).go();

  Future<void> clearVisitProducts(int visitId) =>
      (delete(visitProducts)..where((t) => t.visitId.equals(visitId))).go();

  Future<void> deleteLocalVisit(int localVisitId) => (delete(
    localVisits,
  )..where((t) => t.localVisitId.equals(localVisitId))).go();

  /// Keeps one row per product after remap / failed sync left duplicates.
  /// Prefers server line ids (`> 0`); quantity is the max across copies
  /// (sync retries usually duplicate the same qty, so summing would inflate).
  Future<void> dedupeVisitCartLines(int visitId) async {
    final rows = await linesForVisit(visitId);
    if (rows.length < 2) return;

    final byProduct = <int, List<VisitCartLine>>{};
    for (final row in rows) {
      (byProduct[row.productId] ??= <VisitCartLine>[]).add(row);
    }

    for (final group in byProduct.values) {
      if (group.length < 2) continue;
      group.sort((a, b) {
        final aServer = a.lineId > 0 ? 1 : 0;
        final bServer = b.lineId > 0 ? 1 : 0;
        if (aServer != bServer) return bServer.compareTo(aServer);
        return b.lineId.compareTo(a.lineId);
      });
      final keeper = group.first;
      var qty = keeper.quantity;
      for (final extra in group.skip(1)) {
        if (extra.quantity > qty) qty = extra.quantity;
        await deleteCartLine(visitId: visitId, lineId: extra.lineId);
      }
      if ((qty - keeper.quantity).abs() > 0.001) {
        await upsertCartLine(
          VisitCartLinesCompanion.insert(
            visitId: keeper.visitId,
            lineId: keeper.lineId,
            productId: keeper.productId,
            productName: keeper.productName,
            quantity: qty,
            priceUnit: keeper.priceUnit,
            unit: Value(keeper.unit),
            isLocalOnly: Value(keeper.isLocalOnly),
          ),
        );
      }
    }
  }

  /// Moves locally captured rows onto the server visit id after check-in syncs.
  Future<void> remapVisitLocalData({
    required int localVisitId,
    required int serverVisitId,
  }) async {
    if (localVisitId == serverVisitId) return;
    await transaction(() async {
      // OR REPLACE keeps the local rows if the server visit somehow already
      // has a row with the same primary key.
      await customUpdate(
        'UPDATE OR REPLACE visit_cart_lines SET visit_id = ? WHERE visit_id = ?',
        variables: [
          Variable.withInt(serverVisitId),
          Variable.withInt(localVisitId),
        ],
        updates: {visitCartLines},
      );
      await customUpdate(
        'UPDATE OR REPLACE visit_products SET visit_id = ? WHERE visit_id = ?',
        variables: [
          Variable.withInt(serverVisitId),
          Variable.withInt(localVisitId),
        ],
        updates: {visitProducts},
      );
      await customUpdate(
        'UPDATE OR REPLACE visit_order_lines SET visit_id = ? WHERE visit_id = ?',
        variables: [
          Variable.withInt(serverVisitId),
          Variable.withInt(localVisitId),
        ],
        updates: {visitOrderLines},
      );
    });
    await dedupeVisitCartLines(serverVisitId);
  }

  Future<void> replaceProductsForVisit(
    int visitId,
    List<VisitProductsCompanion> rows,
  ) async {
    await transaction(() async {
      await (delete(
        visitProducts,
      )..where((t) => t.visitId.equals(visitId))).go();
      if (rows.isNotEmpty) {
        await batch((b) => b.insertAll(visitProducts, rows));
      }
    });
  }

  Future<List<VisitProduct>> productsForVisit(int visitId) =>
      (select(visitProducts)..where((t) => t.visitId.equals(visitId))).get();

  Future<List<VisitOrderLine>> orderLinesForVisit(int visitId) =>
      (select(visitOrderLines)..where((t) => t.visitId.equals(visitId))).get();

  Future<void> replaceOrderLinesForVisit(
    int visitId,
    List<VisitOrderLinesCompanion> rows,
  ) async {
    await transaction(() async {
      await (delete(
        visitOrderLines,
      )..where((t) => t.visitId.equals(visitId))).go();
      if (rows.isNotEmpty) {
        await batch((b) => b.insertAll(visitOrderLines, rows));
      }
    });
  }

  Future<void> upsertShopMedia({
    required String shopId,
    required String slot,
    required String mediaId,
  }) => into(shopMedia).insertOnConflictUpdate(
    ShopMediaCompanion.insert(
      shopId: shopId,
      slot: slot,
      mediaId: mediaId,
      updatedAt: DateTime.now(),
    ),
  );

  Future<List<ShopMediaRow>> shopMediaFor(String shopId) =>
      (select(shopMedia)..where((t) => t.shopId.equals(shopId))).get();

  Future<ShopMediaRow?> shopMediaSlot(String shopId, String slot) =>
      (select(shopMedia)
            ..where((t) => t.shopId.equals(shopId) & t.slot.equals(slot)))
          .getSingleOrNull();

  Future<bool> hasTelemetrySent(String clientRequestId) async {
    final row =
        await (select(telemetrySent)
              ..where((t) => t.clientRequestId.equals(clientRequestId)))
            .getSingleOrNull();
    return row != null;
  }

  Future<void> markTelemetrySent(String clientRequestId) =>
      into(telemetrySent).insertOnConflictUpdate(
        TelemetrySentCompanion.insert(
          clientRequestId: clientRequestId,
          sentAt: DateTime.now(),
        ),
      );

  Future<void> deleteOutboxByClientRequestId(String clientRequestId) => (delete(
    outboxEntries,
  )..where((t) => t.clientRequestId.equals(clientRequestId))).go();

  // ----------------------------------------------------------- id mappings

  Future<int?> serverIdFor(String entityType, int localId) async {
    final row =
        await (select(idMappings)..where(
              (t) =>
                  t.entityType.equals(entityType) & t.localId.equals(localId),
            ))
            .getSingleOrNull();
    return row?.serverId;
  }

  Future<void> putIdMapping({
    required String entityType,
    required int localId,
    required int serverId,
  }) => into(idMappings).insertOnConflictUpdate(
    IdMappingsCompanion.insert(
      entityType: entityType,
      localId: localId,
      serverId: serverId,
      createdAt: DateTime.now(),
    ),
  );

  // ---------------------------------------------------------- local visits

  Future<int> nextLocalVisitId() async {
    final row =
        await (select(localVisits)
              ..orderBy([(t) => OrderingTerm.asc(t.localVisitId)])
              ..limit(1))
            .getSingleOrNull();
    final lowest = row?.localVisitId ?? 0;
    return lowest <= 0 ? lowest - 1 : -1;
  }

  Future<void> upsertLocalVisit(LocalVisitsCompanion row) =>
      into(localVisits).insertOnConflictUpdate(row);

  Future<void> patchLocalVisit(int localVisitId, LocalVisitsCompanion row) =>
      (update(
        localVisits,
      )..where((t) => t.localVisitId.equals(localVisitId))).write(row);

  Future<LocalVisit?> localVisitById(int localVisitId) => (select(
    localVisits,
  )..where((t) => t.localVisitId.equals(localVisitId))).getSingleOrNull();

  Future<LocalVisit?> localVisitByAnyId(int visitId, {String? userId}) async {
    final byLocal = await localVisitById(visitId);
    final row =
        byLocal ??
        await (select(
          localVisits,
        )..where((t) => t.serverVisitId.equals(visitId))).getSingleOrNull();
    if (row == null) return null;
    if (userId != null &&
        userId.isNotEmpty &&
        row.userId != null &&
        row.userId != userId) {
      return null;
    }
    return row;
  }

  /// Active visit for [userId] only — never another booker on this device.
  Future<LocalVisit?> activeLocalVisit({required String userId}) {
    if (userId.isEmpty) return Future.value(null);
    return (select(localVisits)
          ..where((t) => t.status.equals('active') & t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.checkedInAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<LocalVisit?> localVisitForTask(int taskId, {required String userId}) {
    if (userId.isEmpty) return Future.value(null);
    return (select(localVisits)
          ..where((t) => t.taskId.equals(taskId) & t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.checkedInAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<LocalVisit>> allLocalVisits({required String userId}) {
    if (userId.isEmpty) return Future.value(const []);
    return (select(localVisits)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.checkedInAt)]))
        .get();
  }

  // ----------------------------------------------------------- local shops

  Future<int> nextLocalShopId() async {
    final row =
        await (select(localShops)
              ..orderBy([(t) => OrderingTerm.asc(t.localShopId)])
              ..limit(1))
            .getSingleOrNull();
    final lowest = row?.localShopId ?? 0;
    return lowest <= 0 ? lowest - 1 : -1;
  }

  Future<void> upsertLocalShop(LocalShopsCompanion row) =>
      into(localShops).insertOnConflictUpdate(row);

  Future<void> patchLocalShop(int localShopId, LocalShopsCompanion row) =>
      (update(
        localShops,
      )..where((t) => t.localShopId.equals(localShopId))).write(row);

  Future<List<LocalShop>> allLocalShops({required String userId}) {
    if (userId.isEmpty) return Future.value(const []);
    return (select(localShops)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<LocalShop?> localShopById(int localShopId, {String? userId}) async {
    final row = await (select(
      localShops,
    )..where((t) => t.localShopId.equals(localShopId))).getSingleOrNull();
    if (row == null) return null;
    if (userId != null &&
        userId.isNotEmpty &&
        row.userId != null &&
        row.userId != userId) {
      return null;
    }
    return row;
  }

  // ------------------------------------------------------- task overrides

  Future<void> upsertTaskOverride(LocalTaskOverridesCompanion row) =>
      into(localTaskOverrides).insertOnConflictUpdate(row);

  Future<List<LocalTaskOverride>> taskOverrides() =>
      select(localTaskOverrides).get();

  Future<void> clearTaskOverrides() => delete(localTaskOverrides).go();

  /// Rows written before ownership tracking get stamped to [userId] so they
  /// never silently attach to the next booker on this device.
  Future<void> claimOrphanLocalOwnership(String userId) async {
    if (userId.isEmpty) return;
    await transaction(() async {
      await (update(localVisits)..where((t) => t.userId.isNull())).write(
        LocalVisitsCompanion(userId: Value(userId)),
      );
      await (update(localShops)..where((t) => t.userId.isNull())).write(
        LocalShopsCompanion(userId: Value(userId)),
      );
      await (update(outboxEntries)..where((t) => t.userId.isNull())).write(
        OutboxEntriesCompanion(userId: Value(userId)),
      );
    });
  }

  Future<LocalTaskOverride?> taskOverrideFor(int taskId) => (select(
    localTaskOverrides,
  )..where((t) => t.taskId.equals(taskId))).getSingleOrNull();

  Future<void> clearTaskOverride(int taskId) =>
      (delete(localTaskOverrides)..where((t) => t.taskId.equals(taskId))).go();

  // ---------------------------------------------------------- cached docs

  Future<void> saveDoc(String key, String jsonPayload) =>
      into(cachedDocs).insertOnConflictUpdate(
        CachedDocsCompanion.insert(
          key: key,
          jsonPayload: jsonPayload,
          updatedAt: DateTime.now(),
        ),
      );

  Future<CachedDoc?> readDoc(String key) =>
      (select(cachedDocs)..where((t) => t.key.equals(key))).getSingleOrNull();

  Future<void> deleteDoc(String key) =>
      (delete(cachedDocs)..where((t) => t.key.equals(key))).go();

  Future<void> deleteDocsWithPrefix(String prefix) =>
      (delete(cachedDocs)..where((t) => t.key.like('$prefix%'))).go();

  // ------------------------------------------------------------- catalog

  Future<void> replaceCatalog(
    String scope,
    List<CatalogProductsCompanion> rows,
  ) async {
    await transaction(() async {
      await (delete(catalogProducts)..where((t) => t.scope.equals(scope))).go();
      if (rows.isNotEmpty) {
        await batch((b) => b.insertAll(catalogProducts, rows));
      }
    });
  }

  Future<List<CatalogProduct>> catalogFor(String scope) =>
      (select(catalogProducts)..where((t) => t.scope.equals(scope))).get();

  // --------------------------------------------------------------- media

  Future<void> insertMedia(MediaFilesCompanion row) =>
      into(mediaFiles).insertOnConflictUpdate(row);

  Future<MediaFile?> mediaById(String id) =>
      (select(mediaFiles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> deleteMedia(Iterable<String> ids) async {
    if (ids.isEmpty) return;
    await (delete(mediaFiles)..where((t) => t.id.isIn(ids))).go();
  }

  // --------------------------------------------------------------- resets

  Future<void> clearVisitLocalData() async {
    await transaction(() async {
      await delete(visitCartLines).go();
      await delete(visitProducts).go();
      await delete(visitOrderLines).go();
    });
  }

  Future<void> clearOutbox() => delete(outboxEntries).go();

  Future<void> deleteOutboxEntry(String id) =>
      (delete(outboxEntries)..where((t) => t.id.equals(id))).go();

  /// Explicit "clear local data" action. Never runs on logout.
  Future<void> clearAllLocalWork() async {
    await transaction(() async {
      await delete(outboxEntries).go();
      await delete(visitCartLines).go();
      await delete(visitProducts).go();
      await delete(visitOrderLines).go();
      await delete(localVisits).go();
      await delete(localShops).go();
      await delete(localTaskOverrides).go();
      await delete(idMappings).go();
      await delete(mediaFiles).go();
      await delete(shopMedia).go();
      await delete(telemetrySent).go();
    });
  }

  /// Snapshot-only reset, keeps queued work and local records intact.
  Future<void> clearSnapshots() async {
    await transaction(() async {
      await delete(cachedDocs).go();
      await delete(catalogProducts).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'shahtaj_local.db'));
    return NativeDatabase.createInBackground(file);
  });
}
