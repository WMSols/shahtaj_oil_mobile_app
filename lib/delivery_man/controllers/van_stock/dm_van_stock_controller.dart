import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_item_view.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_snapshot_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';

enum DmVanStockMode { onVan, loadFromWh, returnToWh }

class DmVanStockController extends GetxController {
  DmVanStockController(this._vanService);

  final DmVanService _vanService;

  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString error = RxnString();
  final Rxn<DmVanSnapshotModel> snapshot = Rxn<DmVanSnapshotModel>();
  final RxList<DmVanItemView> rows = <DmVanItemView>[].obs;
  final Rx<DmVanStockMode> mode = DmVanStockMode.onVan.obs;
  final RxMap<String, String> qtyDrafts = <String, String>{}.obs;
  final RxMap<String, String?> qtyErrors = <String, String?>{}.obs;
  final Map<String, TextEditingController> qtyControllers = {};

  bool get canEditQty =>
      mode.value == DmVanStockMode.loadFromWh ||
      mode.value == DmVanStockMode.returnToWh;

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

  TextEditingController qtyControllerFor(String id) {
    return qtyControllers.putIfAbsent(
      id,
      () => TextEditingController(text: qtyDrafts[id] ?? ''),
    );
  }

  Future<void> load({bool force = true}) async {
    isLoading.value = true;
    error.value = null;
    try {
      snapshot.value = await _vanService.fetchSnapshot(forceNetwork: force);
      await _reloadRowsForMode();
    } on ApiException catch (e) {
      error.value = e.message;
      if (snapshot.value == null) AppToast.showError(e.message);
    } catch (_) {
      error.value = AppTexts.error;
      if (snapshot.value == null) AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setMode(DmVanStockMode next) async {
    if (mode.value == next) return;
    mode.value = next;
    isLoading.value = true;
    try {
      await _reloadRowsForMode();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _reloadRowsForMode() async {
    switch (mode.value) {
      case DmVanStockMode.onVan:
        final snap = snapshot.value ?? await _vanService.fetchSnapshot();
        snapshot.value = snap;
        rows.assignAll([
          for (final item in snap.items)
            DmVanItemView(
              id: '${item.productId}',
              productId: item.productId,
              name: item.name,
              uom: item.uom,
              qtyOnVan: item.qty,
              maxEditable: 0,
            ),
        ]);
        _clearDrafts();
        break;
      case DmVanStockMode.loadFromWh:
        final products = await _vanService.fetchProducts();
        rows.assignAll([
          for (final p in products)
            if (p.qtyInWarehouse > 0)
              DmVanItemView(
                id: '${p.productId}',
                productId: p.productId,
                name: p.name,
                uom: p.uom,
                qtyOnVan: p.qtyOnVan,
                qtyInWarehouse: p.qtyInWarehouse,
                maxEditable: p.qtyInWarehouse,
              ),
        ]);
        _seedDrafts(zero: true);
        break;
      case DmVanStockMode.returnToWh:
        final snap = snapshot.value ?? await _vanService.fetchSnapshot();
        snapshot.value = snap;
        rows.assignAll([
          for (final item in snap.items)
            if (item.qty > 0)
              DmVanItemView(
                id: '${item.productId}',
                productId: item.productId,
                name: item.name,
                uom: item.uom,
                qtyOnVan: item.qty,
                maxEditable: item.qty,
              ),
        ]);
        _seedDrafts(useOnVan: true);
        break;
    }
  }

  void _clearDrafts() {
    _disposeQtyControllers();
    qtyDrafts.clear();
    qtyErrors.clear();
  }

  void _seedDrafts({bool zero = false, bool useOnVan = false}) {
    _disposeQtyControllers();
    qtyDrafts.clear();
    qtyErrors.clear();
    for (final row in rows) {
      final text = zero
          ? '0'
          : useOnVan
          ? row.qtyOnVan.round().toString()
          : '0';
      qtyDrafts[row.id] = text;
      qtyControllers[row.id] = TextEditingController(text: text);
    }
    qtyDrafts.refresh();
  }

  void onQtyChanged(String id, String raw) {
    qtyDrafts[id] = raw;
    final row = rows.firstWhereOrNull((e) => e.id == id);
    if (row == null) return;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      qtyErrors[id] = null;
    } else {
      final parsed = double.tryParse(trimmed);
      if (parsed == null || parsed < 0 || parsed > row.maxEditable) {
        qtyErrors[id] = AppTexts.dmInvalidQuantity;
      } else {
        qtyErrors[id] = null;
      }
    }
    qtyDrafts.refresh();
    qtyErrors.refresh();
  }

  bool _validate() {
    var ok = true;
    var any = false;
    for (final row in rows) {
      final raw = (qtyDrafts[row.id] ?? '').trim();
      final parsed = double.tryParse(raw);
      if (parsed == null || parsed < 0 || parsed > row.maxEditable) {
        qtyErrors[row.id] = AppTexts.dmInvalidQuantity;
        ok = false;
      } else {
        qtyErrors[row.id] = null;
        if (parsed > 0) any = true;
      }
    }
    qtyErrors.refresh();
    if (ok && !any) {
      AppToast.showError(AppTexts.dmLoadPickEmpty);
      return false;
    }
    return ok;
  }

  List<({int productId, double qty})> _lines() {
    return [
      for (final row in rows)
        (
          productId: row.productId,
          qty: double.parse((qtyDrafts[row.id] ?? '0').trim()),
        ),
    ].where((e) => e.qty > 0).toList(growable: false);
  }

  Future<void> confirmLoad() async {
    if (mode.value != DmVanStockMode.loadFromWh || isSubmitting.value) return;
    if (!_validate()) {
      if (qtyErrors.values.any((e) => e != null)) {
        AppToast.showError(AppTexts.dmInvalidQuantity);
      }
      return;
    }
    isSubmitting.value = true;
    try {
      snapshot.value = await _vanService.loadToVan(lines: _lines());
      AppToast.showSuccess(AppTexts.dmVanLoadConfirmed);
      mode.value = DmVanStockMode.onVan;
      await _reloadRowsForMode();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> confirmReturn() async {
    if (mode.value != DmVanStockMode.returnToWh || isSubmitting.value) return;
    if (!_validate()) {
      if (qtyErrors.values.any((e) => e != null)) {
        AppToast.showError(AppTexts.dmInvalidQuantity);
      }
      return;
    }
    isSubmitting.value = true;
    try {
      snapshot.value = await _vanService.returnToWarehouse(lines: _lines());
      AppToast.showSuccess(AppTexts.dmVanUnloadConfirmed);
      mode.value = DmVanStockMode.onVan;
      await _reloadRowsForMode();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
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
}
