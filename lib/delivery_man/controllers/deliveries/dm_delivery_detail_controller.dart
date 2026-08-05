import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';

class DmDeliveryDetailController extends GetxController {
  DmDeliveryDetailController(this._deliveryService);

  final DmDeliveryService _deliveryService;
  final RxBool isLoading = true.obs;
  final Rxn<DmDeliveryOrderModel> delivery = Rxn<DmDeliveryOrderModel>();
  final Rxn<Uint8List> proofPhotoBytes = Rxn<Uint8List>();

  String get deliveryId => Get.parameters['id'] ?? '';

  @override
  void onInit() {
    super.onInit();
    loadDelivery();
  }

  Future<void> loadDelivery() async {
    isLoading.value = true;
    try {
      final data = await _deliveryService.fetchOrderById(deliveryId);
      delivery.value = data;
      proofPhotoBytes.value = _decodeProof(data?.proofPhotoBase64);
    } finally {
      isLoading.value = false;
    }
  }

  Uint8List? _decodeProof(String? base64) {
    if (base64 == null || base64.isEmpty) return null;
    try {
      return base64Decode(base64);
    } catch (_) {
      return null;
    }
  }
}
