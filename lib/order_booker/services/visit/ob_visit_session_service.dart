import 'dart:async';

import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/services/local_media_store.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/sync/outbox_payload.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_task_model.dart';

/// Owns the local visit lifecycle so a check-in never needs the network.
///
/// Exactly one visit is active at a time, which is what makes several shops
/// per day safe: each check-in closes cleanly before the next one opens.
class ObVisitSessionService extends GetxService {
  ObVisitSessionService(this._db, this._outbox, this._media);

  final AppDatabase _db;
  final SyncOutboxService _outbox;
  final LocalMediaStore _media;

  static const kindCheckIn = 'check_in';
  static const kindVerifyThenCheckIn = 'verify_then_check_in';

  /// Live active visit for Today Tasks / Dashboard — updated at check-in,
  /// not only after a later network refresh.
  final Rxn<ObActiveVisitModel> activeVisitRx = Rxn<ObActiveVisitModel>();

  /// Task ids whose local visit row is already closed (order / no-sale).
  /// Prevents stale `inVisit` overrides from showing Resume after sync.
  final RxSet<int> closedTaskIds = <int>{}.obs;

  String? get _userId {
    if (!Get.isRegistered<SessionService>()) return null;
    final id = Get.find<SessionService>().user.value?.id;
    return (id == null || id.isEmpty) ? null : id;
  }

  String get _requireUserId => _userId ?? '';

  @override
  void onInit() {
    super.onInit();
    unawaited(refreshLocalVisitIndex());
  }

  /// Seeds active + closed indexes from SQLite.
  Future<void> refreshLocalVisitIndex() async {
    final rows = await allLocalVisits();
    final closed = <int>{};
    for (final row in rows) {
      if (row.status == 'completed') {
        closed.add(row.taskId);
      }
    }
    closedTaskIds
      ..clear()
      ..addAll(closed);
    closedTaskIds.refresh();
    await refreshActiveVisitRx();
  }

  /// Seeds [activeVisitRx] from SQLite (app start / after return).
  Future<void> refreshActiveVisitRx() async {
    activeVisitRx.value = await activeVisit();
  }

  void publishActiveVisit(ObActiveVisitModel visit) {
    closedTaskIds.remove(visit.taskId);
    closedTaskIds.refresh();
    activeVisitRx.value = visit;
  }

  void clearActiveVisitRx() {
    activeVisitRx.value = null;
  }

  bool isLocallyClosedTask(int taskId) => closedTaskIds.contains(taskId);

  // ------------------------------------------------------------ read helpers

  Future<LocalVisit?> activeLocalVisit() =>
      _db.activeLocalVisit(userId: _requireUserId);

  Future<ObActiveVisitModel?> activeVisit() async {
    final row = await _db.activeLocalVisit(userId: _requireUserId);
    if (row == null) return null;
    return toActiveVisit(row);
  }

  ObActiveVisitModel toActiveVisit(LocalVisit row) => ObActiveVisitModel(
    visitId: row.serverVisitId ?? row.localVisitId,
    taskId: row.taskId,
    shopId: row.shopId,
    shopName: row.shopName,
    checkedInAt: row.checkedInAt,
    latitude: row.latitude,
    longitude: row.longitude,
  );

  Future<LocalVisit?> visitByAnyId(int visitId) =>
      _db.localVisitByAnyId(visitId, userId: _requireUserId);

  /// Server id when known, otherwise the negative local id.
  Future<int> effectiveVisitId(int visitId) async {
    if (visitId >= 0) return visitId;
    final mapped = await _db.serverIdFor('visit', visitId);
    return mapped ?? visitId;
  }

  Future<bool> isLocalOnlyVisit(int visitId) async {
    if (visitId >= 0) return false;
    return await _db.serverIdFor('visit', visitId) == null;
  }

  Future<List<LocalVisit>> allLocalVisits() =>
      _db.allLocalVisits(userId: _requireUserId);

  // ---------------------------------------------------------------- check-in

  /// Opens a visit locally and queues `tasks/check-in` at most once.
  Future<ObActiveVisitModel> startVisit({
    required ObTaskModel task,
    required double latitude,
    required double longitude,
  }) async {
    final existing = await _db.localVisitForTask(
      task.id,
      userId: _requireUserId,
    );
    if (existing != null && existing.status == 'active') {
      await setTaskStatus(task.id, TaskStatus.inVisit);
      // Already checked in locally — never enqueue a second check_in.
      if (existing.serverVisitId != null ||
          await _db.openCheckInEntryForVisit(existing.localVisitId) != null) {
        final visit = toActiveVisit(existing);
        publishActiveVisit(visit);
        return visit;
      }
      await _enqueueCheckIn(
        task: task,
        localVisitId: existing.localVisitId,
        latitude: latitude,
        longitude: longitude,
      );
      final visit = toActiveVisit(existing);
      publishActiveVisit(visit);
      return visit;
    }

    final localVisitId = await _openLocalVisit(
      task: task,
      latitude: latitude,
      longitude: longitude,
      kind: kindCheckIn,
    );
    await _enqueueCheckIn(
      task: task,
      localVisitId: localVisitId,
      latitude: latitude,
      longitude: longitude,
    );

    final row = await _db.localVisitById(localVisitId);
    final visit = toActiveVisit(row!);
    publishActiveVisit(visit);
    return visit;
  }

