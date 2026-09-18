import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_line_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/load/dm_load_today_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/load/dm_pick_line_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/load/dm_load_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';

class DmPickupController extends GetxController {
  DmPickupController(this._loadService);

  final DmLoadService _loadService;

  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString error = RxnString();
  final Rxn<DmLoadTodayModel> load = Rxn<DmLoadTodayModel>();

  /// Collective pick drafts keyed by product id.
  final RxMap<String, String> qtyDrafts = <String, String>{}.obs;
  final RxMap<String, String?> qtyErrors = <String, String?>{}.obs;
  final Map<String, TextEditingController> qtyControllers = {};

  /// Per-job pick drafts keyed by `jobId:lineId`.
  final RxMap<String, String> jobQtyDrafts = <String, String>{}.obs;
  final RxMap<String, String?> jobQtyErrors = <String, String?>{}.obs;
  final Map<String, TextEditingController> jobQtyControllers = {};
  final RxnInt expandedJobId = RxnInt();
  final RxnInt submittingJobId = RxnInt();

  bool get hasRemainingToPick =>
      (load.value?.pickLines ?? const []).any((l) => l.qtyToPick > 0);

  @override
  void onInit() {
    super.onInit();
    loadToday();
  }

  @override
  void onClose() {
    _disposeQtyControllers();
    _disposeJobQtyControllers();
    super.onClose();
  }

  void _disposeQtyControllers() {
    for (final c in qtyControllers.values) {
      c.dispose();
    }
    qtyControllers.clear();
  }

  void _disposeJobQtyControllers() {
    for (final c in jobQtyControllers.values) {
      c.dispose();
    }
    jobQtyControllers.clear();
  }

  String _key(DmPickLineModel line) => '${line.productId}';

  String _jobLineKey(int jobId, DmJobLineModel line) => '$jobId:${line.lineId}';

  TextEditingController qtyControllerFor(DmPickLineModel line) {
    final key = _key(line);
    return qtyControllers.putIfAbsent(
      key,
      () => TextEditingController(text: qtyDrafts[key] ?? ''),
    );
  }

  TextEditingController jobQtyControllerFor(int jobId, DmJobLineModel line) {
    final key = _jobLineKey(jobId, line);
    return jobQtyControllers.putIfAbsent(
      key,
      () => TextEditingController(text: jobQtyDrafts[key] ?? ''),
    );
  }

