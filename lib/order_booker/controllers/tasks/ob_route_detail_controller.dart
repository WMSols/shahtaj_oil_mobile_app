import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/orders/ob_order_approval_info.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_today_tasks_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/history/ob_visit_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_task_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_check_in_flow.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_session_service.dart';

class ObRouteDetailController extends GetxController {
  ObRouteDetailController(this._taskService, {this._visitService});

  final ObTaskService _taskService;
  final ObVisitService? _visitService;

  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final RxnString error = RxnString();
  final Rxn<ObTodayTasksModel> todayTasks = Rxn<ObTodayTasksModel>();
  final Rxn<ObActiveVisitModel> activeVisit = Rxn<ObActiveVisitModel>();
  final RxnInt checkingInTaskId = RxnInt();
  final Rxn<TaskStatus> statusFilter = Rxn<TaskStatus>();
  final RxString searchQuery = ''.obs;

  Worker? _activeVisitWorker;
  Worker? _flushWorker;

  String get routeId => Get.parameters['id'] ?? '';

  static const filterStatuses = [
    TaskStatus.pending,
    TaskStatus.inVisit,
    TaskStatus.completed,
  ];

  bool isQueuedForSync(ObTaskModel task) {
    if (!Get.isRegistered<SyncOutboxService>()) return false;
    return Get.find<SyncOutboxService>().isTaskQueuedForSync(task.id);
  }

  /// Any pending outbox work for this task (check-in, notes, order, …).
  bool hasQueuedSyncWork(ObTaskModel task) {
    if (!Get.isRegistered<SyncOutboxService>()) return false;
    return Get.find<SyncOutboxService>().hasQueuedWorkForTask(task.id);
  }

  bool needsSyncReview(ObTaskModel task) {
    if (!Get.isRegistered<SyncOutboxService>()) return false;
    return Get.find<SyncOutboxService>().isTaskNeedsReview(task.id);
  }

  /// Queued closes look completed with a will-sync chip.
  /// Only the live [activeVisit] may show as In visit / Resume.
  TaskStatus displayStatusFor(ObTaskModel task) {
    if (isQueuedForSync(task)) return TaskStatus.completed;

    if (Get.isRegistered<ObVisitSessionService>()) {
      final session = Get.find<ObVisitSessionService>();
      // Observe for Obx rebuilds after offline closes / reconnect.
      session.closedTaskIds.length;
      session.activeVisitRx.value;

      // Server pending + no closing outbox work wins over stale local closed.
      if (task.status == TaskStatus.pending && !isQueuedForSync(task)) {
        if (session.isLocallyClosedTask(task.id)) {
          session.forgetClosedTask(task.id);
        }
      } else if (session.isLocallyClosedTask(task.id)) {
        return TaskStatus.completed;
      }

      final active = session.activeVisitRx.value ?? activeVisit.value;
      if (active != null &&
          (active.taskId == task.id || active.shopId == task.shopId)) {
        return TaskStatus.inVisit;
      }
    } else {
      final active = activeVisit.value;
      if (active != null &&
          (active.taskId == task.id || active.shopId == task.shopId)) {
        return TaskStatus.inVisit;
      }
    }

    // Stale inVisit override for a non-active shop must never look resumeable.
    if (task.status == TaskStatus.inVisit) {
      return TaskStatus.completed;
    }
    return task.status;
  }

  bool isResumableTask(ObTaskModel task) =>
      displayStatusFor(task) == TaskStatus.inVisit;

  List<ObTaskModel> get filteredSortedTasks {
    final tasks = todayTasks.value?.tasks ?? const <ObTaskModel>[];
    final filter = statusFilter.value;
    final query = searchQuery.value.trim().toLowerCase();
    final filtered = tasks.where((task) {
      final status = displayStatusFor(task);
      if (filter != null && status != filter) return false;
      if (query.isEmpty) return true;
      return task.shopName.toLowerCase().contains(query) ||
          (task.ownerName?.toLowerCase().contains(query) ?? false);
    }).toList();

    int rank(TaskStatus status) => switch (status) {
      TaskStatus.inVisit => 0,
      TaskStatus.pending => 1,
      TaskStatus.completed => 2,
    };

    filtered.sort((a, b) {
      final byStatus = rank(
        displayStatusFor(a),
      ).compareTo(rank(displayStatusFor(b)));
      if (byStatus != 0) return byStatus;
      return a.sequence.compareTo(b.sequence);
    });
    return filtered;
  }

