import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart' hide Value;

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';

class SyncCenterController extends GetxController {
  SyncCenterController(this._outbox);

  final SyncOutboxService _outbox;

  final RxBool isLoading = true.obs;
  final RxList<OutboxEntry> items = <OutboxEntry>[].obs;
  Worker? _pendingWorker;

  @override
  void onInit() {
    super.onInit();
    load();
    // Keep the list in sync when auto-flush clears or updates the outbox.
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

  String labelFor(OutboxEntry entry) {
    return switch ('${entry.role}.${entry.action}') {
      'orderBooker.submit_order' => AppTexts.obPlaceOrder,
      'orderBooker.end_visit_without_order' => AppTexts.obEndVisitWithoutOrder,
      'orderBooker.visit_notes' => AppTexts.obSaveVisitNotes,
      'orderBooker.task_notes' => AppTexts.obTaskNotes,
      _ => '${entry.role}.${entry.action}',
    };
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

    final shop = shopLabelFor(entry);
    if (shop != null) lines.add(shop);

    final visitId = ApiMap.asInt(payload['visit_id']);
    if (visitId != null) lines.add(AppTexts.syncVisitId(visitId));

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

    lines.add(
      AppTexts.syncQueuedAt(AppFormatter.dateTime(entry.createdAt.toLocal())),
    );

    if (entry.attempts > 0) {
      lines.add(AppTexts.syncAttempts(entry.attempts));
    }

    final error = entry.lastError?.trim();
    if (error != null && error.isNotEmpty) {
      lines.add(error);
    }

    return lines.join('\n');
  }

  SyncStatus statusFor(OutboxEntry entry) =>
      SyncStatusX.fromOutboxStatus(entry.status) ?? SyncStatus.queued;
}
