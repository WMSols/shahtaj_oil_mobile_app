import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_map_tiles.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_shop_service.dart';

class ObShopDetailController extends GetxController {
  ObShopDetailController(this._shopService);

  final ObShopService _shopService;

  final RxBool isLoading = true.obs;
  final Rxn<ObShopModel> shop = Rxn<ObShopModel>();

  String get shopId => Get.parameters['id'] ?? '';

  @override
  void onInit() {
    super.onInit();
    loadShop();
  }

  Future<void> loadShop() async {
    if (shopId.isEmpty) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    try {
      shop.value = await _shopService.fetchShop(shopId);
    } catch (_) {
      shop.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> callOwner() async {
    final phone = shop.value?.phone;
    if (phone == null || phone.trim().isEmpty) return;

    final normalized = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri(scheme: 'tel', path: normalized);
    try {
      await launchUrl(uri);
    } catch (e, stackTrace) {
      debugPrint('ObShopDetailController: call failed — $e');
      debugPrint('$stackTrace');
    }
  }

  Future<void> openDirections() async {
    final current = shop.value;
    if (current == null || !current.hasCoordinates) return;
    await _openMaps(current.latitude!, current.longitude!);
  }

  Future<void> viewOnMap() => openDirections();

  void editShop() {
    if (shopId.isEmpty) return;
    Get.toNamed(AppRoutes.obShopEdit.replaceFirst(':id', shopId));
  }

  void createOrder() => Get.toNamed(AppRoutes.obOrderCreate);

  void checkInToShop() => Get.toNamed(AppRoutes.obCheckIn);

  Future<void> _openMaps(double latitude, double longitude) async {
    final uris = [
      AppMapTiles.googleMapsNavigationUri(latitude, longitude),
      AppMapTiles.googleMapsGeoUri(latitude, longitude),
    ];

    for (final uri in uris) {
      try {
        final opened = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (opened) return;
      } catch (e, stackTrace) {
        debugPrint('ObShopDetailController: failed to open $uri — $e');
        debugPrint('$stackTrace');
      }
    }
  }
}