  /// Counts for the progress bar — queued sync does not count as completed.
  int get displayCompletedCount {
    final tasks = todayTasks.value?.tasks ?? const <ObTaskModel>[];
    return tasks.where((task) {
      if (isQueuedForSync(task)) return false;
      return displayStatusFor(task) == TaskStatus.completed;
    }).length;
  }

  int get displayTotalCount => todayTasks.value?.totalCount ?? 0;

  bool isFilterSelected(TaskStatus? status) => statusFilter.value == status;

  void selectStatusFilter(TaskStatus? status) {
    statusFilter.value = status;
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['taskFilter'] is String) {
      final name = args['taskFilter'] as String;
      for (final status in TaskStatus.values) {
        if (status.name == name) {
          statusFilter.value = status;
          break;
        }
      }
    }
    _bindActiveVisitRx();
    _bindFlushRefresh();
    loadTasks();
  }

  @override
  void onClose() {
    _activeVisitWorker?.dispose();
    _flushWorker?.dispose();
    super.onClose();
  }

  void _bindActiveVisitRx() {
    if (!Get.isRegistered<ObVisitSessionService>()) return;
    final session = Get.find<ObVisitSessionService>();
    activeVisit.value = session.activeVisitRx.value;
    _activeVisitWorker = ever<ObActiveVisitModel?>(session.activeVisitRx, (
      visit,
    ) {
      activeVisit.value = visit;
      if (visit != null) {
        _markTaskInVisitLocally(visit.taskId, visit.shopId);
      }
    });
  }

  void _bindFlushRefresh() {
    if (!Get.isRegistered<SyncOutboxService>()) return;
    final outbox = Get.find<SyncOutboxService>();
    _flushWorker = ever<DateTime?>(outbox.lastFlushAt, (_) {
      unawaited(loadTasks(silent: true, force: true));
    });
  }

  /// Instant UI update so the banner / in-visit card appear before any network.
  void _markTaskInVisitLocally(int taskId, String shopId) {
    final current = todayTasks.value;
    if (current == null) return;
    var changed = false;
    final tasks = current.tasks
        .map((task) {
          if (task.id != taskId && task.shopId != shopId) return task;
          if (task.status == TaskStatus.inVisit) return task;
          changed = true;
          return task.copyWith(status: TaskStatus.inVisit);
        })
        .toList(growable: false);
    if (!changed) return;
    todayTasks.value = current.copyWith(tasks: tasks);
  }

  Future<void> loadTasks({bool silent = false, bool force = false}) async {
    final hasCache = todayTasks.value != null;

    if (!silent && !hasCache) {
      isLoading.value = true;
    }
    if (!silent && hasCache && force) {
      isRefreshing.value = true;
    }
    try {
      final data = await _taskService.fetchTodayTasks(
        allowStaleFallback: !force,
        forceNetwork: force,
      );
      todayTasks.value = data;
      activeVisit.value = await _taskService.fetchActiveVisit();
      if (Get.isRegistered<ObVisitSessionService>()) {
        final session = Get.find<ObVisitSessionService>();
        // Keep shared Rx in sync with local-first read.
        if (activeVisit.value != null) {
          session.publishActiveVisit(activeVisit.value!);
        } else if (session.activeVisitRx.value != null) {
          // Network said none but local still has one — prefer local UI.
          activeVisit.value = session.activeVisitRx.value;
        } else {
          session.clearActiveVisitRx();
        }
      }
      await _enrichTasksWithOrderApproval();

      if (routeId.isNotEmpty &&
          data.route.status == RouteStatus.notStarted &&
          data.route.id == routeId) {
        await _taskService.startRoute(routeId);
        todayTasks.value = await _taskService.fetchTodayTasks(
          allowStaleFallback: !force,
          forceNetwork: force,
        );
        await _enrichTasksWithOrderApproval();
      }
      error.value = null;
    } catch (_) {
      if (!hasCache) {
        error.value = AppTexts.error;
      }
    } finally {
      if (!silent) {
        isLoading.value = false;
        isRefreshing.value = false;
      }
    }
  }

  /// After check-in / return from visit: local overlay first, network later.
  Future<void> refreshAfterVisitChange() async {
    try {
      todayTasks.value = await _taskService.fetchTodayTasks(
        allowStaleFallback: true,
        forceNetwork: false,
      );
      activeVisit.value = await _taskService.fetchActiveVisit();
      if (Get.isRegistered<ObVisitSessionService>() &&
          activeVisit.value != null) {
        Get.find<ObVisitSessionService>().publishActiveVisit(
          activeVisit.value!,
        );
      }
    } catch (_) {
      // Keep optimistic UI.
    }
    unawaited(loadTasks(silent: true, force: true));
  }

  Future<void> openCheckIn(ObTaskModel task) async {
    if (checkingInTaskId.value != null) return;
    checkingInTaskId.value = task.id;
    try {
      await ObCheckInFlow.run(
        taskService: _taskService,
        task: task,
        activeVisit: activeVisit.value,
        onDone: refreshAfterVisitChange,
      );
    } finally {
      checkingInTaskId.value = null;
    }
  }

  void openTaskNotes(ObTaskModel task) {
    Get.toNamed(
      AppRoutes.obNotes,
      arguments: {
        'purpose': ObNotesPurpose.taskNotes,
        'taskId': task.id,
        'initialNotes': task.notes,
      },
    );
  }

  void resumeActiveVisit() {
    final visit = activeVisit.value;
    if (visit == null) return;
    Get.toNamed(AppRoutes.obOrderCreate, arguments: {'visitId': visit.visitId});
  }

  /// Merge today's visit approval flags onto completed tasks (discount/credit).
  Future<void> _enrichTasksWithOrderApproval() async {
    final current = todayTasks.value;
    if (current == null || current.tasks.isEmpty) return;

    final visitService =
        _visitService ??
        (Get.isRegistered<ObVisitService>()
            ? Get.find<ObVisitService>()
            : null);
    if (visitService == null) return;

    try {
      final now = DateTime.now();
      final dayStart = DateTime(now.year, now.month, now.day);
      final result = await visitService.fetchMyVisits(
        dateFrom: dayStart,
        dateTo: dayStart,
        forceNetwork: true,
      );

      final byTaskId = <int, ObOrderApprovalInfo>{};
      final byShopId = <String, ObOrderApprovalInfo>{};
      for (final visit in result.visits) {
        if (visit.outcome != VisitOutcome.orderPlaced) continue;
        if (visit.approval.state == ObOrderApprovalState.none &&
            !visit.approval.needsVerification) {
          continue;
        }
        if (visit.taskId != null) {
          byTaskId[visit.taskId!] = visit.approval;
        }
        final shopId = visit.shopId?.trim();
        if (shopId != null && shopId.isNotEmpty) {
          byShopId[shopId] = visit.approval;
        }
      }

      if (byTaskId.isEmpty && byShopId.isEmpty) return;

      final enriched = current.tasks
          .map((task) {
            final fromTask = byTaskId[task.id];
            final fromShop = byShopId[task.shopId];
            final approval = fromTask ?? fromShop;
            if (approval == null) return task;
            if (task.orderApproval.state != ObOrderApprovalState.none) {
              return task;
            }
            return task.copyWith(orderApproval: approval);
          })
          .toList(growable: false);

      todayTasks.value = current.copyWith(tasks: enriched);
    } catch (_) {
      // Approval chips are additive; keep tasks list if visits fail.
    }
  }
}
