import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dm_stock_item_model.dart';

class DmDashboardController extends GetxController {
  final RxBool isLoading = true.obs;

  List<DmStockItemModel> get stockItems => AppMockData.dmStockItems;
  int get vanStockCount => AppMockData.dmVanStockCount;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    isLoading.value = false;
  }
}
