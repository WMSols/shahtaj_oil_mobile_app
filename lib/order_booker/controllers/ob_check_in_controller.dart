import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';
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

  final checkInLatitude = Rxn<double>();
  final checkInLongitude = Rxn<double>();

  int? get taskId =>
      Get.arguments is Map ? (Get.arguments as Map)['taskId'] as int? : null;

  String? get shopId =>
      Get.arguments is Map ? (Get.arguments as Map)['shopId'] as String? : null;

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

  Future<bool> _captureDeviceLocation() async {
    isLocating.value = true;
    try {
      final position = await AppHelper.requireCurrentPosition(showGuide: true);
      checkInLatitude.value = position.latitude;
      checkInLongitude.value = position.longitude;
      return true;
    } on ApiException catch (e) {
      _showMessage(e.message);
      return false;
    } catch (_) {
      _showMessage(AppTexts.obLocationFetchFailed);
      return false;
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> checkIn() async {
    final current = task.value;
    if (current == null) return;

    if (!hasDeviceLocation) {
      final captured = await _captureDeviceLocation();
      if (!captured || !hasDeviceLocation) return;
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

  void _showMessage(String message, {bool isError = true}) {
    if (isError) {
      AppToast.showError(message);
    } else {
      AppToast.showSuccess(message);
    }
  }
}
