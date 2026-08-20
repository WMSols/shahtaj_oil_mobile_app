import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_shop_due_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

enum RmShopDueFilter { all, highDue, partial }

class RmTodayShopsController extends GetxController with CachedLoadMixin {
  RmTodayShopsController(this._store);

  final RmCollectionStore _store;

  final RxList<RmShopDueModel> shops = <RmShopDueModel>[].obs;
  final RxString searchQuery = ''.obs;
  final Rxn<RmShopDueFilter> dueFilter = Rxn<RmShopDueFilter>(
    RmShopDueFilter.all,
  );

  @override
  bool get hasCachedData => shops.isNotEmpty;

  @override
  String get loadFailedMessage => AppTexts.emptyLoadFailedSubtitle;

  @override
  void onInit() {
    super.onInit();
    RecoveryManServicesBinding.ensureRegistered();
    loadShops();
  }

  List<RmShopDueModel> get filteredShops {
    final query = searchQuery.value.trim().toLowerCase();
    final filter = dueFilter.value ?? RmShopDueFilter.all;

    return shops
        .where((shop) {
          final matchesFilter = switch (filter) {
            RmShopDueFilter.all => true,
            RmShopDueFilter.highDue => shop.hasHighDue,
            RmShopDueFilter.partial => _store.shopHasPartialPayment(shop.id),
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

  bool isFilterSelected(RmShopDueFilter filter) => dueFilter.value == filter;

  void selectFilter(RmShopDueFilter filter) => dueFilter.value = filter;

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

  bool shopIsPartial(RmShopDueModel shop) =>
      _store.shopHasPartialPayment(shop.id);

  void openShop(RmShopDueModel shop) {
    Get.toNamed(
      AppRoutes.rmShopOutstanding.replaceFirst(':id', shop.id),
      arguments: {'shopId': shop.id},
    );
  }
}
