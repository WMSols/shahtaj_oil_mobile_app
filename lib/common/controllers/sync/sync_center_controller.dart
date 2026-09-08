import 'package:get/get.dart' hide Value;

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

class SyncCenterController extends GetxController {
  SyncCenterController(this._outbox);

  final SyncOutboxService _outbox;

  final RxBool isLoading = true.obs;
  final RxBool isSyncing = false.obs;
  final RxList<OutboxEntry> items = <OutboxEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      items.assignAll(await _outbox.listPending());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> syncAll() async {
    isSyncing.value = true;
    try {
      await _outbox.flush(force: true);
      await load();
      AppToast.showSuccess(AppTexts.syncNow);
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> retry(String id) async {
    isSyncing.value = true;
    try {
      await _outbox.retryEntry(id);
      await load();
    } finally {
      isSyncing.value = false;
    }
  }

  String labelFor(OutboxEntry entry) {
    return switch ('${entry.role}.${entry.action}') {
      'orderBooker.submit_order' => AppTexts.obPlaceOrder,
      'orderBooker.end_visit_without_order' => AppTexts.obEndVisitWithoutOrder,
      'orderBooker.visit_notes' => AppTexts.obSaveVisitNotes,
      _ => '${entry.role}.${entry.action}',
    };
  }

  SyncStatus statusFor(OutboxEntry entry) =>
      SyncStatusX.fromOutboxStatus(entry.status) ?? SyncStatus.queued;
}
