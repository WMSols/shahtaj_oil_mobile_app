import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

/// Recovery shop picker: today's plan shops only (local filter, no shops/search).
class DmTodayShopsController extends GetxController {
  DmTodayShopsController(this._planService);

  final DmPlanService _planService;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final RxList<DmJobModel> planShops = <DmJobModel>[].obs;
  final RxString query = ''.obs;

  Timer? _debounce;

  List<DmJobModel> get visibleShops {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return planShops.toList(growable: false);
    return planShops
        .where((job) {
          final name = job.shopName.toLowerCase();
          final address = (job.shopAddress ?? '').toLowerCase();
          final order = (job.orderName ?? '').toLowerCase();
          return name.contains(q) || address.contains(q) || order.contains(q);
        })
        .toList(growable: false);
  }

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    loadShops();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void onSearchChanged(String value) {
    query.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      query.refresh();
    });
  }

  Future<void> loadShops({bool force = true}) async {
    isLoading.value = true;
    error.value = null;
    try {
      final plan = await _planService.fetchToday(forceNetwork: force);
      final byShop = <String, DmJobModel>{};
      for (final job in plan.jobs) {
        if (job.isWalkIn) continue;
        byShop.putIfAbsent(job.shopId, () => job);
      }
      final rows = byShop.values.toList()
        ..sort((a, b) => a.shopName.compareTo(b.shopName));
      planShops.assignAll(rows);
    } on ApiException catch (e) {
      error.value = e.message;
      if (planShops.isEmpty) AppToast.showError(e.message);
    } catch (_) {
      error.value = AppTexts.emptyLoadFailedSubtitle;
      if (planShops.isEmpty) AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  void openPlanShop(DmJobModel job) {
    Get.toNamed(
      AppRoutes.dmShopOutstanding.replaceFirst(':id', job.shopId),
      arguments: {'shopId': job.shopId},
    );
  }
}
