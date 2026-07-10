// ignore_for_file: unused_field

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_target_item_model.dart';

class ObTargetsService extends GetxService {
  ObTargetsService(this._api);

  final ApiClient _api;

  Future<List<ObTargetItemModel>> fetchTargets() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return AppMockData.obTargetsList;

    // final response = await _api.get(ApiEndpoints.obTargetsMine);
    // final list = response.data as List<dynamic>;
    // return list
    //     .map((item) => ObTargetItemModel.fromJson(item as Map<String, dynamic>))
    //     .toList();
  }
}
