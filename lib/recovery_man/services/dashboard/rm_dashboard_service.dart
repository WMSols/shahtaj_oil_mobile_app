import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/dashboard/rm_dashboard_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';

class RmDashboardService extends GetxService {
  RmDashboardService(this._store);

  final RmCollectionStore _store;

  Future<RmDashboardModel> fetchDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    await _store.hydrate();
    return RmDashboardModel(
      collectedToday: _store.collectedToday,
      stillDue: _store.stillDue,
      cashInBag: _store.bagTotal,
      shopsDueCount: _store.shopsDueCount,
      recentCollections: _store.recentCollections,
      targets: AppMockData.rmTargets,
    );
  }
}
