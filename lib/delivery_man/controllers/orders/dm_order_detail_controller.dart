import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_shell_controller.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/media/app_image_compress.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_delivery_order_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/orders/dm_order_line_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/orders/dm_delivery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/pickup/dm_pickup_service.dart';

class DmOrderDetailController extends GetxController {
  DmOrderDetailController(this._deliveryService, this._pickupService);

  final DmDeliveryService _deliveryService;
  final DmPickupService _pickupService;
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = true.obs;
  final RxBool isActing = false.obs;
  final Rxn<DmDeliveryOrderModel> order = Rxn<DmDeliveryOrderModel>();
  final RxMap<String, String> deliveredDrafts = <String, String>{}.obs;
  final RxMap<String, String> rejectedDrafts = <String, String>{}.obs;
  final Rxn<Uint8List> proofPhotoBytes = Rxn<Uint8List>();
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String get orderId => Get.parameters['id'] ?? '';

  bool get canEditDelivery => order.value?.status == DeliveryStatus.inTransit;

  bool get isDone {
    final status = order.value?.status;
    return status == DeliveryStatus.delivered ||
        status == DeliveryStatus.returned;
  }

  bool get canStartDelivery {
    final status = order.value?.status;
    return status == DeliveryStatus.pending ||
        status == DeliveryStatus.pickedUp;
  }

  @override
  void onInit() {
    super.onInit();
    loadOrder();
  }

  @override
  void onClose() {
    receiverController.dispose();
    notesController.dispose();
    super.onClose();
  }

  Future<void> loadOrder() async {
    isLoading.value = true;
    try {
      final data = await _deliveryService.fetchOrderById(orderId);
      order.value = data;
      if (data != null) {
        _seedDrafts(data.lines);
        receiverController.text = data.receiverName ?? '';
        notesController.text = data.deliveryNotes ?? '';
        proofPhotoBytes.value = _decodeProof(data.proofPhotoBase64);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Uint8List? _decodeProof(String? base64) {
    if (base64 == null || base64.isEmpty) return null;
    try {
      return base64Decode(base64);
    } catch (_) {
      return null;
    }
  }

  void _seedDrafts(List<DmOrderLineModel> lines) {
    deliveredDrafts
      ..clear()
      ..addEntries(lines.map((line) => MapEntry(line.id, '')));
    rejectedDrafts
      ..clear()
      ..addEntries(lines.map((line) => MapEntry(line.id, '')));
  }

  void onDeliveredChanged(String lineId, String raw) {
    deliveredDrafts[lineId] = raw;
    deliveredDrafts.refresh();
  }

  void onRejectedChanged(String lineId, String raw) {
    rejectedDrafts[lineId] = raw;
    rejectedDrafts.refresh();
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

  void _goToHistory() {
    if (!Get.isRegistered<DeliveryManShellController>()) return;
    Get.find<DeliveryManShellController>().selectLeaf('dm_deliveries_list');
  }

  Future<void> startDelivery() async {
    final current = order.value;
    if (current == null) return;

    final pickup = await _pickupService.fetchTodayPickup();
    if (!pickup.isAcknowledged) {
      AppToast.showWarning(AppTexts.dmPickupBeforeDelivery);
      return;
    }

    if (!canStartDelivery) return;

    isActing.value = true;
    try {
      if (current.status == DeliveryStatus.pending) {
        final loaded = current.lines
            .map(
              (line) => line.copyWith(
                loadedQty: line.loadedQty > 0
                    ? line.loadedQty
                    : line.orderedQty,
              ),
            )
            .toList(growable: false);
        await _deliveryService.markPickedUp(current.id, loadedLines: loaded);
      }
      order.value = await _deliveryService.startDelivery(current.id);
      AppToast.showSuccess(AppTexts.dmDeliveryStarted);
    } finally {
      isActing.value = false;
    }
  }

  Future<void> submitDelivery() async {
    final current = order.value;
    if (current == null || current.status != DeliveryStatus.inTransit) return;

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

    final lines = <DmOrderLineModel>[];
    for (final line in current.lines) {
      final maxQty = line.loadedQty > 0 ? line.loadedQty : line.orderedQty;
      final deliveredRaw = (deliveredDrafts[line.id] ?? '').trim();
      final rejectedRaw = (rejectedDrafts[line.id] ?? '').trim();

      final delivered = double.tryParse(deliveredRaw);
      final rejected = rejectedRaw.isEmpty ? 0.0 : double.tryParse(rejectedRaw);

      if (delivered == null ||
          delivered < 0 ||
          rejected == null ||
          rejected < 0 ||
          delivered + rejected > maxQty) {
        AppToast.showError(AppTexts.dmInvalidQuantity);
        return;
      }
      lines.add(line.copyWith(deliveredQty: delivered, rejectedQty: rejected));
    }

    isActing.value = true;
    try {
      order.value = await _deliveryService.submitDelivery(
        id: current.id,
        deliveredLines: lines,
        receiverName: receiver,
        proofPhotoBase64: base64Encode(photo),
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      );
      AppToast.showSuccess(AppTexts.dmDeliverySubmitted);
      if (Get.key.currentState?.canPop() ?? false) {
        Get.back();
      }
      _goToHistory();
    } finally {
      isActing.value = false;
    }
  }
}
