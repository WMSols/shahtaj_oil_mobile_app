import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/shops/dm_free_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/free_deliver/dm_free_deliver_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmFreeDeliverSearchController extends GetxController {
  DmFreeDeliverSearchController(this._service);

  final DmFreeDeliverService _service;

  final RxBool isLoading = false.obs;
  final RxBool hasSearched = false.obs;
  final RxList<DmFreeShopModel> shops = <DmFreeShopModel>[].obs;
  final RxString query = ''.obs;

  Timer? _debounce;

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    search();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void onQueryChanged(String value) {
    query.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), search);
  }

  Future<void> search() async {
    isLoading.value = true;
    try {
      shops.assignAll(await _service.searchShops(query: query.value));
      hasSearched.value = true;
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  void openShop(DmFreeShopModel shop) {
    Get.toNamed(
      AppRoutes.dmFreeDeliverShop.replaceFirst(':shopId', shop.shopId),
      arguments: shop,
    );
  }

  void openRecover(DmFreeShopModel shop) {
    Get.toNamed(
      AppRoutes.dmShopOutstanding.replaceFirst(':id', shop.shopId),
      arguments: {'shopId': shop.shopId},
    );
  }
}
