import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/load/dm_load_today_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/load/dm_pick_line_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/load/dm_load_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/session/dm_session_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';

class DmPickupController extends GetxController {
  DmPickupController(this._loadService, this._sessionService);

  final DmLoadService _loadService;
  final DmSessionService _sessionService;

  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString error = RxnString();
  final Rxn<DmLoadTodayModel> load = Rxn<DmLoadTodayModel>();

  /// Collective pick drafts keyed by product id.
  final RxMap<String, String> qtyDrafts = <String, String>{}.obs;
  final RxMap<String, String?> qtyErrors = <String, String?>{}.obs;
  final Map<String, TextEditingController> qtyControllers = {};

  bool get hasRemainingToPick =>
      (load.value?.pickLines ?? const []).any((l) => l.needsWarehousePick);

  /// Product lines still needing a warehouse pick (hide fully loaded cards).
  List<DmPickLineModel> get remainingPickLines {
    final lines = load.value?.pickLines ?? const <DmPickLineModel>[];
    return lines.where((l) => l.needsWarehousePick).toList(growable: false);
  }

  /// Depart is the Load → Today Plan handoff once stock is on the van.
  bool get canDepart {
    if (hasRemainingToPick || !_hasPickedStock) return false;
    final state = load.value?.session?.state ?? _sessionService.current?.state;
    return state == DmSessionState.office;
  }

  bool get _hasPickedStock {
    final current = load.value;
    if (current == null) return false;
    if (current.vanQtyTotal > 0) return true;
    return current.pickLines.any(
      (line) => line.qtyPicked > 0 || line.qtyOnVan > 0,
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadToday();
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

  String _key(DmPickLineModel line) => '${line.productId}';

  TextEditingController qtyControllerFor(DmPickLineModel line) {
    final key = _key(line);
    return qtyControllers.putIfAbsent(
      key,
      () => TextEditingController(text: qtyDrafts[key] ?? ''),
    );
  }

  Color stripeColorFor(DmPickLineModel line) {
    if (!line.needsWarehousePick) return AppColors.success;
    if (line.qtyInWarehouse <= 0) return AppColors.error;
    return AppColors.warning;
  }

  Future<void> loadToday({bool force = true}) async {
    isLoading.value = true;
    error.value = null;
    try {
      final data = await _loadService.fetchToday(forceNetwork: force);
      load.value = data;
      _seedDrafts(data);
    } on ApiException catch (e) {
      error.value = e.message;
      if (load.value == null) AppToast.showError(e.message);
    } catch (_) {
      error.value = AppTexts.error;
      if (load.value == null) AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  void _seedDrafts(DmLoadTodayModel data) {
    _disposeQtyControllers();
    qtyDrafts.clear();
    qtyErrors.clear();
    for (final line in data.pickLines) {
      if (!line.needsWarehousePick) continue;
      final key = _key(line);
      final suggested = line.remainingToPick.round().toString();
      qtyDrafts[key] = suggested;
      qtyControllers[key] = TextEditingController(text: suggested);
    }
    qtyDrafts.refresh();
  }

  void onQtyChanged(DmPickLineModel line, String raw) {
    final key = _key(line);
    qtyDrafts[key] = raw;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      qtyErrors[key] = null;
    } else {
      final parsed = double.tryParse(trimmed);
      final maxQty = line.remainingToPick;
      if (parsed == null ||
          parsed < 0 ||
          (maxQty > 0 && parsed > maxQty) ||
          parsed > line.qtyInWarehouse) {
        qtyErrors[key] = AppTexts.dmInvalidQuantity;
      } else {
        qtyErrors[key] = null;
      }
    }
    qtyDrafts.refresh();
    qtyErrors.refresh();
  }

  bool _validateCollective() {
    final current = load.value;
    if (current == null) return false;
    var ok = true;
    var anyPositive = false;
    for (final line in remainingPickLines) {
      final key = _key(line);
      final raw = (qtyDrafts[key] ?? '').trim();
      final parsed = double.tryParse(raw);
      final maxQty = line.remainingToPick;
      if (parsed == null ||
          parsed < 0 ||
          (maxQty > 0 && parsed > maxQty) ||
          parsed > line.qtyInWarehouse) {
        qtyErrors[key] = AppTexts.dmInvalidQuantity;
        ok = false;
      } else {
        qtyErrors[key] = null;
        if (parsed > 0) anyPositive = true;
      }
    }
    qtyErrors.refresh();
    if (ok && !anyPositive) {
      AppToast.showError(AppTexts.dmLoadPickEmpty);
      return false;
    }
    return ok;
  }

  Future<void> confirmCollectivePick() async {
    final current = load.value;
    if (current == null || isSubmitting.value) return;
    if (!_validateCollective()) {
      if (qtyErrors.values.any((e) => e != null)) {
        AppToast.showError(AppTexts.dmInvalidQuantity);
      }
      return;
    }

    isSubmitting.value = true;
    try {
      final lines = <({int productId, double qty})>[];
      for (final line in remainingPickLines) {
        final qty = double.parse((qtyDrafts[_key(line)] ?? '0').trim());
        if (qty > 0) {
          lines.add((productId: line.productId, qty: qty));
        }
      }
      load.value = await _loadService.pickCollective(lines: lines);
      _seedDrafts(load.value!);
      AppToast.showSuccess(AppTexts.dmLoadPickConfirmed);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Depart for route, then open Today Plan.
  Future<void> departToTodayPlan() async {
    if (!canDepart || isSubmitting.value) return;
    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmDepartTitle,
      message: AppTexts.dmDepartConfirmMessage,
      confirmLabel: AppTexts.dmDepartTitle,
    );
    if (confirmed != true) return;

    isSubmitting.value = true;
    try {
      await _sessionService.depart();
      AppToast.showSuccess(AppTexts.dmDepartSuccess);
      await loadToday(force: true);
      if (Get.isRegistered<DeliveryManShellController>()) {
        Get.find<DeliveryManShellController>().selectLeaf('dm_orders');
      }
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }
}
