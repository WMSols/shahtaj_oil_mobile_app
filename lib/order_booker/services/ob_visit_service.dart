import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_model.dart';

class ObVisitService extends GetxService {
  ObVisitService(this._api);
  final ApiClient _api;

  Future<ObActiveVisitModel?> fetchActiveVisit() async {
    final response = await _api.get(ApiEndpoints.obVisitsActive);
    final data = response.data;
    if (data is! Map<String, dynamic> || data.isEmpty) return null;
    return ObActiveVisitModel.fromJson(data);
  }

  Future<ObVisitModel> checkIn({
    required int taskId,
    required double latitude,
    required double longitude,
  }) async {
    final response = await _api.post(
      ApiEndpoints.obTasksCheckIn,
      data: {'task_id': taskId, 'latitude': latitude, 'longitude': longitude},
    );
    return ObVisitModel.fromJson(response.data as Map<String, dynamic>);
  }
}
