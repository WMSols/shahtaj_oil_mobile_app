import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/collections/rm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/dashboard/rm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/handover/rm_handover_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/controllers/history/rm_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

class RmHandoverConfirmController extends GetxController with CachedLoadMixin {
  RmHandoverConfirmController(this._store);

  final RmCollectionStore _store;

  final RxInt receiptCount = 0.obs;
  final RxDouble cashInBag = 0.0.obs;
  final RxDouble chequeInBag = 0.0.obs;
  final RxDouble bagTotal = 0.0.obs;
  final RxBool isSaving = false.obs;
  final RxList<String> managers = <String>[].obs;
  final Rxn<String> selectedManager = Rxn<String>();

  final countedCashController = TextEditingController();
  final notesController = TextEditingController();

  @override
  bool get hasCachedData => receiptCount.value > 0;

  @override
  String get loadFailedMessage => AppTexts.emptyLoadFailedSubtitle;

  @override
  void onInit() {
    super.onInit();
    RecoveryManServicesBinding.ensureRegistered();
    loadBag();
  }

  @override
  void onClose() {
    countedCashController.dispose();
    notesController.dispose();
    super.onClose();
  }

  Future<void> loadBag({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await _store.hydrate();
    receiptCount.value = _store.bagCollections.length;
    cashInBag.value = _store.cashInBag;
    chequeInBag.value = _store.chequeInBag;
    bagTotal.value = _store.bagTotal;
    managers.assignAll(AppMockData.rmManagers);
  }

  void selectManager(String? value) => selectedManager.value = value;

  Future<void> submit() async {
    if (isSaving.value) return;
    final error = _validate();
    if (error != null) {
      AppToast.showError(error);
      return;
    }

    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.rmConfirmHandover,
      message: AppTexts.rmConfirmHandoverMessage(
        AppFormatter.currencyWhole(bagTotal.value),
        '${receiptCount.value}',
      ),
      confirmLabel: AppTexts.rmConfirmHandover,
    );
    if (confirmed != true) return;

    isSaving.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 280));
      final handover = await _store.submitHandover(
        countedCash: _parseAmount(countedCashController.text),
        cashierName: selectedManager.value ?? '',
        notes: notesController.text,
      );
      _refreshRelatedLists();
      AppToast.showSuccess(AppTexts.rmHandoverRecorded(handover.reference));
      Get.back(result: true);
    } on StateError catch (error) {
      AppToast.showError(_mapError(error.message));
    } catch (_) {
      AppToast.showError(AppTexts.rmHandoverFailed);
    } finally {
      if (!isClosed) isSaving.value = false;
    }
  }

  String? _validate() {
    if (receiptCount.value <= 0) return AppTexts.rmBagEmpty;
    if (selectedManager.value == null ||
        selectedManager.value!.trim().isEmpty) {
      return AppTexts.rmCashierRequired;
    }
    if (_parseAmount(countedCashController.text) <= 0 && cashInBag.value > 0) {
      return AppTexts.rmCashCountMismatch;
    }
    return null;
  }

  String _mapError(String message) {
    if (message.contains('mismatch')) return AppTexts.rmCashCountMismatch;
    if (message.contains('empty')) return AppTexts.rmBagEmpty;
    return AppTexts.rmHandoverFailed;
  }

  void _refreshRelatedLists() {
    if (Get.isRegistered<RmHandoverController>()) {
      Get.find<RmHandoverController>().loadHandover(force: true);
    }
    if (Get.isRegistered<RmHistoryController>()) {
      Get.find<RmHistoryController>().loadHistory(force: true);
    }
    if (Get.isRegistered<RmDashboardController>()) {
      Get.find<RmDashboardController>().loadDashboard(force: true);
    }
    if (Get.isRegistered<RmTodayShopsController>()) {
      Get.find<RmTodayShopsController>().loadShops(force: true);
    }
  }

  double _parseAmount(String? raw) {
    final cleaned = (raw ?? '').trim().replaceAll(',', '');
    if (cleaned.isEmpty) return 0;
    return double.tryParse(cleaned) ?? 0;
  }
}
