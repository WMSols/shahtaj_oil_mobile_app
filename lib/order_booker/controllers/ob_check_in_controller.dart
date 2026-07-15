import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_location_helper.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';

class ObCheckInController extends GetxController {
  ObCheckInController(this._taskService);

  final ObTaskService _taskService;

  final RxBool isLoading = true.obs;
  final RxBool isLocating = false.obs;
  final RxBool isSubmitting = false.obs;
  final Rxn<ObTaskModel> task = Rxn<ObTaskModel>();

  /// Device GPS used for check-in (must be captured via Current location).
  final checkInLatitude = Rxn<double>();
  final checkInLongitude = Rxn<double>();

  int? get taskId =>
      Get.arguments is Map ? (Get.arguments as Map)['taskId'] as int? : null;

  String? get shopId =>
      Get.arguments is Map ? (Get.arguments as Map)['shopId'] as String? : null;

  /// Shop pin for map preview only — does not enable check-in.
  double? get shopLatitude => task.value?.shopLatitude;
  double? get shopLongitude => task.value?.shopLongitude;

  bool get hasDeviceLocation {
    final lat = checkInLatitude.value;
    final lng = checkInLongitude.value;
    return lat != null && lng != null && lat.abs() <= 90 && lng.abs() <= 180;
  }

  String get locationLabel => hasDeviceLocation
      ? AppFormatter.coordinates(
          checkInLatitude.value!,
          checkInLongitude.value!,
        )
      : AppTexts.obLocationNotCaptured;

  @override
  void onInit() {
    super.onInit();
    _loadTask();
  }

  Future<void> _loadTask() async {
    isLoading.value = true;
    try {
      ObTaskModel? resolved;
      final id = taskId;
      if (id != null) {
        resolved = await _taskService.findTaskById(id);
      } else if (shopId != null && shopId!.isNotEmpty) {
        resolved = await _taskService.findTaskByShopId(shopId!);
      }

      task.value = resolved;

      final active = await _taskService.fetchActiveVisit();
      if (active != null &&
          resolved != null &&
          active.taskId != resolved.id &&
          active.shopId != resolved.shopId) {
        _showMessage(AppTexts.obShopVisitActiveElsewhere);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> useCurrentLocation() async {
    isLocating.value = true;
    try {
      final position = await AppLocationHelper.requireCurrentPosition();
      checkInLatitude.value = position.latitude;
      checkInLongitude.value = position.longitude;
    } on ApiException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage(AppTexts.obLocationFetchFailed);
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> checkIn() async {
    final current = task.value;
    if (current == null || !hasDeviceLocation) {
      _showMessage(AppTexts.obLocationNotCaptured);
      return;
    }

    final active = await _taskService.fetchActiveVisit();
    if (active != null &&
        active.taskId != current.id &&
        active.shopId != current.shopId) {
      _showMessage(AppTexts.obShopVisitActiveElsewhere);
      return;
    }

    isSubmitting.value = true;
    try {
      final visit = await _taskService.checkIn(
        taskId: current.id,
        latitude: checkInLatitude.value!,
        longitude: checkInLongitude.value!,
      );
      _showMessage(AppTexts.obCheckInSuccess, isError: false);
      Get.offNamed(
        AppRoutes.obOrderCreate,
        arguments: {'visitId': visit.visitId},
      );
    } on ApiException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> confirmSkip() async {
    final current = task.value;
    if (current == null) return;

    final confirmed = await Get.dialog<bool>(
      AppConfirmDialog(
        title: AppTexts.obSkipTaskTitle,
        message: AppTexts.obSkipTaskMessage,
        confirmLabel: AppTexts.obTaskSkip,
      ),
    );
    if (confirmed != true) return;

    isSubmitting.value = true;
    try {
      await _taskService.skipTask(current.id);
      if (Get.currentRoute == AppRoutes.obCheckIn) {
        Get.back(result: true);
      }
    } on ApiException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    if (isError) {
      AppToast.showError(message);
    } else {
      AppToast.showSuccess(message);
    }
  }
}
