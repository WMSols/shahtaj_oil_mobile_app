import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/pickup/dm_pickup_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_stock_item_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';

class DmPickupController extends GetxController {
  DmPickupController(this._pickupService);

  final DmPickupService _pickupService;

  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool acknowledged = false.obs;
  final Rxn<DmPickupModel> pickup = Rxn<DmPickupModel>();
  final RxMap<String, String> loadedDrafts = <String, String>{}.obs;
  final RxMap<String, String?> qtyErrors = <String, String?>{}.obs;
  final Map<String, TextEditingController> qtyControllers = {};

  @override
  void onInit() {
    super.onInit();
    loadPickup();
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
      () => TextEditingController(text: loadedDrafts[itemId] ?? ''),
    );
  }

  Color stripeColorFor(DmStockItemModel item) =>
      item.isLowStock ? AppColors.warning : AppColors.success;

  Future<void> loadPickup() async {
    isLoading.value = true;
    try {
      final data = await _pickupService.fetchTodayPickup();
      pickup.value = data;
      acknowledged.value = data.isAcknowledged;

      _disposeQtyControllers();
      loadedDrafts.clear();
      qtyErrors.clear();

      for (final item in data.items) {
        // Confirmed pickups show saved qty; otherwise leave empty for user input.
        final text = data.isAcknowledged ? item.quantity.toString() : '';
        loadedDrafts[item.id] = text;
        qtyControllers[item.id] = TextEditingController(text: text);
      }
      loadedDrafts.refresh();
    } finally {
      isLoading.value = false;
    }
  }

  void onLoadedQtyChanged(String itemId, String raw) {
    loadedDrafts[itemId] = raw;
    final item = pickup.value?.items.firstWhereOrNull((e) => e.id == itemId);
    if (item == null) return;

    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      qtyErrors[itemId] = null;
    } else {
      final parsed = int.tryParse(trimmed);
      if (parsed == null || parsed < 0 || parsed > item.expected) {
        qtyErrors[itemId] = AppTexts.dmInvalidQuantity;
      } else {
        qtyErrors[itemId] = null;
      }
    }
    loadedDrafts.refresh();
    qtyErrors.refresh();
  }

  bool get hasQtyErrors =>
      qtyErrors.values.any((e) => e != null && e.isNotEmpty);

  bool _validateAllForSubmit() {
    final current = pickup.value;
    if (current == null) return false;
    var ok = true;
    for (final item in current.items) {
      final raw = (loadedDrafts[item.id] ?? '').trim();
      final parsed = int.tryParse(raw);
      if (parsed == null || parsed < 0 || parsed > item.expected) {
        qtyErrors[item.id] = AppTexts.dmInvalidQuantity;
        ok = false;
      } else {
        qtyErrors[item.id] = null;
      }
    }
    qtyErrors.refresh();
    return ok;
  }

  void goToOrders() {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf('dm_orders');
  }

  Future<void> confirmPickup() async {
    final current = pickup.value;
    if (current == null || current.isAcknowledged) return;

    if (!_validateAllForSubmit()) {
      AppToast.showError(AppTexts.dmInvalidQuantity);
      return;
    }

    isSubmitting.value = true;
    try {
      final loadedItems = current.items
          .map((item) {
            final qty = int.parse((loadedDrafts[item.id] ?? '').trim());
            return item.copyWith(
              quantity: qty,
              expectedQuantity: item.expected,
              isLowStock: qty <= 15,
            );
          })
          .toList(growable: false);

      final updated = await _pickupService.confirmPickup(
        loadedItems: loadedItems,
      );
      pickup.value = updated;
      acknowledged.value = true;
      AppToast.showSuccess(AppTexts.dmPickupConfirmed);
      goToOrders();
    } finally {
      isSubmitting.value = false;
    }
  }
}
