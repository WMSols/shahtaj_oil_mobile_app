import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_task_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_task_service.dart';

class ObCheckInController extends GetxController {
  ObCheckInController(this._taskService);

  final ObTaskService _taskService;

  final RxBool isLoading = true.obs;
  final RxBool isLocating = false.obs;
  final RxBool isSubmitting = false.obs;
  final Rxn<ObTaskModel> task = Rxn<ObTaskModel>();

  final mapLatitude = Rxn<double>();
  final mapLongitude = Rxn<double>();

  int? get taskId =>
      Get.arguments is Map ? (Get.arguments as Map)['taskId'] as int? : null;

  String? get shopId =>
      Get.arguments is Map ? (Get.arguments as Map)['shopId'] as String? : null;

  bool get hasLocation {
    final lat = mapLatitude.value;
    final lng = mapLongitude.value;
    return lat != null && lng != null && lat.abs() <= 90 && lng.abs() <= 180;
  }

  String get locationLabel => hasLocation
      ? AppFormatter.coordinates(mapLatitude.value!, mapLongitude.value!)
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
      if (resolved != null && resolved.hasShopCoordinates) {
        mapLatitude.value = resolved.shopLatitude;
        mapLongitude.value = resolved.shopLongitude;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> useCurrentLocation() async {
    isLocating.value = true;
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        _showMessage(AppTexts.obLocationDisabled);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showMessage(AppTexts.obLocationPermissionDenied);
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      mapLatitude.value = position.latitude;
      mapLongitude.value = position.longitude;
    } catch (_) {
      _showMessage(AppTexts.obLocationFetchFailed);
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> checkIn() async {
    final current = task.value;
    if (current == null || !hasLocation) {
      _showMessage(AppTexts.obLocationNotCaptured);
      return;
    }

    isSubmitting.value = true;
    try {
      await _taskService.checkIn(
        taskId: current.id,
        latitude: mapLatitude.value!,
        longitude: mapLongitude.value!,
      );
      _showMessage(AppTexts.obCheckInSuccess, isError: false);
      if (Get.currentRoute == AppRoutes.obCheckIn) {
        Get.back(result: true);
      }
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
    } catch (_) {
      _showMessage(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    Get.snackbar(
      isError ? AppTexts.error : AppTexts.done,
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
