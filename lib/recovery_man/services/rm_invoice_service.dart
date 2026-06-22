import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/rm_invoice_model.dart';

class RmInvoiceService extends GetxService {
  RmInvoiceService(this._api);
  final ApiClient _api;

  Future<List<RmInvoiceModel>> fetchShopInvoices(String shopId) async {
    final response = await _api.get(
      ApiEndpoints.invoices,
      queryParameters: {'shop_id': shopId},
    );
    return (response.data as List<dynamic>)
        .map((e) => RmInvoiceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
