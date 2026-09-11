import 'dart:async';

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_active_visit_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/shops/ob_shop_missing_field.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/tasks/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/tasks/ob_task_service.dart';

/// Shared GPS + check-in + verify-on-site / order-create navigation for OB.
abstract class ObCheckInFlow {
  ObCheckInFlow._();

  static const _activeVisitTimeout = Duration(seconds: 12);
  static const _checkInTimeoutWeak = Duration(seconds: 12);
  static const _checkInTimeoutOk = Duration(seconds: 20);

  static Future<void> run({
    required ObTaskService taskService,
    required ObTaskModel task,
    required Future<void> Function() onDone,
    ObActiveVisitModel? activeVisit,
    List<ObShopMissingField> missingFields = const [],
    bool forceNeedsSetup = false,
  }) async {
    if (activeVisit != null &&
        activeVisit.taskId != task.id &&
        activeVisit.shopId != task.shopId) {
      AppToast.showError(AppTexts.obShopVisitActiveElsewhere);
      return;
    }

    final needsSetup = forceNeedsSetup || task.needsShopSetup;
    final missing = missingFields.isNotEmpty
        ? missingFields
        : task.missingFields;

    if (needsSetup) {
      await Get.toNamed(
        AppRoutes.obShopVerifyOnSite,
        arguments: {
          'taskId': task.id,
          'shopId': task.shopId,
          'task': task.toJson(),
          'shopName': task.shopName,
          'ownerName': task.ownerName,
          'missingFields': missing.map((f) => f.toJson()).toList(),
        },
      );
      await onDone();
      return;
    }

    try {
      if (_isOffline()) {
        AppToast.showError(AppTexts.noInternet);
        return;
      }

      final position = await AppHelper.requireCurrentPosition(showGuide: true);
      final weakLink = _isWeakLink();

      final latestActive = weakLink
          ? await taskService.loadCachedActiveVisit()
          : await taskService.fetchActiveVisit().timeout(_activeVisitTimeout);

      if (latestActive != null &&
          latestActive.taskId != task.id &&
          latestActive.shopId != task.shopId) {
        AppToast.showError(AppTexts.obShopVisitActiveElsewhere);
        return;
      }

      final result = await taskService
          .checkIn(
            taskId: task.id,
            latitude: position.latitude,
            longitude: position.longitude,
          )
          .timeout(weakLink ? _checkInTimeoutWeak : _checkInTimeoutOk);

      if (result.needsShopSetup) {
        await Get.toNamed(
          AppRoutes.obShopVerifyOnSite,
          arguments: {
            'taskId': task.id,
            'shopId': task.shopId,
            'task': task.toJson(),
            'latitude': position.latitude,
            'longitude': position.longitude,
            'missingFields': result.missingFields
                .map((f) => f.toJson())
                .toList(),
          },
        );
        await onDone();
        return;
      }

      if (!result.hasVisit) {
        AppToast.showError(result.message ?? AppTexts.error);
        return;
      }

      AppToast.showSuccess(AppTexts.obCheckInSuccess);
      await Get.toNamed(
        AppRoutes.obOrderCreate,
        arguments: {'visitId': result.visit!.visitId},
      );
      await onDone();
    } on TimeoutException {
      AppToast.showError(AppTexts.obCheckInTimedOut);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    }
  }

  static bool _isOffline() {
    if (!Get.isRegistered<ConnectivityService>()) return false;
    final c = Get.find<ConnectivityService>();
    return !c.isOnline.value || c.quality.value == NetworkQuality.offline;
  }

  static bool _isWeakLink() {
    if (!Get.isRegistered<ConnectivityService>()) return false;
    final c = Get.find<ConnectivityService>();
    return !c.isOnline.value || c.quality.value == NetworkQuality.weak;
  }
}
