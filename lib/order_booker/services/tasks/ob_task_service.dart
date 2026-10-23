import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:get/get.dart' hide Value;

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/session_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_check_in_result.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/schedule/ob_route_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_missing_field.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_today_tasks_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/shops/ob_shop_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_session_service.dart';

class ObTaskService extends GetxService {
  ObTaskService(this._api, {OfflineCacheService? cache})
    : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final OfflineCacheService _cache;

  List<ObTaskModel> _tasks = const [];
  ObRouteModel? _route;
  ObActiveVisitModel? _activeVisit;

  ObVisitSessionService? get _session =>
      Get.isRegistered<ObVisitSessionService>()
      ? Get.find<ObVisitSessionService>()
      : null;

  SyncOutboxService? get _outbox => Get.isRegistered<SyncOutboxService>()
      ? Get.find<SyncOutboxService>()
      : null;

  /// Reads the day snapshot, then layers local check-ins and notes on top so
  /// the list is correct with no connectivity at all.
  Future<ObTodayTasksModel> fetchTodayTasks({
    bool allowStaleFallback = true,
    bool forceNetwork = false,
  }) async {
    // List APIs often omit notes — keep any we already showed / saved locally.
    final priorNotes = <int, String>{
      for (final task in _tasks)
        if ((task.notes ?? '').trim().isNotEmpty) task.id: task.notes!.trim(),
    };
    final clearedNoteIds = await _session?.taskIdsWithClearedNotes() ?? {};
    final today = await _cache.readThrough(
      key: OfflineCacheKeys.tasksToday,
      fetch: () => _api.postData(ApiEndpoints.obTasksToday),
      parse: (data) {
        _seedShopsFromTasks(data);
        return ObTodayTasksModel.fromJson(data);
      },
      allowStaleFallback: allowStaleFallback,
      cacheFirst: _cache.cacheFirstFor(
        allowStaleFallback: allowStaleFallback,
        forceNetwork: forceNetwork,
      ),
    );
    final merged = _preserveNotesFromPrior(
      await _withLocalState(today),
      priorNotes,
      clearedNoteIds: clearedNoteIds,
    );
    await _persistNotesIntoTodayCache(merged);
    return _applyToday(merged);
  }

  /// `override.notes == ''` means cleared; `null` means no notes override.
  static String? _resolveLocalNotes({
    required String? overrideNotes,
    required String? taskNotes,
    required String? visitNotes,
  }) {
    if (overrideNotes != null) {
      final trimmed = overrideNotes.trim();
      return trimmed.isEmpty ? null : overrideNotes;
    }
    if ((taskNotes ?? '').trim().isNotEmpty) return taskNotes;
    return visitNotes;
  }

  void _seedShopsFromTasks(Map<String, dynamic> data) {
    if (!Get.isRegistered<ObShopService>()) return;
    Get.find<ObShopService>().rememberShopsFromTasksPayload(data);
  }

  ObTodayTasksModel _applyToday(ObTodayTasksModel today) {
    _route = today.route;
    _tasks = List<ObTaskModel>.from(today.tasks);
    final gps = today.gpsCriteria;
    if (gps != null && Get.isRegistered<SessionService>()) {
      unawaited(Get.find<SessionService>().setGpsCriteria(gps));
    }
    return today;
  }

  static int _statusRank(TaskStatus status) => switch (status) {
    TaskStatus.pending => 0,
    TaskStatus.inVisit => 1,
    TaskStatus.completed => 2,
  };

