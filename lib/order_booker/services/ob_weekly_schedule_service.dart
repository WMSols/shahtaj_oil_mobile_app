// ignore_for_file: unused_field

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_weekly_schedule_model.dart';

class ObWeeklyScheduleService extends GetxService {
  ObWeeklyScheduleService(this._api);

  final ApiClient _api;

  Future<ObWeeklyScheduleModel> fetchWeeklySchedule() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return AppMockData.obWeeklySchedule;

    // final response = await _api.get(ApiEndpoints.obScheduleWeekly);
    // return ObWeeklyScheduleModel.fromJson(response.data as Map<String, dynamic>);
  }
}
