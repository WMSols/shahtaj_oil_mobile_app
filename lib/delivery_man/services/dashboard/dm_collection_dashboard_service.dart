import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_collection_dashboard_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';

class DmCollectionDashboardService extends GetxService {
  DmCollectionDashboardService(this._store);

  final DmCollectionStore _store;

  Future<DmCollectionDashboardModel> fetchDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    await _store.hydrate();
    final dueShops = [..._store.shopsWithDue]
      ..sort((a, b) => b.outstanding.compareTo(a.outstanding));
    return DmCollectionDashboardModel(
      collectedToday: _store.collectedToday,
      stillDue: _store.stillDue,
      cashInBag: _store.bagTotal,
      shopsDueCount: _store.shopsDueCount,
      bagReceiptCount: _store.bagCollections.length,
      highestDueShop: dueShops.isEmpty ? null : dueShops.first,
      recentCollections: _store.collectionsForHistory(),
      recentHandovers: _store.recentHandovers,
      targets: AppMockData.dmTargets,
    );
  }
}