  /// A visit never moves backwards within a day, so the further-along of
  /// server state and local state always wins — except a local "completed"
  /// with nothing left in the outbox, which would fake a server completion.
  Future<ObTodayTasksModel> _withLocalState(ObTodayTasksModel today) async {
    final session = _session;
    if (session == null || today.tasks.isEmpty) return today;

    final overrides = await session.overridesByTaskId();
    final visitNotesByTask = await session.visitNotesByTaskId();

    if (overrides.isEmpty && visitNotesByTask.isEmpty) return today;

    final merged = <ObTaskModel>[];
    for (final task in today.tasks) {
      final override = overrides[task.id];
      final visitNotes = visitNotesByTask[task.id];

      if (override == null) {
        final notes = (task.notes ?? '').trim().isNotEmpty
            ? task.notes
            : visitNotes;
        merged.add(
          notes == null || notes == task.notes
              ? task
              : task.copyWith(notes: notes),
        );
        continue;
      }

      final localStatus = _parseOverrideStatus(override.status);
      final serverRank = _statusRank(task.status);
      final localRank = localStatus == null ? -1 : _statusRank(localStatus);
      final hasQueue = _outbox?.hasQueuedWorkForTask(task.id) ?? false;

      // The server has caught up, so the local hint is no longer needed.
      if (localRank >= 0 && serverRank >= localRank) {
        await _dropStaleOverride(override, task);
      }

      // Local completed wins over server pending once the close is queued or
      // the local visit row is closed — never leave a fake inVisit after sync.
      // On a forced network refresh, drop stale closed markers when the server
      // says pending again and nothing is left in the outbox (distributor undo).
      var status = task.status;
      if (localRank > serverRank && localStatus != null) {
        final hasClosingQueue = _outbox?.isTaskQueuedForSync(task.id) ?? false;
        final fakeCompleted =
            localStatus == TaskStatus.completed &&
            task.status != TaskStatus.completed &&
            !hasClosingQueue;
        final locallyClosed =
            Get.isRegistered<ObVisitSessionService>() &&
            Get.find<ObVisitSessionService>().isLocallyClosedTask(task.id);
        if (fakeCompleted) {
          // Server still pending and no place-order/end in outbox
          // (e.g. distributor undo / route reset).
          if (locallyClosed) {
            Get.find<ObVisitSessionService>().forgetClosedTask(task.id);
          }
          await _dropStaleOverride(override, task, forceStatus: true);
          // Keep server status (pending), do not force completed.
        } else if (locallyClosed || hasClosingQueue) {
          status = TaskStatus.completed;
        } else {
          status = localStatus;
        }
      }

      // While place-order / end-visit is still queued, surface as waiting to sync
      // (display layer maps that to Completed + will-sync chip).
      if (hasQueue &&
          (_outbox?.isTaskQueuedForSync(task.id) ?? false) &&
          status != TaskStatus.completed) {
        status = TaskStatus.completed;
      }

      final resolvedNotes = _resolveLocalNotes(
        overrideNotes: override.notes,
        taskNotes: task.notes,
        visitNotes: visitNotes,
      );

      merged.add(
        task.copyWith(
          status: status,
          notes: resolvedNotes,
          needsShopSetup: override.needsShopSetup == false
              ? false
              : task.needsShopSetup,
          fieldVerified: override.fieldVerified ?? task.fieldVerified,
          visitTag: override.visitTag == 'visited'
              ? ShopVisitTag.visited
              : task.visitTag,
          missingFields: override.needsShopSetup == false
              ? const <ObShopMissingField>[]
              : task.missingFields,
        ),
      );
    }

    return today.copyWith(tasks: merged);
  }

