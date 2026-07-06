import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/app_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/bindings/ob_shop_onboarding_binding.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_shop_service.dart';

class ObMyShopsController extends GetxController {
  ObMyShopsController(this._shopService);

  final ObShopService _shopService;

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final Rxn<ShopStatus> statusFilter = Rxn<ShopStatus>();
  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final RxList<ObShopModel> shops = <ObShopModel>[].obs;

  static const _filterStatuses = [
    ShopStatus.pending,
    ShopStatus.approved,
    ShopStatus.active,
    ShopStatus.rejected,
  ];

  List<ShopStatus> get filterStatuses => _filterStatuses;

  List<ObShopModel> get filteredShops {
    final query = searchQuery.value.trim().toLowerCase();
    return shops.where((shop) {
      final matchesStatus =
          statusFilter.value == null || shop.status == statusFilter.value;
      if (!matchesStatus) return false;
      if (query.isEmpty) return true;
      return shop.name.toLowerCase().contains(query) ||
          (shop.ownerName?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(
      () => searchQuery.value = searchController.text,
    );
    loadShops();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadShops() async {
    isLoading.value = true;
    error.value = null;
    try {
      shops.assignAll(await _shopService.fetchShops());
    } catch (_) {
      error.value = 'Failed to load shops';
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(ShopStatus? status) => statusFilter.value = status;

  bool isFilterSelected(ShopStatus? status) => statusFilter.value == status;

  void openShop(ObShopModel shop) =>
      Get.toNamed(AppRoutes.obShopDetail.replaceFirst(':id', shop.id));

  void goToRegisterShop({required bool embeddedInShell}) {
    ObShopOnboardingBinding().dependencies();

    if (embeddedInShell && Get.isRegistered<AppShellController>()) {
      Get.find<AppShellController>().selectLeaf('ob_shop_register');
      return;
    }

    Get.toNamed(AppRoutes.obShopOnboarding);
  }
}