  Future<void> _enqueueCheckIn({
    required ObTaskModel task,
    required int localVisitId,
    required double latitude,
    required double longitude,
  }) async {
    final open = await _db.openCheckInEntryForVisit(localVisitId);
    if (open != null) return;

    await _outbox.enqueue(
      role: 'orderBooker',
      action: 'check_in',
      payload: {
        'task_id': task.id,
        'shop_id': task.shopId,
        'shop_name': task.shopName,
        'latitude': latitude,
        'longitude': longitude,
      },
      entityType: 'visit',
      localEntityId: localVisitId,
      dependsOn: await priorVisitGateEntryId(
        excludingLocalVisitId: localVisitId,
      ),
    );
  }

  /// Server allows one open visit: wait for the previous visit's close when
  /// present, otherwise for its still-open check-in/verify.
  Future<String?> priorVisitGateEntryId({int? excludingLocalVisitId}) async {
    final closing = await _db.latestOpenVisitClosingEntry(
      excludingLocalVisitId: excludingLocalVisitId,
    );
    if (closing != null) return closing.id;

    final opening = await _db.latestOpenVisitOpeningEntry(
      excludingLocalVisitId: excludingLocalVisitId,
    );
    return opening?.id;
  }

  /// Close/order steps wait on this visit's queued check-in (if any).
  Future<String?> checkInGateEntryIdForVisit(int visitId) async {
    final local = await _db.localVisitByAnyId(visitId, userId: _requireUserId);
    if (local == null) return null;
    final entry = await _db.openCheckInEntryForVisit(local.localVisitId);
    return entry?.id;
  }

  /// After a close is queued, any later opening that waited on the check-in
  /// (or verify) must wait on the close instead — otherwise a second check-in
  /// could sync while the first visit is still open on the server.
  Future<void> retargetOpeningsOntoClose({
    required OutboxEntry closeEntry,
    required int localVisitId,
  }) async {
    final fromIds = <String>{
      if (closeEntry.dependsOn != null && closeEntry.dependsOn!.isNotEmpty)
        closeEntry.dependsOn!,
    };
    final checkIn = await _db.openCheckInEntryForVisit(localVisitId);
    if (checkIn != null) {
      fromIds.add(checkIn.id);
      if (checkIn.dependsOn != null && checkIn.dependsOn!.isNotEmpty) {
        fromIds.add(checkIn.dependsOn!);
      }
    }
    await _db.retargetOutboxDependsOn(
      fromIds: fromIds,
      toId: closeEntry.id,
      excludingLocalVisitId: localVisitId,
    );
  }

  /// Records a visit the server just created, so completion, cart and history
  /// read from the same local table whether we were online or not.
  Future<ObActiveVisitModel> adoptServerVisit({
    required ObTaskModel task,
    required ObActiveVisitModel visit,
    double? latitude,
    double? longitude,
  }) async {
    final existing = await _db.localVisitByAnyId(
      visit.visitId,
      userId: _requireUserId,
    );
    final localVisitId = existing?.localVisitId ?? await _db.nextLocalVisitId();
    final now = DateTime.now();

    await _db.upsertLocalVisit(
      LocalVisitsCompanion.insert(
        localVisitId: Value(localVisitId),
        serverVisitId: Value(visit.visitId),
        taskId: task.id,
        shopId: task.shopId,
        shopName: task.shopName,
        latitude: latitude ?? visit.latitude ?? 0,
        longitude: longitude ?? visit.longitude ?? 0,
        checkedInAt: visit.checkedInAt ?? now,
        createdAt: existing?.createdAt ?? now,
        kind: const Value(kindCheckIn),
        status: const Value('active'),
        userId: Value(_userId),
      ),
    );
    await _db.putIdMapping(
      entityType: 'visit',
      localId: localVisitId,
      serverId: visit.visitId,
    );
    await setTaskStatus(task.id, TaskStatus.inVisit);
    publishActiveVisit(visit);
    return visit;
  }

