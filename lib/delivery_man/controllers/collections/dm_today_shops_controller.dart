import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recover_shop_item.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/walk_in_deliver/dm_walk_in_registry.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

/// Recovery shop picker: today's plan shops + recovery invoice summary.
class DmTodayShopsController extends GetxController {
  DmTodayShopsController(this._planService, this._recoveryService);

  final DmPlanService _planService;
  final DmRecoveryService _recoveryService;

  static const _hydrateConcurrency = 3;

  final RxBool isLoading = true.obs;
  final RxBool isHydrating = false.obs;
  final RxnString error = RxnString();
  final RxList<DmRecoverShopItem> shops = <DmRecoverShopItem>[].obs;
  final RxString query = ''.obs;

  Timer? _debounce;
  int _loadToken = 0;

  List<DmRecoverShopItem> get visibleShops {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return shops.toList(growable: false);
    return shops
        .where((shop) {
          final name = shop.shopName.toLowerCase();
          final order = (shop.orderName ?? '').toLowerCase();
          return name.contains(q) ||
              order.contains(q) ||
              shop.shopId.contains(q);
        })
        .toList(growable: false);
  }

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    // Cache-first on open; pull-to-refresh still forces network.
    loadShops(force: false);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void onSearchChanged(String value) {
    query.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      query.refresh();
    });
  }

  Future<void> loadShops({bool force = true}) async {
    final token = ++_loadToken;
    isLoading.value = true;
    error.value = null;
    try {
      if (Get.isRegistered<DmWalkInRegistry>()) {
        await Get.find<DmWalkInRegistry>().hydrate();
      }
      final plan = await _planService.fetchToday(forceNetwork: force);
      if (token != _loadToken) return;

      final byShop = <String, DmRecoverShopItem>{};
      for (final job in plan.jobs) {
        if (_isWalkInJob(job)) continue;
        final id = job.shopId.trim();
        if (id.isEmpty) continue;
        byShop.putIfAbsent(
          id,
          () => DmRecoverShopItem(
            shopId: id,
            shopName: job.shopName,
            orderName: job.orderName,
          ),
        );
      }
      final rows = byShop.values.toList()
        ..sort((a, b) => a.shopName.compareTo(b.shopName));
      shops.assignAll(rows);
      isLoading.value = false;

      // Fast pass from cache, then optional network refresh in one UI write.
      await _hydrateRecovery(rows, forceNetwork: false, token: token);
      if (token != _loadToken) return;
      if (force) {
        unawaited(
          _hydrateRecovery(
            shops.toList(growable: false),
            forceNetwork: true,
            token: token,
          ),
        );
      }
    } on ApiException catch (e) {
      if (token != _loadToken) return;
      error.value = e.message;
      if (shops.isEmpty) AppToast.showError(e.message);
      isLoading.value = false;
    } catch (_) {
      if (token != _loadToken) return;
      error.value = AppTexts.emptyLoadFailedSubtitle;
      if (shops.isEmpty) AppToast.showError(AppTexts.error);
      isLoading.value = false;
    }
  }

  Future<void> _hydrateRecovery(
    List<DmRecoverShopItem> rows, {
    required bool forceNetwork,
    required int token,
  }) async {
    if (rows.isEmpty) return;
    isHydrating.value = true;
    try {
      final merged = <String, DmRecoverShopItem>{
        for (final row in rows) row.shopId: row,
      };

      for (var i = 0; i < rows.length; i += _hydrateConcurrency) {
        if (token != _loadToken) return;
        final chunk = rows.skip(i).take(_hydrateConcurrency).toList();
        final results = await Future.wait([
          for (final row in chunk)
            _fetchRecoverItem(row, forceNetwork: forceNetwork),
        ]);
        if (token != _loadToken) return;

        var changed = false;
        for (final result in results) {
          if (result.exclude) {
            merged.remove(result.shopId);
            changed = true;
            continue;
          }
          final item = result.item;
          if (item == null) continue;
          merged[item.shopId] = item;
          changed = true;
        }
        if (!changed) continue;

        final next = merged.values.toList()
          ..sort((a, b) => a.shopName.compareTo(b.shopName));
        shops.assignAll(next);
      }
    } finally {
      if (token == _loadToken) isHydrating.value = false;
    }
  }

  Future<_HydrateResult> _fetchRecoverItem(
    DmRecoverShopItem row, {
    required bool forceNetwork,
  }) async {
    final id = int.tryParse(row.shopId);
    if (id == null) return _HydrateResult.keep(row.shopId);
    try {
      final data = await _recoveryService.fetchShop(
        id,
        forceNetwork: forceNetwork,
        trackActive: false,
      );
      if (_isNonRecoverableCategory(data.shopCategory)) {
        await _rememberWalkInShop(row.shopId);
        return _HydrateResult.excluded(row.shopId);
      }
      return _HydrateResult.updated(
        DmRecoverShopItem.fromRecovery(data, orderName: row.orderName),
      );
    } on ApiException catch (e) {
      if (_isRecoveryUnavailable(e.message)) {
        await _rememberWalkInShop(row.shopId);
        return _HydrateResult.excluded(row.shopId);
      }
      return _HydrateResult.keep(row.shopId);
    } catch (_) {
      return _HydrateResult.keep(row.shopId);
    }
  }

  bool _isWalkInJob(DmJobModel job) {
    if (job.isWalkIn) return true;
    if (!Get.isRegistered<DmWalkInRegistry>()) return false;
    final registry = Get.find<DmWalkInRegistry>();
    return registry.isWalkInJob(job.jobId) || registry.isWalkInShop(job.shopId);
  }

  bool _isNonRecoverableCategory(String? category) {
    final value = (category ?? '')
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    if (value.isEmpty) return false;
    return value.contains('walk_in') ||
        value.contains('walkin') ||
        value == 'cash_and_carry';
  }

  bool _isRecoveryUnavailable(String message) {
    final lower = message.toLowerCase();
    return lower.contains('only available for shahtaj') ||
        lower.contains('shahtaj shops') ||
        lower.contains('walk-in') ||
        lower.contains('walk in');
  }

  Future<void> _rememberWalkInShop(String shopId) async {
    if (!Get.isRegistered<DmWalkInRegistry>()) return;
    await Get.find<DmWalkInRegistry>().remember(shopId: shopId);
  }

  void openShop(DmRecoverShopItem shop) {
    Get.toNamed(
      AppRoutes.dmShopOutstanding.replaceFirst(':id', shop.shopId),
      arguments: {'shopId': shop.shopId},
    );
  }
}

class _HydrateResult {
  const _HydrateResult._({
    required this.shopId,
    this.item,
    this.exclude = false,
  });

  factory _HydrateResult.keep(String shopId) =>
      _HydrateResult._(shopId: shopId);

  factory _HydrateResult.updated(DmRecoverShopItem item) =>
      _HydrateResult._(shopId: item.shopId, item: item);

  factory _HydrateResult.excluded(String shopId) =>
      _HydrateResult._(shopId: shopId, exclude: true);

  final String shopId;
  final DmRecoverShopItem? item;
  final bool exclude;
}
