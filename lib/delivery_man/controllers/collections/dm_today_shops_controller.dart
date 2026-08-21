import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_shop_due_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

enum DmShopDueFilter { all, highDue, partial }

class DmTodayShopsController extends GetxController with CachedLoadMixin {
  DmTodayShopsController(this._store);

  final DmCollectionStore _store;

  final RxList<DmShopDueModel> shops = <DmShopDueModel>[].obs;
  final RxString searchQuery = ''.obs;
  final Rxn<DmShopDueFilter> dueFilter = Rxn<DmShopDueFilter>(
    DmShopDueFilter.all,
  );

  @override
  bool get hasCachedData => shops.isNotEmpty;

  @override
  String get loadFailedMessage => AppTexts.emptyLoadFailedSubtitle;

  @override
  void onInit() {
    super.onInit();
    DmServicesBinding.ensureRegistered();
    loadShops();
  }

  List<DmShopDueModel> get filteredShops {
    final query = searchQuery.value.trim().toLowerCase();
    final filter = dueFilter.value ?? DmShopDueFilter.all;

    return shops
        .where((shop) {
          final matchesFilter = switch (filter) {
            DmShopDueFilter.all => true,
            DmShopDueFilter.highDue => shop.hasHighDue,
            DmShopDueFilter.partial => _store.shopHasPartialPayment(shop.id),
          };
          if (!matchesFilter) return false;
          if (query.isEmpty) return true;
          return shop.name.toLowerCase().contains(query) ||
              shop.ownerName.toLowerCase().contains(query) ||
              shop.phone.toLowerCase().contains(query) ||
              shop.address.toLowerCase().contains(query);
        })
        .toList(growable: false);
  }

  bool isFilterSelected(DmShopDueFilter filter) => dueFilter.value == filter;

  void selectFilter(DmShopDueFilter filter) => dueFilter.value = filter;

  void onSearchChanged(String value) => searchQuery.value = value;

  Future<void> loadShops({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _store.hydrate();
    final rows = [..._store.shopsWithDue]
      ..sort((a, b) => b.outstanding.compareTo(a.outstanding));
    shops.assignAll(rows);
  }

  bool shopIsPartial(DmShopDueModel shop) =>
      _store.shopHasPartialPayment(shop.id);

  void openShop(DmShopDueModel shop) {
    Get.toNamed(
      AppRoutes.dmShopOutstanding.replaceFirst(':id', shop.id),
      arguments: {'shopId': shop.id},
    );
  }
}