  Future<void> _dropStaleOverride(
    LocalTaskOverride override,
    ObTaskModel task, {
    bool forceStatus = false,
  }) async {
    // Keep the row while place-order / end-visit is still queued.
    final outbox = _outbox;
    if (outbox != null && outbox.isTaskQueuedForSync(task.id)) return;
    if (!forceStatus &&
        outbox != null &&
        outbox.hasQueuedWorkForTask(task.id)) {
      return;
    }
    final localNotes = override.notes?.trim();
    final serverNotes = task.notes?.trim();
    final notesExplicitlyCleared =
        override.notes != null && (localNotes == null || localNotes.isEmpty);
    final notesStillLocalOnly =
        localNotes != null &&
        localNotes.isNotEmpty &&
        localNotes != serverNotes;
    // Keep notes (or an explicit clear) while the list API still disagrees.
    if (notesStillLocalOnly || notesExplicitlyCleared) {
      if (!Get.isRegistered<AppDatabase>()) return;
      final db = Get.find<AppDatabase>();
      if (forceStatus ||
          (override.status != null && override.status!.isNotEmpty)) {
        await db.upsertTaskOverride(
          LocalTaskOverridesCompanion(
            taskId: Value(task.id),
            status: const Value(null),
            notes: Value(notesExplicitlyCleared ? '' : localNotes),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
      return;
    }
    if (!Get.isRegistered<AppDatabase>()) return;
    await Get.find<AppDatabase>().clearTaskOverride(task.id);
  }

  /// List payloads frequently omit notes; keep what we already know.
  ObTodayTasksModel _preserveNotesFromPrior(
    ObTodayTasksModel next,
    Map<int, String> priorNotes, {
    Set<int> clearedNoteIds = const {},
  }) {
    if (priorNotes.isEmpty) return next;
    var changed = false;
    final tasks = next.tasks
        .map((task) {
          if (clearedNoteIds.contains(task.id)) {
            if ((task.notes ?? '').trim().isEmpty) return task;
            changed = true;
            return task.copyWith(notes: null);
          }
          if ((task.notes ?? '').trim().isNotEmpty) return task;
          final prior = priorNotes[task.id];
          if (prior == null || prior.isEmpty) return task;
          changed = true;
          return task.copyWith(notes: prior);
        })
        .toList(growable: false);
    return changed ? next.copyWith(tasks: tasks) : next;
  }

  /// Re-inject notes into the disk snapshot after a network refresh that
  /// omitted them, so the next cold read still shows the preview.
  Future<void> _persistNotesIntoTodayCache(ObTodayTasksModel today) async {
    final withNotes = today.tasks
        .where((t) => (t.notes ?? '').trim().isNotEmpty)
        .toList(growable: false);
    if (withNotes.isEmpty) return;

    final cached = await _cache.readMap(OfflineCacheKeys.tasksToday);
    if (cached == null) return;
    final rawTasks = cached['tasks'];
    if (rawTasks is! List) return;

    final byId = {for (final task in withNotes) task.id: task.notes!.trim()};
    var changed = false;
    final updated = rawTasks
        .map((raw) {
          if (raw is! Map) return raw;
          final map = Map<String, dynamic>.from(raw);
          final id = ApiMap.asInt(map['task_id']) ?? ApiMap.asInt(map['id']);
          if (id == null) return map;
          final notes = byId[id];
          if (notes == null) return map;
          if (ApiMap.asString(map['notes']) == notes) return map;
          changed = true;
          map['notes'] = notes;
          return map;
        })
        .toList(growable: false);

    if (!changed) return;
    await _cache.saveMap(OfflineCacheKeys.tasksToday, {
      ...cached,
      'tasks': updated,
    });
  }

  static TaskStatus? _parseOverrideStatus(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final status in TaskStatus.values) {
      if (status.name == raw) return status;
    }
    return null;
  }

  /// Local SQLite is the source of truth for the Resume card.
  ///
  /// After place-order / end-visit the local row is completed. Stale cache or a
  /// lagging `visits/active` response must not resurrect Resume for a task we
  /// already closed on this device ([ObVisitSessionService.closedTaskIds]).
  Future<ObActiveVisitModel?> fetchActiveVisit() async {
    final local = await _session?.activeVisit();
    if (local != null) {
      _activeVisit = local;
      await _cache.saveMap(OfflineCacheKeys.activeVisit, {
        'visit': local.toJson(),
      });
      return local;
    }

    // No local active visit. Prefer clearing sticky cache over serving it.
    // Only accept a remote active visit when that task was not closed locally
    // (e.g. resume a server-open visit that was never completed on this phone).
    if (!_cache.shouldServeCacheFirst()) {
      try {
        final data = await _api.postData(ApiEndpoints.obVisitsActive);
        final remote = _parseActiveVisit(data);
        if (remote != null && !_isLocallyClosed(remote.taskId)) {
          await _cache.saveMap(OfflineCacheKeys.activeVisit, data);
          _activeVisit = remote;
          return remote;
        }
      } catch (_) {
        // Ignore probe failures; local "no active" wins for Resume UI.
      }
    }

    _activeVisit = null;
    await _cache.saveMap(OfflineCacheKeys.activeVisit, const {});
    return null;
  }

  bool _isLocallyClosed(int taskId) =>
      _session?.isLocallyClosedTask(taskId) ?? false;

  ObActiveVisitModel? _parseActiveVisit(Map<String, dynamic> data) {
    final visitJson = ApiMap.asMap(data['visit']);
    if (visitJson == null) return null;
    final visit = ObActiveVisitModel.fromJson(visitJson);
    if (visit.visitId == 0) return null;
    return visit;
  }

  Future<ObTaskModel?> findTaskById(
    int taskId, {
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      await fetchTodayTasks(allowStaleFallback: true, forceNetwork: false);
    }
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (_) {
      await fetchTodayTasks(allowStaleFallback: true);
      try {
        return _tasks.firstWhere((task) => task.id == taskId);
      } catch (_) {
        return null;
      }
    }
  }

  Future<ObTaskModel?> findTaskByShopId(
    String shopId, {
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      await fetchTodayTasks(allowStaleFallback: true, forceNetwork: false);
    }
    try {
      return _tasks.firstWhere((task) => task.shopId == shopId);
    } catch (_) {
      await fetchTodayTasks(allowStaleFallback: true);
      try {
        return _tasks.firstWhere((task) => task.shopId == shopId);
      } catch (_) {
        return null;
      }
    }
  }

  ObActiveVisitModel? get activeVisitSync => _activeVisit;

  /// Direct `tasks/check-in`. Only used while online so the server can still
  /// answer with `needs_shop_setup`; offline check-in goes through
  /// [ObVisitSessionService.startVisit] instead.
  Future<ObCheckInResult> checkIn({
    required int taskId,
    required double latitude,
    required double longitude,
    Map<String, dynamic> gpsExtras = const {},
  }) async {
    final data = await _api.postData(
      ApiEndpoints.obTasksCheckIn,
      data: {
        'task_id': taskId,
        'latitude': latitude,
        'longitude': longitude,
        ...gpsExtras,
      },
    );
    final result = ObCheckInResult.fromJson(data);
    if (result.hasVisit) {
      _activeVisit = result.visit;
      await _cache.saveMap(OfflineCacheKeys.activeVisit, {
        'visit': result.visit!.toJson(),
      });
    }
    // Refresh tasks in the background so check-in UI is not blocked on a
    // second slow list call after a successful check-in.
    unawaited(fetchTodayTasks(allowStaleFallback: true));
    return result;
  }

  /// Sends / queues GPS when the OB is blocked for being too far, so the
  /// distributor panel can still show the attempt (online + offline).
  ///
  /// Never opens a local visit. Posts to the same check-in endpoint the panel
  /// already uses, with `out_of_range` / `blocked` set.
  /// App-side: one blocked attempt per shop + purpose + local day.
  Future<void> reportBlockedGpsAttempt({
    required int taskId,
    required String shopId,
    String? shopName,
    required double latitude,
    required double longitude,
    Map<String, dynamic> gpsExtras = const {},
    String purpose = 'check_in',
    int? visitId,
  }) async {
    final dayKey = _localDayKey();
    final clientRequestId = 'gps-blocked-$shopId-$purpose-$dayKey';
    final outbox = _outbox;
    final db = Get.isRegistered<AppDatabase>() ? Get.find<AppDatabase>() : null;

    // Already delivered to the panel today — never re-post or re-queue.
    if (db != null && await db.hasTelemetrySent(clientRequestId)) {
      await db.deleteOutboxByClientRequestId(clientRequestId);
      return;
    }

    if (outbox != null &&
        await outbox.hasPendingGpsAttempt(clientRequestId: clientRequestId)) {
      return;
    }

    final payload = <String, dynamic>{
      'task_id': taskId,
      'shop_id': shopId,
      'shop_name': ?shopName,
      'latitude': latitude,
      'longitude': longitude,
      ...gpsExtras,
      'out_of_range': true,
      'blocked': true,
      'purpose': purpose,
      'visit_id': ?visitId,
      'client_request_id': clientRequestId,
    };

    // Online: POST only. Never park in the outbox after a successful send.
    if (_canReachServer) {
      try {
        await _api.postData(ApiEndpoints.obTasksCheckIn, data: payload);
        if (db != null) {
          await db.markTelemetrySent(clientRequestId);
          await db.deleteOutboxByClientRequestId(clientRequestId);
        }
        return;
      } catch (_) {
        // Fall through to outbox only on network failure.
      }
    }

    if (outbox == null) return;
    await outbox.enqueue(
      role: 'orderBooker',
      action: 'gps_attempt',
      payload: payload,
      clientRequestId: clientRequestId,
    );
  }

  String _localDayKey() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  bool get _canReachServer {
    if (!Get.isRegistered<ConnectivityService>()) return true;
    final connectivity = Get.find<ConnectivityService>();
    if (!connectivity.isOnline.value) return false;
    return connectivity.quality.value != NetworkQuality.weak;
  }

  Future<void> applyActiveVisit(ObActiveVisitModel visit) async {
    _activeVisit = visit;
    await _cache.saveMap(OfflineCacheKeys.activeVisit, {
      'visit': visit.toJson(),
    });
    await fetchTodayTasks();
  }

  Future<void> completeActiveVisit({required int visitId}) async {
    await _session?.completeVisit(visitId: visitId, outcome: 'order_placed');
    _activeVisit = null;
    await _cache.saveMap(OfflineCacheKeys.activeVisit, const {});
    await fetchTodayTasks();
  }

  Future<void> clearActiveVisit({required int visitId, String? notes}) async {
    await _session?.completeVisit(
      visitId: visitId,
      outcome: 'ended_without_order',
      notes: notes,
    );
    _activeVisit = null;
    await _cache.saveMap(OfflineCacheKeys.activeVisit, const {});
    await fetchTodayTasks();
  }

  /// Persist notes on the task locally (override + cache) without syncing.
  /// Used when visit notes / end-visit already sync notes via another action.
  /// Empty [notes] clears the local note so the list shows the Notes button again.
  Future<void> saveTaskNotesLocalOnly({
    required int taskId,
    required String notes,
  }) async {
    final trimmed = notes.trim();
    await _session?.setTaskNotes(taskId, trimmed);
    await _applyLocalTaskNotes(taskId, trimmed);
  }

  /// Returns true when notes are still waiting to sync.
  Future<bool> saveTaskNotes({
    required int taskId,
    required String notes,
  }) async {
    final trimmed = notes.trim();
    final task = await findTaskById(taskId);
    final payload = {
      'task_id': taskId,
      'notes': trimmed,
      if (task != null) ...{'shop_id': task.shopId, 'shop_name': task.shopName},
    };

    await _session?.setTaskNotes(taskId, trimmed);
    await _applyLocalTaskNotes(taskId, trimmed);

    final outbox = _outbox;
    if (outbox == null) {
      await _api.postData(
        ApiEndpoints.obTasksNotes,
        data: {'task_id': taskId, 'notes': trimmed},
      );
      return false;
    }

    final synced = await outbox.enqueueAndFlush(
      role: 'orderBooker',
      action: 'task_notes',
      payload: payload,
    );
    return !synced;
  }

  Future<Set<int>> clearedNoteTaskIds() async =>
      await _session?.taskIdsWithClearedNotes() ?? {};

  Future<void> _applyLocalTaskNotes(int taskId, String notes) async {
    final trimmed = notes.trim();
    final cleared = trimmed.isEmpty;
    _tasks = _tasks
        .map(
          (task) => task.id == taskId
              ? task.copyWith(notes: cleared ? null : trimmed)
              : task,
        )
        .toList(growable: false);

    final cached = await _cache.readMap(OfflineCacheKeys.tasksToday);
    if (cached == null) return;

    final rawTasks = cached['tasks'];
    if (rawTasks is! List) return;

    final updated = rawTasks
        .map((raw) {
          if (raw is! Map) return raw;
          final map = Map<String, dynamic>.from(raw);
          final id = ApiMap.asInt(map['task_id']) ?? ApiMap.asInt(map['id']);
          if (id == taskId) {
            if (cleared) {
              map['notes'] = null;
            } else {
              map['notes'] = trimmed;
            }
          }
          return map;
        })
        .toList(growable: false);

    await _cache.saveMap(OfflineCacheKeys.tasksToday, {
      ...cached,
      'tasks': updated,
    });
  }

  Future<void> startRoute(String routeId) async {
    final currentRoute = _route;
    if (currentRoute == null || currentRoute.id != routeId) return;
    _route = ObRouteModel(
      id: currentRoute.id,
      name: currentRoute.name,
      description: currentRoute.description,
      shopCount: currentRoute.shopCount,
      distanceKm: currentRoute.distanceKm,
      status: currentRoute.status,
    );
  }
}
