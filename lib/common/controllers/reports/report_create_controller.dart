import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shahtaj_oil_mobile_app/common/controllers/reports/reports_list_controller.dart';
import 'package:shahtaj_oil_mobile_app/common/models/reports/report_tag_model.dart';
import 'package:shahtaj_oil_mobile_app/common/services/reports/reports_service.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/media/app_image_compress.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

class ReportCreateController extends GetxController {
  ReportCreateController(this._service);

  final ReportsService _service;
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoadingTags = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isPickingPhoto = false.obs;
  final RxBool tagsFailed = false.obs;
  final RxList<ReportTagModel> tags = <ReportTagModel>[].obs;
  final RxSet<String> selectedCodes = <String>{}.obs;
  final Rxn<Uint8List> screenshotBytes = Rxn<Uint8List>();

  final subject = ''.obs;
  final description = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Always fetch tags when New Report opens (not only from stale memory).
    loadTags(force: true);
  }

  Future<void> loadTags({bool force = true}) async {
    isLoadingTags.value = true;
    tagsFailed.value = false;
    try {
      final loaded = await _service.fetchTags(force: force);
      tags.assignAll(loaded);
      if (loaded.isEmpty) tagsFailed.value = true;
    } catch (_) {
      tags.clear();
      tagsFailed.value = true;
    } finally {
      isLoadingTags.value = false;
    }
  }

  void onSubjectChanged(String value) => subject.value = value;
  void onDescriptionChanged(String value) => description.value = value;

  void toggleTag(ReportTagModel tag) {
    if (selectedCodes.contains(tag.code)) {
      selectedCodes.remove(tag.code);
    } else {
      selectedCodes.add(tag.code);
    }
    selectedCodes.refresh();
  }

  Future<void> pickScreenshot() async {
    final source = await Get.bottomSheet<ImageSource>(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(AppIcons.cameraOutlined),
              title: Text(AppTexts.obPickFromCamera),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(AppIcons.image5),
              title: Text(AppTexts.obPickFromGallery),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
    if (source == null) return;
    isPickingPhoto.value = true;
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: AppImageCompress.pickerQuality,
      );
      if (file == null) return;
      final raw = await file.readAsBytes();
      screenshotBytes.value = await AppImageCompress.compress(raw);
    } finally {
      isPickingPhoto.value = false;
    }
  }

  Future<void> submit() async {
    if (subject.value.trim().isEmpty) {
      AppToast.showWarning(AppTexts.reportNeedSubject);
      return;
    }
    if (description.value.trim().isEmpty) {
      AppToast.showWarning(AppTexts.reportNeedDescription);
      return;
    }
    if (selectedCodes.isEmpty) {
      AppToast.showWarning(AppTexts.reportNeedTag);
      return;
    }
    if (isSubmitting.value) return;

    isSubmitting.value = true;
    try {
      final result = await _service.createReport(
        subject: subject.value,
        description: description.value,
        tagCodes: selectedCodes.toList(growable: false),
        screenshotBytes: screenshotBytes.value,
      );
      if (result.queued) {
        AppToast.showInformation(AppTexts.reportQueued);
      } else {
        AppToast.showSuccess(AppTexts.reportSent);
      }
      if (Get.isRegistered<ReportsListController>()) {
        await Get.find<ReportsListController>().load(reset: true, force: true);
      }
      Get.back(result: true);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isSubmitting.value = false;
    }
  }
}
