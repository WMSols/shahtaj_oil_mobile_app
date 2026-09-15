import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart' hide Value;

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

/// One Sync Center card: a visit's chained steps, or a standalone action.
class SyncQueueGroup {
  const SyncQueueGroup({
    required this.key,
    required this.title,
    required this.entries,
  });

  final String key;
  final String title;
  final List<OutboxEntry> entries;

  bool get isVisitGroup => key.startsWith('visit:');

  List<OutboxEntry> get retryableEntries => entries
      .where(
        (e) =>
            e.status == OutboxStatus.failed ||
            e.status == OutboxStatus.needsReview,
      )
      .toList(growable: false);

  bool get canRetry => retryableEntries.isNotEmpty;

  bool get hasFailedOrNeedsReview => canRetry;

  DateTime get oldestCreatedAt =>
      entries.map((e) => e.createdAt).reduce((a, b) => a.isBefore(b) ? a : b);
}

class SyncCenterController extends GetxController {
  SyncCenterController(this._outbox);

  final SyncOutboxService _outbox;

  final RxBool isLoading = true.obs;
  final RxBool isRetrying = false.obs;
  final RxBool isClearing = false.obs;
  final RxList<OutboxEntry> items = <OutboxEntry>[].obs;
  Worker? _pendingWorker;

  @override
  void onInit() {
    super.onInit();
    load();
    _pendingWorker = ever(_outbox.pendingCount, (_) => unawaited(load()));
  }