  /// Queues `shops/verify-on-site` and then the check-in that depends on it,
  /// so a `not_visited` shop can be set up with no connectivity at all.
  Future<ObActiveVisitModel> startVerifiedVisit({
    required ObTaskModel task,
    required double latitude,
    required double longitude,
    required int shopId,
    required Map<String, Uint8List> photos,
    Map<String, dynamic> fields = const {},
  }) async {
    final existing = await _db.localVisitForTask(
      task.id,
      userId: _requireUserId,
    );
    if (existing != null && existing.status == 'active') {
      await setTaskStatus(task.id, TaskStatus.inVisit);
      final openCheckIn = await _db.openCheckInEntryForVisit(
        existing.localVisitId,
      );
      if (openCheckIn != null || existing.serverVisitId != null) {
        final visit = toActiveVisit(existing);
        publishActiveVisit(visit);
        return visit;
      }
    }

    final localVisitId = await _openLocalVisit(
      task: task,
      latitude: latitude,
      longitude: longitude,
      kind: kindVerifyThenCheckIn,
    );

    final openCheckIn = await _db.openCheckInEntryForVisit(localVisitId);
    if (openCheckIn != null) {
      final row = await _db.localVisitById(localVisitId);
      final visit = toActiveVisit(row!);
      publishActiveVisit(visit);
      return visit;
    }

    final payload = <String, dynamic>{
      'shop_id': shopId,
      'task_id': task.id,
      'latitude': latitude,
      'longitude': longitude,
      ...fields,
    };
    for (final photo in photos.entries) {
      final mediaId = await _media.save(
        photo.value,
        purpose: 'verify_${photo.key}',
      );
      payload[photo.key] = OutboxPayload.mediaRef(mediaId);
    }

    final verifyEntry = await _outbox.enqueue(
      role: 'orderBooker',
      action: 'verify_on_site',
      payload: payload,
      entityType: 'visit',
      localEntityId: localVisitId,
      dependsOn: await priorVisitGateEntryId(
        excludingLocalVisitId: localVisitId,
      ),
    );

    await _outbox.enqueue(
      role: 'orderBooker',
      action: 'check_in',
      payload: {
        'task_id': task.id,
        'shop_id': task.shopId,
        'shop_name': task.shopName,
        'latitude': latitude,
        'longitude': longitude,
      },
      entityType: 'visit',
      localEntityId: localVisitId,
      dependsOn: verifyEntry.id,
    );

    await setTaskVerified(task.id);
    final row = await _db.localVisitById(localVisitId);
    final visit = toActiveVisit(row!);
    publishActiveVisit(visit);
    return visit;
  }

  Future<int> _openLocalVisit({
    required ObTaskModel task,
    required double latitude,
    required double longitude,
    required String kind,
  }) async {
    // Reuse an already open visit for the same task instead of stacking rows.
    final existing = await _db.localVisitForTask(
      task.id,
      userId: _requireUserId,
    );
    if (existing != null && existing.status == 'active') {
      await setTaskStatus(task.id, TaskStatus.inVisit);
      return existing.localVisitId;
    }

    final localVisitId = await _db.nextLocalVisitId();
    final now = DateTime.now();
    await _db.upsertLocalVisit(
      LocalVisitsCompanion.insert(
        localVisitId: Value(localVisitId),
        taskId: task.id,
        shopId: task.shopId,
        shopName: task.shopName,
        latitude: latitude,
        longitude: longitude,
        checkedInAt: now,
        createdAt: now,
        kind: Value(kind),
        status: const Value('active'),
        userId: Value(_userId),
      ),
    );
    await setTaskStatus(task.id, TaskStatus.inVisit);
    return localVisitId;
  }

  /// Closes the visit locally. Task override is [TaskStatus.completed] so the
  /// list never shows Resume; while the close is still in the outbox the chip
  /// is "will sync" via [SyncOutboxService.isTaskQueuedForSync].
  Future<void> completeVisit({
    required int visitId,
    required String outcome,
    String? orderNumber,
    String? notes,
  }) async {
    final row = await _db.localVisitByAnyId(visitId, userId: _requireUserId);
    if (row == null) return;
    await _db.patchLocalVisit(
      row.localVisitId,
      LocalVisitsCompanion(
        status: const Value('completed'),
        outcome: Value(outcome),
        orderNumber: Value(orderNumber),
        notes: Value(notes ?? row.notes),
        completedAt: Value(DateTime.now()),
      ),
    );
    await setTaskStatus(row.taskId, TaskStatus.completed);
    closedTaskIds.add(row.taskId);
    closedTaskIds.refresh();
    clearActiveVisitRx();
  }

  Future<LocalVisit?> otherActiveVisit(int taskId) async {
    final active = await _db.activeLocalVisit(userId: _requireUserId);
    if (active == null) return null;
    if (active.taskId == taskId) return null;
    return active;
  }

  // --------------------------------------------------------- task overrides

  Future<void> setTaskStatus(int taskId, TaskStatus status) async {
    await _db.upsertTaskOverride(
      LocalTaskOverridesCompanion.insert(
        taskId: Value(taskId),
        status: Value(status.name),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> setTaskNotes(int taskId, String notes) async {
    await _db.upsertTaskOverride(
      LocalTaskOverridesCompanion.insert(
        taskId: Value(taskId),
        notes: Value(notes),
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Local shop setup is done, so the task stops asking for verification.
  Future<void> setTaskVerified(int taskId) async {
    await _db.upsertTaskOverride(
      LocalTaskOverridesCompanion.insert(
        taskId: Value(taskId),
        needsShopSetup: const Value(false),
        fieldVerified: const Value(true),
        visitTag: const Value('visited'),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<Map<int, LocalTaskOverride>> overridesByTaskId() async {
    final rows = await _db.taskOverrides();
    return {for (final row in rows) row.taskId: row};
  }
}
