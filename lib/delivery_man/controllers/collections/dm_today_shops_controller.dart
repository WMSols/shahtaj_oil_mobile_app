import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/shops/dm_free_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/free_deliver/dm_free_deliver_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

/// Recovery shop picker: today's plan shops + `shops/search` (no dues-list API).
class DmTodayShopsController extends GetxController {
  DmTodayShopsController(this._planService, this._freeDeliverService);

  final DmPlanService _planService;
  final DmFreeDeliverService _freeDeliverService;

  final RxBool isLoading = true.obs;
  final RxBool isSearching = false.obs;
  final RxnString error = RxnString();
  final RxList<DmJobModel> planShops = <DmJobModel>[].obs;
  final RxList<DmFreeShopModel> searchShops = <DmFreeShopModel>[].obs;
  final RxString query = ''.obs;

  Timer? _debounce;

  bool get isSearchMode => query.value.trim().isNotEmpty;

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
    if (value.trim().isEmpty) {
      searchShops.clear();
      isSearching.value = false;
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), searchNow);
  }

  Future<void> searchNow() async {
    final q = query.value.trim();
    if (q.isEmpty) return;
    isSearching.value = true;
    try {
      searchShops.assignAll(await _freeDeliverService.searchShops(query: q));
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> loadShops({bool force = true}) async {
    isLoading.value = true;
    error.value = null;
    try {
      final plan = await _planService.fetchToday(forceNetwork: force);
      final byShop = <String, DmJobModel>{};
      for (final job in plan.jobs) {
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

  void openSearchShop(DmFreeShopModel shop) {
    Get.toNamed(
      AppRoutes.dmShopOutstanding.replaceFirst(':id', shop.shopId),
      arguments: {'shopId': shop.shopId},
    );
  }
}
