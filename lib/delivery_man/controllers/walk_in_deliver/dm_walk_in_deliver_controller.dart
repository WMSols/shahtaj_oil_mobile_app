import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/media/app_image_compress.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_item_view.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/walk_in_deliver/dm_walk_in_deliver_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmWalkInDeliverController extends GetxController {
  DmWalkInDeliverController(this._walkInService, this._vanService);

  final DmWalkInDeliverService _walkInService;
  final DmVanService _vanService;
  final ImagePicker _picker = ImagePicker();

  static const paymentMethods = [PaymentMethod.cash, PaymentMethod.cheque];

  final RxBool isLoading = true.obs;
  final RxBool isActing = false.obs;
  final RxBool isPickingPhoto = false.obs;
  final RxBool isPickingCheque = false.obs;
  final RxList<DmVanItemView> vanItems = <DmVanItemView>[].obs;
  final RxMap<int, String> qtyDrafts = <int, String>{}.obs;
  final Rxn<Uint8List> proofPhotoBytes = Rxn<Uint8List>();
  final Rxn<Uint8List> chequeImageBytes = Rxn<Uint8List>();
  final Rx<PaymentMethod> method = PaymentMethod.cash.obs;

  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final receiverController = TextEditingController();
  final notesController = TextEditingController();
  final chequeNumberController = TextEditingController();

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    load();
  }

  @override
  void onClose() {
    customerNameController.dispose();
    phoneController.dispose();
    receiverController.dispose();
    notesController.dispose();
    chequeNumberController.dispose();
    super.onClose();
  }

  Future<void> load({bool force = true}) async {
    isLoading.value = true;
    try {
      final snap = await _vanService.fetchSnapshot(forceNetwork: force);
      vanItems.assignAll([
        for (final item in snap.items)
          if (item.qtyAvailable > 0)
            DmVanItemView(
              id: '${item.productId}',
              productId: item.productId,
              name: item.name,
              uom: item.uom,
              qtyOnVan: item.qty,
              qtyAvailable: item.qtyAvailable,
              maxEditable: item.qtyAvailable,
            ),
      ]);
      qtyDrafts
        ..clear()
        ..addEntries(vanItems.map((item) => MapEntry(item.productId, '')));
      qtyDrafts.refresh();
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  void onQtyChanged(int productId, String raw) {
    qtyDrafts[productId] = raw;
    qtyDrafts.refresh();
  }

  void setMethod(PaymentMethod next) {
    method.value = next;
    if (next != PaymentMethod.cheque) {
      chequeImageBytes.value = null;
    }
  }

  Future<void> pickProofPhoto() async {
    final source = await _pickImageSource();
    if (source == null) return;
    isPickingPhoto.value = true;
    try {
      final bytes = await _pickCompressed(source);
      if (bytes != null) proofPhotoBytes.value = bytes;
    } finally {
      isPickingPhoto.value = false;
    }
  }

  Future<void> pickChequeImage() async {
    final source = await _pickImageSource();
    if (source == null) return;
    isPickingCheque.value = true;
    try {
      final bytes = await _pickCompressed(source);
      if (bytes != null) chequeImageBytes.value = bytes;
    } finally {
      isPickingCheque.value = false;
    }
  }

  Future<ImageSource?> _pickImageSource() {
    return Get.bottomSheet<ImageSource>(
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
  }

  Future<Uint8List?> _pickCompressed(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: AppImageCompress.pickerQuality,
    );
    if (file == null) return null;
    final raw = await file.readAsBytes();
    return AppImageCompress.compress(raw);
  }

  List<({int productId, double qty})> _parsedLines() {
    final out = <({int productId, double qty})>[];
    for (final item in vanItems) {
      final raw = qtyDrafts[item.productId]?.trim() ?? '';
      final qty = double.tryParse(raw) ?? 0;
      if (qty <= 0) continue;
      if (qty > item.qtyAvailable) continue;
      out.add((productId: item.productId, qty: qty));
    }
    return out;
  }

  String? _validate() {
    if (customerNameController.text.trim().isEmpty) {
      return AppTexts.dmCustomerNameRequired;
    }
    if (_parsedLines().isEmpty) return AppTexts.dmDeliverQtyRequired;
    if (receiverController.text.trim().isEmpty) {
      return AppTexts.dmReceiverRequired;
    }
    final photo = proofPhotoBytes.value;
    if (photo == null || photo.isEmpty) return AppTexts.dmProofPhotoRequired;
    if (method.value == PaymentMethod.cheque) {
      if (chequeNumberController.text.trim().isEmpty) {
        return AppTexts.dmChequeNumberRequired;
      }
      final cheque = chequeImageBytes.value;
      if (cheque == null || cheque.isEmpty) {
        return AppTexts.dmChequeImageRequired;
      }
    }
    return null;
  }

  Future<void> submit() async {
    if (isActing.value) return;
    final error = _validate();
    if (error != null) {
      AppToast.showError(error);
      return;
    }

    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmWalkInTitle,
      message: AppTexts.dmWalkInConfirmMessage,
      confirmLabel: AppTexts.dmConfirmDelivery,
    );
    if (confirmed != true) return;

    isActing.value = true;
    try {
      final position = await AppHelper.requireCurrentPosition(showGuide: true);
      final photo = proofPhotoBytes.value!;
      final cheque = chequeImageBytes.value;
      final result = await _walkInService.deliverWalkIn(
        customerName: customerNameController.text,
        phone: phoneController.text,
        latitude: position.latitude,
        longitude: position.longitude,
        receiverName: receiverController.text,
        deliveryProofImageBase64: base64Encode(photo),
        lines: _parsedLines(),
        paymentMethod: method.value,
        chequeNumber: method.value == PaymentMethod.cheque
            ? chequeNumberController.text
            : null,
        chequeImageBase64:
            method.value == PaymentMethod.cheque && cheque != null
            ? base64Encode(cheque)
            : null,
        notes: notesController.text,
      );

      final amount = AppFormatter.currency(result.amountTotal, symbol: 'Rs. ');
      final invoice = (result.invoiceName ?? '').trim();
      final message = invoice.isNotEmpty
          ? AppTexts.dmWalkInSuccessAmount('$invoice · $amount')
          : AppTexts.dmWalkInSuccessAmount(amount);
      AppToast.showSuccess(message);

      customerNameController.clear();
      phoneController.clear();
      receiverController.clear();
      notesController.clear();
      chequeNumberController.clear();
      proofPhotoBytes.value = null;
      chequeImageBytes.value = null;
      method.value = PaymentMethod.cash;
      await load(force: true);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.error);
    } finally {
      isActing.value = false;
    }
  }
}
