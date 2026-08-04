import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';

class DmOrdersController extends GetxController {
  DmOrdersController(this._deliveryService);

  final DmDeliveryService _deliveryService;

  final RxBool isLoading = true.obs;
  final Rxn<DeliveryStatus> selectedStatus = Rxn<DeliveryStatus>();
  final RxList<DmDeliveryOrderModel> orders = <DmDeliveryOrderModel>[].obs;
  final RxString query = ''.obs;

  static const _filterStatuses = [
    DeliveryStatus.pending,
    DeliveryStatus.pickedUp,
    DeliveryStatus.inTransit,
    DeliveryStatus.delivered,
    DeliveryStatus.returned,
  ];

  List<DeliveryStatus> get filterStatuses => _filterStatuses;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      orders.assignAll(await _deliveryService.fetchOrders());
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(DeliveryStatus? status) => selectedStatus.value = status;

  bool isFilterSelected(DeliveryStatus? status) =>
      selectedStatus.value == status;

  void onQueryChanged(String value) => query.value = value.trim().toLowerCase();

  List<DmDeliveryOrderModel> get visibleOrders {
    final status = selectedStatus.value;
    final q = query.value;
    return orders
        .where((order) {
          if (status != null && order.status != status) return false;
          if (q.isEmpty) return true;
          return order.deliveryNumber.toLowerCase().contains(q) ||
              order.orderNumber.toLowerCase().contains(q) ||
              order.shopName.toLowerCase().contains(q) ||
              (order.shopAddress?.toLowerCase().contains(q) ?? false);
        })
        .toList(growable: false);
  }

  void openOrder(DmDeliveryOrderModel order) {
    Get.toNamed(AppRoutes.dmOrderDetail.replaceFirst(':id', order.id));
  }
}
