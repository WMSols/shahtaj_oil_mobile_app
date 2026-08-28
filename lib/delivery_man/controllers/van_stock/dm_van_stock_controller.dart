import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van_stock/dm_van_stock_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van_stock/dm_van_stock_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';

class DmVanStockController extends GetxController {
  DmVanStockController(this._service);

  final DmVanStockService _service;

  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final Rxn<DmVanStockModel> session = Rxn<DmVanStockModel>();
  final RxString notes = ''.obs;
  final RxMap<String, String> qtyDrafts = <String, String>{}.obs;
  final RxMap<String, String?> qtyErrors = <String, String?>{}.obs;
  final Map<String, TextEditingController> qtyControllers = {};

  bool get canLoad => session.value?.canLoad ?? false;
  bool get canUnload => session.value?.canUnload ?? false;
  bool get isEditingQty => canLoad || canUnload;

  int _maxQtyFor(String itemId) {
    final item = session.value?.items.firstWhereOrNull((e) => e.id == itemId);
    if (item == null) return 0;
    if (canLoad) return item.expected;
    if (canUnload) return item.onHand;
    return 0;
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    _disposeQtyControllers();
    super.onClose();
  }

  void _disposeQtyControllers() {
    for (final c in qtyControllers.values) {
      c.dispose();
    }
    qtyControllers.clear();
  }

  TextEditingController qtyControllerFor(String itemId) {
    return qtyControllers.putIfAbsent(
      itemId,
      () => TextEditingController(text: qtyDrafts[itemId] ?? ''),
    );
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final data = await _service.fetchVanStock();
      session.value = data;
      notes.value = data.notes;
      _seedQtyDrafts(data);
    } finally {
      isLoading.value = false;
    }
  }

  void _seedQtyDrafts(DmVanStockModel data) {
    _disposeQtyControllers();
    qtyDrafts.clear();
    qtyErrors.clear();

    for (final item in data.items) {
      final text = data.canLoad
          ? item.expected.toString()
          : data.canUnload
          ? item.onHand.toString()
          : item.onHand.toString();
      qtyDrafts[item.id] = text;
      qtyControllers[item.id] = TextEditingController(text: text);
    }
    qtyDrafts.refresh();
  }

  void onNotesChanged(String value) => notes.value = value;

  void onQtyChanged(String itemId, String raw) {
    qtyDrafts[itemId] = raw;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      qtyErrors[itemId] = null;
    } else {
      final parsed = int.tryParse(trimmed);
      final max = _maxQtyFor(itemId);
      if (parsed == null || parsed < 0 || parsed > max) {
        qtyErrors[itemId] = AppTexts.dmInvalidQuantity;
      } else {
        qtyErrors[itemId] = null;
      }
    }
    qtyDrafts.refresh();
    qtyErrors.refresh();
  }

  bool _validateAllForSubmit() {
    final current = session.value;
    if (current == null) return false;
    var ok = true;
    for (final item in current.items) {
      final raw = (qtyDrafts[item.id] ?? '').trim();
      final parsed = int.tryParse(raw);
      final max = current.canLoad ? item.expected : item.onHand;
      if (parsed == null || parsed < 0 || parsed > max) {
        qtyErrors[item.id] = AppTexts.dmInvalidQuantity;
        ok = false;
      } else {
        qtyErrors[item.id] = null;
      }
    }
    qtyErrors.refresh();
    return ok;
  }

  Map<String, int> _parsedQuantities() {
    final map = <String, int>{};
    for (final entry in qtyDrafts.entries) {
      map[entry.key] = int.parse(entry.value.trim());
    }
    return map;
  }

  Future<void> confirmLoad() async {
    if (!canLoad || isSubmitting.value) return;
    if (!_validateAllForSubmit()) {
      AppToast.showError(AppTexts.dmInvalidQuantity);
      return;
    }

    isSubmitting.value = true;
    try {
      session.value = await _service.confirmLoad(
        quantitiesByItemId: _parsedQuantities(),
        notes: notes.value,
      );
      _seedQtyDrafts(session.value!);
      AppToast.showSuccess(AppTexts.dmVanLoadConfirmed);
      _refreshDashboard();
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> confirmUnload() async {
    if (!canUnload || isSubmitting.value) return;
    if (!_validateAllForSubmit()) {
      AppToast.showError(AppTexts.dmInvalidQuantity);
      return;
    }

    isSubmitting.value = true;
    try {
      session.value = await _service.confirmUnload(
        quantitiesByItemId: _parsedQuantities(),
        notes: notes.value,
      );
      _seedQtyDrafts(session.value!);
      AppToast.showSuccess(AppTexts.dmVanUnloadConfirmed);
      _refreshDashboard();
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  void goToOrders() {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf('dm_orders');
  }

  void _refreshDashboard() {
    if (Get.isRegistered<DmDashboardController>()) {
      Get.find<DmDashboardController>().load();
    }
  }
}
