import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';

class DmDeliveriesController extends GetxController {
  DmDeliveriesController(this._deliveryService);

  final DmDeliveryService _deliveryService;
  final RxBool isLoading = true.obs;
  final RxList<DmDeliveryOrderModel> deliveries = <DmDeliveryOrderModel>[].obs;
  final RxString query = ''.obs;
  final Rxn<DeliveryStatus> selectedStatus = Rxn<DeliveryStatus>();

  static const _filterStatuses = [
    DeliveryStatus.delivered,
    DeliveryStatus.returned,
  ];

  List<DeliveryStatus> get filterStatuses => _filterStatuses;

  @override
  void onInit() {
    super.onInit();
    loadDeliveries();
  }

  Future<void> loadDeliveries() async {
    isLoading.value = true;
    try {
      final all = await _deliveryService.fetchOrders();
      deliveries.assignAll(
        all
            .where(
              (item) =>
                  item.status == DeliveryStatus.delivered ||
                  item.status == DeliveryStatus.returned,
            )
            .toList(growable: false),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(DeliveryStatus? status) => selectedStatus.value = status;

  bool isFilterSelected(DeliveryStatus? status) =>
      selectedStatus.value == status;

  void onQueryChanged(String value) => query.value = value.trim().toLowerCase();

  List<DmDeliveryOrderModel> get visibleDeliveries {
    final status = selectedStatus.value;
    final q = query.value;
    return deliveries
        .where((order) {
          if (status != null && order.status != status) return false;
          if (q.isEmpty) return true;
          return order.deliveryNumber.toLowerCase().contains(q) ||
              order.orderNumber.toLowerCase().contains(q) ||
              order.shopName.toLowerCase().contains(q);
        })
        .toList(growable: false);
  }

  void openDeliveryDetail(DmDeliveryOrderModel order) {
    Get.toNamed(AppRoutes.dmDeliveryDetail.replaceFirst(':id', order.id));
  }
}
