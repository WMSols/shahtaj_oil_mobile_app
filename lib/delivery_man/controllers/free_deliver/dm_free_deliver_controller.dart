import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/media/app_image_compress.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/shops/dm_free_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/van/dm_van_item_view.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/free_deliver/dm_free_deliver_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/van/dm_van_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmFreeDeliverController extends GetxController {
  DmFreeDeliverController(this._freeService, this._vanService);

  final DmFreeDeliverService _freeService;
  final DmVanService _vanService;
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = true.obs;
  final RxBool isActing = false.obs;
  final Rxn<DmFreeShopModel> shop = Rxn<DmFreeShopModel>();
  final RxList<DmVanItemView> vanItems = <DmVanItemView>[].obs;
  final RxMap<int, String> qtyDrafts = <int, String>{}.obs;
  final Rxn<Uint8List> proofPhotoBytes = Rxn<Uint8List>();
  final notesController = TextEditingController();
  final receiverController = TextEditingController();

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    _resolveShop();
    load();
  }

  @override
  void onClose() {
    notesController.dispose();
    receiverController.dispose();
    super.onClose();
  }

  void _resolveShop() {
    final args = Get.arguments;
    if (args is DmFreeShopModel) {
      shop.value = args;
      return;
    }
    if (args is Map) {
      shop.value = DmFreeShopModel.fromJson(Map<String, dynamic>.from(args));
      return;
    }
    final id = Get.parameters['shopId'];
    if (id != null && id.isNotEmpty) {
      shop.value = DmFreeShopModel(shopId: id, name: '');
    }
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final snap = await _vanService.fetchSnapshot(forceNetwork: true);
      vanItems.assignAll([
        for (final item in snap.items)
          if (item.qty > 0)
            DmVanItemView(
              id: '${item.productId}',
              productId: item.productId,
              name: item.name,
              uom: item.uom,
              qtyOnVan: item.qty,
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

  List<({int productId, double qty})> _parsedLines() {
    final out = <({int productId, double qty})>[];
    for (final item in vanItems) {
      final raw = qtyDrafts[item.productId]?.trim() ?? '';
      final qty = double.tryParse(raw) ?? 0;
      if (qty <= 0) continue;
      if (qty > item.qtyOnVan) continue;
      out.add((productId: item.productId, qty: qty));
    }
    return out;
  }

  Future<void> submit() async {
    final current = shop.value;
    if (current == null || isActing.value) return;

    final shopId = int.tryParse(current.shopId) ?? 0;
    if (shopId <= 0) {
      AppToast.showError(AppTexts.error);
      return;
    }

    final lines = _parsedLines();
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
      title: AppTexts.dmFreeDeliverTitle,
      message: AppTexts.dmFreeDeliverConfirmMessage,
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
      await _freeService.deliverFree(
        shopId: shopId,
        latitude: position.latitude,
        longitude: position.longitude,
        lines: lines,
        receiverName: receiver,
        deliveryProofImageBase64: base64Encode(photo),
        notes: notesController.text,
      );
      AppToast.showSuccess(AppTexts.dmFreeDeliverSuccess);
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
