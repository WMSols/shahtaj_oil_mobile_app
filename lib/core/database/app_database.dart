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

@DriftDatabase(tables: [OutboxEntries, VisitCartLines, VisitProducts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  /// Local outbox/cart cache only. Explicit strategy so opening an existing
  /// DB (or rolling back after a higher-schema test build) does not crash.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from > to) {
        // Downgrade (e.g. after testing a higher-schema build): wipe local
        // tables and recreate current schema. Safe for outbox/cart cache.
        for (final table in allTables) {
          await m.deleteTable(table.actualTableName);
        }
        await m.createAll();
        return;
      }
      // Upgrade to v1 baseline — create any missing tables.
      if (from < 1) {
        await m.createAll();
      }
    },
  );

  /// Statuses shown in Sync Center and counted on the shell badge.
  static const _openOutboxStatuses = ['queued', 'failed', 'needsReview'];

  Future<List<OutboxEntry>> pendingOutbox() =>
      (select(outboxEntries)
            ..where((t) => t.status.isIn(_openOutboxStatuses))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<int> pendingOutboxCount() async {
    final rows = await pendingOutbox();
    return rows.length;
  }

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

  Future<void> clearVisitLocalData() async {
    await transaction(() async {
      await delete(visitCartLines).go();
      await delete(visitProducts).go();
    });
  }

  Future<void> clearOutbox() => delete(outboxEntries).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'shahtaj_local.db'));
    return NativeDatabase.createInBackground(file);
  });
}