  @override
  void onClose() {
    _pendingWorker?.dispose();
    super.onClose();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      items.assignAll(await _outbox.listPending());
    } finally {
      isLoading.value = false;
    }
  }

  List<SyncQueueGroup> get groups {
    final buckets = <String, List<OutboxEntry>>{};
    final order = <String>[];

    for (final entry in items) {
      final key = _groupKeyFor(entry);
      if (!buckets.containsKey(key)) {
        buckets[key] = <OutboxEntry>[];
        order.add(key);
      }
      buckets[key]!.add(entry);
    }

    return [
      for (final key in order)
        SyncQueueGroup(
          key: key,
          title: _titleFor(buckets[key]!),
          entries: List<OutboxEntry>.unmodifiable(buckets[key]!),
        ),
    ];
  }

  bool get showClearLocalData => items.any(
    (e) =>
        e.status == OutboxStatus.failed || e.status == OutboxStatus.needsReview,
  );

  int get otherUserPendingCount => _outbox.otherUserPendingCount.value;

  Future<void> retry(String id) async {
    if (isRetrying.value) return;
    isRetrying.value = true;
    try {
      await _outbox.retryEntry(id);
      await load();
      AppToast.showSuccess(AppTexts.syncRetry);
    } catch (_) {
      AppToast.showError(AppTexts.error);
      await load();
    } finally {
      isRetrying.value = false;
    }
  }

  Future<void> retryGroup(SyncQueueGroup group) async {
    if (isRetrying.value || !group.canRetry) return;
    isRetrying.value = true;
    try {
      for (final entry in group.retryableEntries) {
        await _outbox.retryEntry(entry.id);
      }
      await load();
      AppToast.showSuccess(AppTexts.syncRetry);
    } catch (_) {
      AppToast.showError(AppTexts.error);
      await load();
    } finally {
      isRetrying.value = false;
    }
  }

  Future<void> clearLocalData() async {
    if (isClearing.value) return;
    final confirmed =
        await Get.dialog<bool>(
          AppConfirmDialog(
            title: AppTexts.clearLocalData,
            message: AppTexts.clearLocalDataMessage,
            confirmLabel: AppTexts.clearLocalData,
          ),
        ) ??
        false;
    if (!confirmed) return;

    isClearing.value = true;
    try {
      await _outbox.clearSessionData();
      await load();
      AppToast.showSuccess(AppTexts.clearLocalDataDone);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isClearing.value = false;
    }
  }

  String labelFor(OutboxEntry entry) {
    return switch ('${entry.role}.${entry.action}') {
      'orderBooker.submit_order' => AppTexts.obPlaceOrder,
      'orderBooker.end_visit_without_order' => AppTexts.obEndVisitWithoutOrder,
      'orderBooker.visit_notes' => AppTexts.obSaveVisitNotes,
      'orderBooker.task_notes' => AppTexts.obTaskNotes,
      'orderBooker.check_in' => AppTexts.obQueuedCheckIn,
      'orderBooker.verify_on_site' => AppTexts.obQueuedVerification,
      'orderBooker.register_shop' => AppTexts.obQueuedRegistration,
      _ => '${entry.role}.${entry.action}',
    };
  }

  bool isFromEarlierDay(OutboxEntry entry) {
    final now = DateTime.now();
    return entry.createdAt.isBefore(DateTime(now.year, now.month, now.day));
  }

  Map<String, dynamic> payloadFor(OutboxEntry entry) {
    try {
      final decoded = jsonDecode(entry.payloadJson);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return const {};
  }

  String? shopLabelFor(OutboxEntry entry) {
    final payload = payloadFor(entry);
    final name = ApiMap.asString(payload['shop_name'])?.trim();
    if (name != null && name.isNotEmpty) return name;
    final shopId = ApiMap.asString(payload['shop_id'])?.trim();
    if (shopId != null && shopId.isNotEmpty) return shopId;
    return null;
  }

  String detailLinesFor(OutboxEntry entry) {
    final payload = payloadFor(entry);
    final lines = <String>[];

    if (entry.action == 'submit_order') {
      final cartLines = payload['lines'];
      if (cartLines is List && cartLines.isNotEmpty) {
        lines.add(AppTexts.syncLinesCount(cartLines.length));
      }
    }

    final notes = ApiMap.asString(payload['notes'])?.trim();
    if (notes != null && notes.isNotEmpty) {
      lines.add(notes.length > 80 ? '${notes.substring(0, 80)}…' : notes);
    }

    final error = entry.lastError?.trim();
    if (error != null && error.isNotEmpty) {
      lines.add(error);
    }

    return lines.join('\n');
  }

  String groupMetaLine(SyncQueueGroup group) {
    final parts = <String>[
      AppTexts.syncQueuedAt(
        AppFormatter.dateTime(group.oldestCreatedAt.toLocal()),
      ),
    ];
    if (group.entries.any(isFromEarlierDay)) {
      parts.add(AppTexts.obSyncStaleDay);
    }
    final attempts = group.entries.fold<int>(0, (sum, e) => sum + e.attempts);
    if (attempts > 0) {
      parts.add(AppTexts.syncAttempts(attempts));
    }
    return parts.join(' · ');
  }

  SyncStatus statusFor(OutboxEntry entry) =>
      SyncStatusX.fromOutboxStatus(entry.status) ?? SyncStatus.queued;

  SyncStatus overallStatusFor(SyncQueueGroup group) {
    final statuses = group.entries.map(statusFor).toList(growable: false);
    const rank = {
      SyncStatus.needsReview: 5,
      SyncStatus.failed: 4,
      SyncStatus.blocked: 3,
      SyncStatus.syncing: 2,
      SyncStatus.queued: 1,
      SyncStatus.synced: 0,
    };
    return statuses.reduce((a, b) => (rank[a] ?? 0) >= (rank[b] ?? 0) ? a : b);
  }

  String _groupKeyFor(OutboxEntry entry) {
    if (entry.entityType == 'visit' && entry.localEntityId != null) {
      return 'visit:${entry.localEntityId}';
    }
    final payload = payloadFor(entry);
    final visitId = ApiMap.asInt(payload['visit_id']);
    if (visitId != null) return 'visit:$visitId';
    final taskId = ApiMap.asInt(payload['task_id']);
    if (taskId != null &&
        (entry.action == 'check_in' ||
            entry.action == 'verify_on_site' ||
            entry.action == 'submit_order' ||
            entry.action == 'end_visit_without_order' ||
            entry.action == 'visit_notes')) {
      return 'task:$taskId';
    }
    if (entry.entityType == 'shop' && entry.localEntityId != null) {
      return 'shop:${entry.localEntityId}';
    }
    return 'solo:${entry.id}';
  }

  String _titleFor(List<OutboxEntry> entries) {
    for (final entry in entries) {
      final shop = shopLabelFor(entry);
      if (shop != null) return shop;
    }
    if (entries.length == 1) return labelFor(entries.first);
    return AppTexts.syncCenterTitle;
  }
}
