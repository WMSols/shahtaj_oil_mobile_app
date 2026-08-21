import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/handover/dm_handover_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_collection_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmHandoverConfirmController extends GetxController with CachedLoadMixin {
  DmHandoverConfirmController(this._store);

  final DmCollectionStore _store;

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
    DmServicesBinding.ensureRegistered();
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
    managers.assignAll(AppMockData.dmManagers);
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
      title: AppTexts.dmConfirmHandover,
      message: AppTexts.dmConfirmHandoverMessage(
        AppFormatter.currencyWhole(bagTotal.value),
        '${receiptCount.value}',
      ),
      confirmLabel: AppTexts.dmConfirmHandover,
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
      AppToast.showSuccess(AppTexts.dmHandoverRecorded(handover.reference));
      Get.back(result: true);
    } on StateError catch (error) {
      AppToast.showError(_mapError(error.message));
    } catch (_) {
      AppToast.showError(AppTexts.dmHandoverFailed);
    } finally {
      if (!isClosed) isSaving.value = false;
    }
  }

  String? _validate() {
    if (receiptCount.value <= 0) return AppTexts.dmBagEmpty;
    if (selectedManager.value == null ||
        selectedManager.value!.trim().isEmpty) {
      return AppTexts.dmCashierRequired;
    }
    if (_parseAmount(countedCashController.text) <= 0 && cashInBag.value > 0) {
      return AppTexts.dmCashCountMismatch;
    }
    return null;
  }

  String _mapError(String message) {
    if (message.contains('mismatch')) return AppTexts.dmCashCountMismatch;
    if (message.contains('empty')) return AppTexts.dmBagEmpty;
    return AppTexts.dmHandoverFailed;
  }

  void _refreshRelatedLists() {
    if (Get.isRegistered<DmHandoverController>()) {
      Get.find<DmHandoverController>().loadHandover(force: true);
    }
    if (Get.isRegistered<DmCollectionHistoryController>()) {
      Get.find<DmCollectionHistoryController>().loadHistory(force: true);
    }
    if (Get.isRegistered<DmDashboardController>()) {
      Get.find<DmDashboardController>().refreshCollections();
    }
    if (Get.isRegistered<DmTodayShopsController>()) {
      Get.find<DmTodayShopsController>().loadShops(force: true);
    }
  }

  double _parseAmount(String? raw) {
    final cleaned = (raw ?? '').trim().replaceAll(',', '');
    if (cleaned.isEmpty) return 0;
    return double.tryParse(cleaned) ?? 0;
  }
}
