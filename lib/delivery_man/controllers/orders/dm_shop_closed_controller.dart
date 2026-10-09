import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/media/app_image_compress.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';

class DmShopClosedController extends GetxController {
  DmShopClosedController(this._planService);

  final DmPlanService _planService;
  final ImagePicker _picker = ImagePicker();

  final RxBool isActing = false.obs;
  final RxBool isPickingPhoto = false.obs;
  final Rxn<Uint8List> photoBytes = Rxn<Uint8List>();
  final notesController = TextEditingController();

  int get jobId {
    final fromParams = Get.parameters['id'];
    if (fromParams != null && fromParams.isNotEmpty) {
      return int.tryParse(fromParams) ?? 0;
    }
    final args = Get.arguments;
    if (args is Map && args['jobId'] != null) {
      return int.tryParse(args['jobId'].toString()) ?? 0;
    }
    return 0;
  }

  String get shopName {
    final args = Get.arguments;
    if (args is Map && args['shopName'] != null) {
      return args['shopName'].toString();
    }
    return '';
  }

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  Future<void> pickPhoto() async {
    // Shop closed proof is camera-only (no gallery).
    isPickingPhoto.value = true;
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: AppImageCompress.pickerQuality,
      );
      if (file == null) return;
      final raw = await file.readAsBytes();
      photoBytes.value = await AppImageCompress.compress(raw);
    } finally {
      isPickingPhoto.value = false;
    }
  }

  Future<void> submit() async {
    if (isActing.value) return;
    if (jobId <= 0) {
      AppToast.showError(AppTexts.error);
      return;
    }

    final notes = notesController.text.trim();
    if (notes.isEmpty) {
      AppToast.showError(AppTexts.dmShopClosedNotesRequired);
      return;
    }
    final photo = photoBytes.value;
    if (photo == null || photo.isEmpty) {
      AppToast.showError(AppTexts.dmShopClosedPhotoRequired);
      return;
    }

    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmShopClosedTitle,
      message: AppTexts.dmShopClosedConfirmMessage,
      confirmLabel: AppTexts.dmShopClosedTitle,
    );
    if (confirmed != true) return;

    isActing.value = true;
    try {
      await _planService.markShopClosed(
        jobId: jobId,
        notes: notes,
        shopClosedImageBase64: base64Encode(photo),
      );
      AppToast.showSuccess(AppTexts.dmShopClosedSuccess);
      _returnToTodayPlan();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isActing.value = false;
    }
  }

  void _returnToTodayPlan() {
    if (Get.isRegistered<DeliveryManShellController>()) {
      Get.find<DeliveryManShellController>().selectLeaf('dm_orders');
    }
    // Leave shop-closed and job-detail screens.
    Get.until(
      (route) =>
          route.settings.name == AppRoutes.deliveryMan ||
          !(Get.key.currentState?.canPop() ?? false),
    );
  }
}