  Color stripeColorFor(DmPickLineModel line) {
    if (line.qtyToPick <= 0) return AppColors.success;
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
      _seedJobDrafts(data);
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
      final key = _key(line);
      final suggested = line.qtyToPick > 0
          ? line.qtyToPick.round().toString()
          : '0';
      qtyDrafts[key] = suggested;
      qtyControllers[key] = TextEditingController(text: suggested);
    }
    qtyDrafts.refresh();
  }

  void _seedJobDrafts(DmLoadTodayModel data) {
    _disposeJobQtyControllers();
    jobQtyDrafts.clear();
    jobQtyErrors.clear();
    for (final shop in data.shops) {
      for (final line in shop.lines) {
        final key = _jobLineKey(shop.jobId, line);
        final remaining = line.qtyStill > 0
            ? line.qtyStill
            : (line.qtyAssigned - line.qtyPicked);
        final suggested = remaining > 0 ? remaining.round().toString() : '0';
        jobQtyDrafts[key] = suggested;
        jobQtyControllers[key] = TextEditingController(text: suggested);
      }
    }
    jobQtyDrafts.refresh();
  }

  void toggleJobExpanded(int jobId) {
    expandedJobId.value = expandedJobId.value == jobId ? null : jobId;
  }

  void onQtyChanged(DmPickLineModel line, String raw) {
    final key = _key(line);
    qtyDrafts[key] = raw;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      qtyErrors[key] = null;
    } else {
      final parsed = double.tryParse(trimmed);
      final maxQty = line.qtyToPick > 0 ? line.qtyToPick : line.qtyStill;
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

  void onJobQtyChanged(int jobId, DmJobLineModel line, String raw) {
    final key = _jobLineKey(jobId, line);
    jobQtyDrafts[key] = raw;
    final trimmed = raw.trim();
    final maxQty = line.qtyStill > 0
        ? line.qtyStill
        : (line.qtyAssigned - line.qtyPicked);
    if (trimmed.isEmpty) {
      jobQtyErrors[key] = null;
    } else {
      final parsed = double.tryParse(trimmed);
      if (parsed == null || parsed < 0 || (maxQty > 0 && parsed > maxQty)) {
        jobQtyErrors[key] = AppTexts.dmInvalidQuantity;
      } else {
        jobQtyErrors[key] = null;
      }
    }
    jobQtyDrafts.refresh();
    jobQtyErrors.refresh();
  }

  bool _validateCollective() {
    final current = load.value;
    if (current == null) return false;
    var ok = true;
    var anyPositive = false;
    for (final line in current.pickLines) {
      final key = _key(line);
      final raw = (qtyDrafts[key] ?? '').trim();
      final parsed = double.tryParse(raw);
      final maxQty = line.qtyToPick > 0 ? line.qtyToPick : line.qtyStill;
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

  bool _validateJob(DmJobModel job) {
    var ok = true;
    var anyPositive = false;
    for (final line in job.lines) {
      final key = _jobLineKey(job.jobId, line);
      final raw = (jobQtyDrafts[key] ?? '').trim();
      final parsed = double.tryParse(raw);
      final maxQty = line.qtyStill > 0
          ? line.qtyStill
          : (line.qtyAssigned - line.qtyPicked);
      if (parsed == null || parsed < 0 || (maxQty > 0 && parsed > maxQty)) {
        jobQtyErrors[key] = AppTexts.dmInvalidQuantity;
        ok = false;
      } else {
        jobQtyErrors[key] = null;
        if (parsed > 0) anyPositive = true;
      }
    }
    jobQtyErrors.refresh();
    if (ok && !anyPositive) {
      AppToast.showError(AppTexts.dmLoadPickEmpty);
      return false;
    }
    return ok;
  }

  void goToVanStock() {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf('dm_van_stock');
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
      for (final line in current.pickLines) {
        final qty = double.parse((qtyDrafts[_key(line)] ?? '0').trim());
        if (qty > 0) {
          lines.add((productId: line.productId, qty: qty));
        }
      }
      load.value = await _loadService.pickCollective(lines: lines);
      _seedDrafts(load.value!);
      _seedJobDrafts(load.value!);
      AppToast.showSuccess(AppTexts.dmLoadPickConfirmed);
      goToVanStock();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> confirmJobPick(DmJobModel job) async {
    if (isSubmitting.value || submittingJobId.value != null) return;
    if (job.lines.isEmpty) {
      AppToast.showError(AppTexts.dmJobPickNoLines);
      return;
    }
    if (!_validateJob(job)) {
      if (jobQtyErrors.values.any((e) => e != null)) {
        AppToast.showError(AppTexts.dmInvalidQuantity);
      }
      return;
    }

    submittingJobId.value = job.jobId;
    isSubmitting.value = true;
    try {
      final lines = <({int lineId, double qty})>[];
      for (final line in job.lines) {
        final qty = double.parse(
          (jobQtyDrafts[_jobLineKey(job.jobId, line)] ?? '0').trim(),
        );
        if (qty > 0) {
          lines.add((lineId: line.lineId, qty: qty));
        }
      }
      await _loadService.pickJob(jobId: job.jobId, lines: lines);
      await loadToday(force: true);
      AppToast.showSuccess(AppTexts.dmJobPickConfirmed);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      submittingJobId.value = null;
      isSubmitting.value = false;
    }
  }
}
