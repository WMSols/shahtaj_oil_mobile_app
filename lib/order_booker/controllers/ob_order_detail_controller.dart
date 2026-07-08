import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_order_detail_service.dart';

class ObOrderDetailController extends GetxController {
  ObOrderDetailController(this._service);

  final ObOrderDetailService _service;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final Rxn<ObOrderDetailModel> order = Rxn<ObOrderDetailModel>();

  String? get orderId => Get.parameters['id'];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final id = orderId;
    if (id == null || id.trim().isEmpty) {
      error.value = AppTexts.obVisitNotFound;
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    error.value = null;
    try {
      order.value = await _service.fetchOrderDetail(id);
    } catch (_) {
      order.value = null;
      error.value = AppTexts.error;
    } finally {
      isLoading.value = false;
    }
  }

  void openVisit() {
    final visitId = order.value?.visitId;
    if (visitId == null) return;
    Get.toNamed(AppRoutes.obVisitDetail.replaceFirst(':id', '$visitId'));
  }
}
