import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_dashboard_model.dart';

class ObDashboardService extends GetxService {
  ObDashboardService(this._api);

  final ApiClient _api;

  Future<ObDashboardModel> fetchDashboard() async {
    final _ = _api;
    // Keep a small delay to mimic loading while mock data is active.
    await Future.delayed(const Duration(milliseconds: 250));
    return AppMockData.obDashboard;
  }

  Future<void> startRoute(String routeId) async {
    // API integration point:
    // await _api.post('/api/v1/order-booker/routes/$routeId/start');
  }

  Future<void> continueRoute(String routeId) async {
    // API integration point:
    // await _api.post('/api/v1/order-booker/routes/$routeId/continue');
  }
}
