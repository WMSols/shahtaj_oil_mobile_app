import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/media/app_image_compress.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_line_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/plan/dm_plan_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmJobDetailController extends GetxController {
  DmJobDetailController(this._planService);

  final DmPlanService _planService;
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = true.obs;
  final RxBool isActing = false.obs;
  final Rxn<DmJobModel> job = Rxn<DmJobModel>();
  final RxMap<int, String> qtyDrafts = <int, String>{}.obs;
  final Rxn<Uint8List> proofPhotoBytes = Rxn<Uint8List>();
  final notesController = TextEditingController();
  final receiverController = TextEditingController();

  int get jobId {
    final raw = Get.parameters['id'] ?? Get.arguments?.toString() ?? '';
    return int.tryParse(raw) ?? 0;
  }

  bool get canActOnField {
    final current = job.value;
    if (current == null) return false;
    return current.fieldState == DmFieldState.pending ||
        current.fieldState == DmFieldState.inTransit;
  }

  bool get canDeliver {
    final current = job.value;
    if (current == null || !canActOnField) return false;
    return current.state == DmJobState.picked ||
        current.state == DmJobState.partial ||
        current.state == DmJobState.ready;
  }

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    loadJob();
  }

  @override
  void onClose() {
    notesController.dispose();
    receiverController.dispose();
    super.onClose();
  }

  Future<void> loadJob() async {
    if (jobId <= 0) {
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    try {
      final data = await _planService.fetchJob(jobId);
      job.value = data;
      notesController.text = data.notes ?? '';
      receiverController.text = data.receiverName ?? '';
      _seedQty(data.lines);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  void _seedQty(List<DmJobLineModel> lines) {
    qtyDrafts
      ..clear()
      ..addEntries(
        lines.map((line) {
          final suggested = line.qtyStill > 0
              ? line.qtyStill
              : (line.qtyPicked > 0 ? line.qtyPicked : line.qtyAssigned);
          final text = suggested == suggested.roundToDouble()
              ? suggested.toInt().toString()
              : suggested.toStringAsFixed(1);
          return MapEntry(line.lineId, text);
        }),
      );
    qtyDrafts.refresh();
  }

  void onQtyChanged(int lineId, String raw) {
    qtyDrafts[lineId] = raw;
    qtyDrafts.refresh();
  }

  Future<void> pickProofPhoto() async {
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
              leading: const Icon(AppIcons.photoLibraryOutlined),
              title: Text(AppTexts.obPickFromGallery),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
    if (source == null) return;
    final file = await _picker.pickImage(source: source, imageQuality: 90);
    if (file == null) return;
    final raw = await file.readAsBytes();
    proofPhotoBytes.value = await AppImageCompress.compress(raw);
  }

  void clearProofPhoto() => proofPhotoBytes.value = null;

  List<({int lineId, double qty})> _parsedLines({
    required bool requirePositive,
  }) {
    final current = job.value;
    if (current == null) return const [];
    final out = <({int lineId, double qty})>[];
    for (final line in current.lines) {
      final raw = qtyDrafts[line.lineId]?.trim() ?? '';
      final qty = double.tryParse(raw) ?? 0;
      if (requirePositive && qty <= 0) continue;
      if (qty < 0) continue;
      out.add((lineId: line.lineId, qty: qty));
    }
    return out;
  }

  Future<void> submitDeliver() async {
    final current = job.value;
    if (current == null || !canDeliver || isActing.value) return;

    final lines = _parsedLines(requirePositive: true);
    if (lines.isEmpty) {
      AppToast.showError(AppTexts.dmDeliverQtyRequired);
      return;
    }

    final receiver = receiverController.text.trim();
    if (receiver.isEmpty) {
      AppToast.showError(AppTexts.dmReceiverRequired);
      return;
    }
    final photo = proofPhotoBytes.value;
    if (photo == null || photo.isEmpty) {
      AppToast.showError(AppTexts.dmProofPhotoRequired);
      return;
    }

    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmConfirmDelivery,
      message: AppTexts.dmDeliverConfirmMessage,
      confirmLabel: AppTexts.dmConfirmDelivery,
    );
    if (confirmed != true) return;

    isActing.value = true;
    try {
      final position = await AppHelper.requireCurrentPosition(showGuide: true);
      AppHelper.ensureWithinShopRange(
        currentLat: position.latitude,
        currentLng: position.longitude,
        shopLat: current.latitude,
        shopLng: current.longitude,
      );
      job.value = await _planService.deliver(
        jobId: current.jobId,
        latitude: position.latitude,
        longitude: position.longitude,
        lines: lines,
        receiverName: receiver,
        deliveryProofImageBase64: base64Encode(photo),
      );
      AppToast.showSuccess(AppTexts.dmDeliverSuccess);
      Get.back();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> submitShopClosed() async {
    final current = job.value;
    if (current == null || !canActOnField || isActing.value) return;
    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmShopClosedTitle,
      message: AppTexts.dmShopClosedConfirmMessage,
      confirmLabel: AppTexts.dmShopClosedTitle,
    );
    if (confirmed != true) return;

    isActing.value = true;
    try {
      job.value = await _planService.markShopClosed(
        jobId: current.jobId,
        notes: notesController.text,
      );
      AppToast.showSuccess(AppTexts.dmShopClosedSuccess);
      Get.back();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> submitFailed() async {
    final current = job.value;
    if (current == null || !canActOnField || isActing.value) return;
    final notes = notesController.text.trim();
    if (notes.isEmpty) {
      AppToast.showError(AppTexts.dmFailedNotesRequired);
      return;
    }
    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmFailedTitle,
      message: AppTexts.dmFailedConfirmMessage,
      confirmLabel: AppTexts.dmFailedTitle,
    );
    if (confirmed != true) return;

    isActing.value = true;
    try {
      job.value = await _planService.markFailed(
        jobId: current.jobId,
        notes: notes,
      );
      AppToast.showSuccess(AppTexts.dmFailedSuccess);
      Get.back();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> saveNotes() async {
    final current = job.value;
    if (current == null || isActing.value) return;
    final notes = notesController.text.trim();
    if (notes.isEmpty) {
      AppToast.showError(AppTexts.dmFailedNotesRequired);
      return;
    }
    isActing.value = true;
    try {
      job.value = await _planService.saveNotes(
        jobId: current.jobId,
        notes: notes,
      );
      AppToast.showSuccess(AppTexts.dmNotesSaved);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> submitReturnUndelivered() async {
    final current = job.value;
    if (current == null || !canActOnField || isActing.value) return;
    final lines = _parsedLines(requirePositive: true);
    if (lines.isEmpty) {
      AppToast.showError(AppTexts.dmDeliverQtyRequired);
      return;
    }
    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmReturnUndeliveredTitle,
      message: AppTexts.dmReturnUndeliveredConfirmMessage,
      confirmLabel: AppTexts.dmReturnUndeliveredTitle,
    );
    if (confirmed != true) return;

    isActing.value = true;
    try {
      job.value = await _planService.returnUndelivered(
        jobId: current.jobId,
        lines: lines,
      );
      AppToast.showSuccess(AppTexts.dmReturnUndeliveredSuccess);
      Get.back();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isActing.value = false;
    }
  }
}
