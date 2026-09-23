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
import 'package:shahtaj_oil_mobile_app/order_booker/services/visit/ob_visit_session_service.dart';

/// Shared GPS + check-in + verify-on-site / order-create navigation for OB.
///
/// Online it still calls `tasks/check-in` directly so the server can answer
/// with `needs_shop_setup`. Offline, or when that call cannot get through, the
/// visit is opened locally and the check-in is queued.
abstract class ObCheckInFlow {
  ObCheckInFlow._();

  static Future<void> run({
    required ObTaskService taskService,
    required ObTaskModel task,
    required Future<void> Function() onDone,
    ObActiveVisitModel? activeVisit,
    List<ObShopMissingField> missingFields = const [],
    bool forceNeedsSetup = false,
  }) async {
    final session = Get.find<ObVisitSessionService>();

    final other = await session.otherActiveVisit(task.id);
    if (other != null) {
      AppToast.showError(AppTexts.obShopVisitActiveElsewhere);
      return;
    }
    if (activeVisit != null &&
        activeVisit.taskId != task.id &&
        activeVisit.shopId != task.shopId) {
      AppToast.showError(AppTexts.obShopVisitActiveElsewhere);
      return;
    }

    // No pin on file → verify-on-site (device GPS becomes the shop location).
    final needsSetup =
        forceNeedsSetup || task.needsShopSetup || !task.hasShopCoordinates;
    final missing = missingFields.isNotEmpty
        ? missingFields
        : task.missingFields;

    if (needsSetup) {
      AppToast.close();
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
      final position = await AppHelper.requireCurrentPosition(showGuide: true);

      // Capture distance for the distributor panel, then block if beyond max.
      // Far attempts still hit / queue check-in GPS so the panel can show them.
      final gpsPayload = AppHelper.checkInGpsExtras(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMeters: position.accuracy,
        shopLat: task.shopLatitude,
        shopLng: task.shopLongitude,
      );
      if (gpsPayload['out_of_range'] == true) {
        await taskService.reportBlockedGpsAttempt(
          taskId: task.id,
          shopId: task.shopId,
          shopName: task.shopName,
          latitude: position.latitude,
          longitude: position.longitude,
          gpsExtras: gpsPayload,
          purpose: 'check_in',
        );
        AppHelper.ensureWithinShopRange(
          currentLat: position.latitude,
          currentLng: position.longitude,
          shopLat: task.shopLatitude,
          shopLng: task.shopLongitude,
        );
      }

      // Already checked in locally: resume cart instead of queuing again.
      final existing = await session.activeVisit();
      if (existing != null &&
          (existing.taskId == task.id || existing.shopId == task.shopId)) {
        session.publishActiveVisit(existing);
        await _openOrderCreate(existing.visitId, onDone);
        return;
      }

      if (_canReachServer) {
        final resumed = await _resumeExistingServerVisit(
          taskService: taskService,
          task: task,
        );
        if (resumed) {
          await onDone();
          return;
        }

        try {
          final result = await taskService.checkIn(
            taskId: task.id,
            latitude: position.latitude,
            longitude: position.longitude,
            gpsExtras: gpsPayload,
          );

          if (result.needsShopSetup) {
            AppToast.close();
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

          if (result.hasVisit) {
            final visit = await session.adoptServerVisit(
              task: task,
              visit: result.visit!,
              latitude: position.latitude,
              longitude: position.longitude,
            );
            AppToast.showSuccess(AppTexts.obCheckInSuccess);
            await _openOrderCreate(visit.visitId, onDone);
            return;
          }

          AppToast.showError(result.message ?? AppTexts.error);
          return;
        } on ApiException catch (e) {
          // A rejection is final; only connectivity trouble falls back to the
          // offline path so we never hide a real server error.
          if (!_isTransient(e.message)) {
            AppToast.showError(e.message);
            return;
          }
        }
      }

      final visit = await session.startVisit(
        task: task,
        latitude: position.latitude,
        longitude: position.longitude,
        gpsExtras: gpsPayload,
      );
      AppToast.showSuccess(AppTexts.obCheckInQueuedOffline);
      await _openOrderCreate(visit.visitId, onDone);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    }
  }

  static Future<void> _openOrderCreate(
    int visitId,
    Future<void> Function() onDone,
  ) async {
    await Get.toNamed(AppRoutes.obOrderCreate, arguments: {'visitId': visitId});
    await onDone();
  }

  /// Picks up a visit the server already has open for this task.
  static Future<bool> _resumeExistingServerVisit({
    required ObTaskService taskService,
    required ObTaskModel task,
  }) async {
    try {
      final latest = await taskService.fetchActiveVisit();
      if (latest == null) return false;
      if (latest.taskId != task.id && latest.shopId != task.shopId) {
        AppToast.showError(AppTexts.obShopVisitActiveElsewhere);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static bool get _canReachServer {
    if (!Get.isRegistered<ConnectivityService>()) return true;
    final connectivity = Get.find<ConnectivityService>();
    if (!connectivity.isOnline.value) return false;
    return connectivity.quality.value != NetworkQuality.weak;
  }

  static bool _isTransient(String message) {
    final msg = message.toLowerCase();
    return msg.contains('timed out') ||
        msg.contains('timeout') ||
        msg.contains('internet') ||
        msg.contains('connection') ||
        msg.contains('socket') ||
        msg.contains('network') ||
        msg.contains('host');
  }
}
