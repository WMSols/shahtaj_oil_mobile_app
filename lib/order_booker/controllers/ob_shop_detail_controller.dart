import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_map_tiles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_shop_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';

class ObShopDetailController extends GetxController {
  ObShopDetailController(this._shopService, this._taskService);

  final ObShopService _shopService;
  final ObTaskService _taskService;

  final RxBool isLoading = true.obs;
  final Rxn<ObShopModel> shop = Rxn<ObShopModel>();
  final Rxn<ObActiveVisitModel> activeVisit = Rxn<ObActiveVisitModel>();
  final Rxn<ObTaskModel> todaysTask = Rxn<ObTaskModel>();

  String get shopId => Get.parameters['id'] ?? '';

  bool get canSellFromShop {
    final status = shop.value?.status;
    return status == ShopStatus.approved || status == ShopStatus.active;
  }

  bool get canEditShop => shop.value?.status == ShopStatus.pending;

  bool get hasActiveVisitHere =>
      activeVisit.value != null && activeVisit.value!.shopId == shopId;

  bool get hasActiveVisitElsewhere {
    final visit = activeVisit.value;
    return visit != null && visit.shopId != shopId;
  }

  bool get canCheckIn {
    if (!canSellFromShop) return false;
    if (hasActiveVisitHere) return false;
    if (hasActiveVisitElsewhere) return false;
    final task = todaysTask.value;
    return task != null && task.status == TaskStatus.pending;
  }

  bool get showResumeOrder => canSellFromShop && hasActiveVisitHere;

  bool get showCheckIn => canCheckIn;

  String get createOrderLabel => hasActiveVisitHere
      ? AppTexts.obResumeVisit
      : AppTexts.obCreateOrderButton;

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
      await refreshVisitState();
    } catch (_) {
      shop.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshVisitState() async {
    activeVisit.value = await _taskService.fetchActiveVisit();
    todaysTask.value = await _taskService.findTaskByShopId(shopId);
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
    if (!canEditShop || shopId.isEmpty) return;
    AppToast.showInformation(AppTexts.obShopEditComingSoon);
  }

  Future<void> createOrder() async {
    await refreshVisitState();

    if (!canSellFromShop) {
      AppToast.showWarning(AppTexts.obShopCannotOrderUntilApproved);
      return;
    }

    if (hasActiveVisitElsewhere) {
      AppToast.showError(AppTexts.obShopVisitActiveElsewhere);
      return;
    }

    final visit = activeVisit.value;
    if (visit == null || visit.shopId != shopId) {
      if (canCheckIn) {
        AppToast.showInformation(AppTexts.obShopCheckInBeforeOrder);
        await checkInToShop();
        return;
      }
      AppToast.showWarning(AppTexts.obShopNotOnRouteToday);
      return;
    }

    await Get.toNamed(
      AppRoutes.obOrderCreate,
      arguments: {'visitId': visit.visitId},
    );
    await refreshVisitState();
  }

  Future<void> checkInToShop() async {
    if (!canSellFromShop) {
      AppToast.showWarning(AppTexts.obShopCannotOrderUntilApproved);
      return;
    }

    if (hasActiveVisitElsewhere) {
      AppToast.showError(AppTexts.obShopVisitActiveElsewhere);
      return;
    }

    if (hasActiveVisitHere) {
      await createOrder();
      return;
    }

    final task = todaysTask.value;
    if (task == null || task.status != TaskStatus.pending) {
      AppToast.showWarning(AppTexts.obShopNotOnRouteToday);
      return;
    }

    await Get.toNamed(
      AppRoutes.obCheckIn,
      arguments: {'shopId': shopId, 'taskId': task.id},
    );
    await refreshVisitState();
  }

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
