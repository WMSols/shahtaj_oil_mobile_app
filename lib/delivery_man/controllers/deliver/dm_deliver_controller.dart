import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';

class DmDeliverController extends GetxController {
  DmDeliverController(this._deliveryService);

  final DmDeliveryService _deliveryService;
  final RxBool isLoading = true.obs;
  final RxList<DmDeliveryOrderModel> activeOrders =
      <DmDeliveryOrderModel>[].obs;
  final RxString query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadActive();
  }

  Future<void> loadActive() async {
    isLoading.value = true;
    try {
      activeOrders.assignAll(
        await _deliveryService.fetchByStatuses({
          DeliveryStatus.pickedUp,
          DeliveryStatus.inTransit,
        }),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onQueryChanged(String value) => query.value = value.trim().toLowerCase();

  List<DmDeliveryOrderModel> get visibleOrders {
    final q = query.value;
    if (q.isEmpty) return activeOrders.toList(growable: false);
    return activeOrders
        .where(
          (order) =>
              order.deliveryNumber.toLowerCase().contains(q) ||
              order.orderNumber.toLowerCase().contains(q) ||
              order.shopName.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }

  void openOrder(DmDeliveryOrderModel order) {
    Get.toNamed(AppRoutes.dmOrderDetail.replaceFirst(':id', order.id));
  }
}
