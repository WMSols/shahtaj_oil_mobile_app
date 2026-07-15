import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_order_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_order_detail_service.dart';

class ObOrderDetailController extends GetxController {
  ObOrderDetailController(this._service);

  final ObOrderDetailService _service;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final Rxn<ObOrderDetailModel> order = Rxn<ObOrderDetailModel>();

  /// Route `:id` / arguments carry the **visit id** (orders come from visits/get).
  String? get visitIdParam {
    final fromParams = Get.parameters['id']?.trim();
    if (fromParams != null && fromParams.isNotEmpty) return fromParams;

    final args = Get.arguments;
    if (args is Map) {
      final visitId = args['visitId'];
      if (visitId != null) return visitId.toString();
    }
    if (args is int || args is String) return args.toString();
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    // Ensure Get.parameters / arguments are available after navigation.
    SchedulerBinding.instance.addPostFrameCallback((_) => load());
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;

    try {
      final args = Get.arguments;
      if (args is Map && args['visitDetail'] is ObVisitDetailModel) {
        order.value = _service.fromVisitDetail(
          args['visitDetail'] as ObVisitDetailModel,
        );
        return;
      }

      final id = visitIdParam;
      if (id == null || id.isEmpty) {
        error.value = AppTexts.obVisitNotFound;
        order.value = null;
        return;
      }

      order.value = await _service.fetchOrderDetail(id);
    } on ApiException catch (e) {
      order.value = null;
      error.value = e.message.isEmpty ? AppTexts.error : e.message;
    } catch (_) {
      order.value = null;
      error.value = AppTexts.error;
    } finally {
      isLoading.value = false;
    }
  }
}
