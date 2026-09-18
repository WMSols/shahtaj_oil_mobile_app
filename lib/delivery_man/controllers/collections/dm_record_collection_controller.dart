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
import 'package:shahtaj_oil_mobile_app/core/utils/media/app_image_compress.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_collection_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/wallet/dm_wallet_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_invoice_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmRecordCollectionController extends GetxController {
  DmRecordCollectionController(this._recovery);

  final DmRecoveryService _recovery;
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  final RxnString error = RxnString();
  final Rxn<DmRecoveryShopModel> shop = Rxn<DmRecoveryShopModel>();
  final RxList<DmRecoveryInvoiceModel> invoices =
      <DmRecoveryInvoiceModel>[].obs;
  final Rx<PaymentMethod> method = PaymentMethod.cash.obs;
  final Rxn<Uint8List> chequeImageBytes = Rxn<Uint8List>();
  final amountEpoch = 0.obs;
  final notesController = TextEditingController();
  final chequeNumberController = TextEditingController();
  final invoiceAmountControllers = <int, TextEditingController>{};

  late final List<int> invoiceIds;

  static const collectMethods = [PaymentMethod.cash, PaymentMethod.cheque];

  String get shopId {
    final args = Get.arguments;
    if (args is Map && args['shopId'] != null) {
      return args['shopId'].toString();
    }
    return '';
  }

  int get shopIdInt => int.tryParse(shopId) ?? 0;

  bool get hasCachedData => shop.value != null;

  double get remainingTotal =>
      invoices.fold<double>(0, (sum, invoice) => sum + invoice.amountResidual);

  double get collectingTotal {
    amountEpoch.value;
    return invoices.fold<double>(0, (sum, invoice) {
      return sum +
          _parseAmount(invoiceAmountControllers[invoice.invoiceId]?.text);
    });
  }

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    final args = Get.arguments;
    invoiceIds = args is Map && args['invoiceIds'] is List
        ? (args['invoiceIds'] as List)
              .map((id) => int.tryParse(id.toString()) ?? 0)
              .where((id) => id > 0)
              .toList(growable: false)
        : const <int>[];
    loadForm();
  }

  @override
  void onClose() {
    notesController.dispose();
    chequeNumberController.dispose();
    for (final controller in invoiceAmountControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> loadForm({bool force = true}) async {
    if (shopIdInt <= 0) {
      isLoading.value = false;
      error.value = AppTexts.emptyLoadFailedSubtitle;
      return;
    }
    isLoading.value = true;
    try {
      final data = await _recovery.fetchShop(shopIdInt, forceNetwork: force);
      shop.value = data;
      final open = data.openInvoices;
      final selected = invoiceIds.isEmpty
          ? open
          : open
                .where((invoice) => invoiceIds.contains(invoice.invoiceId))
                .toList(growable: false);
      invoices.assignAll(selected);
      _seedAmountControllers(selected);
      error.value = null;
    } on ApiException catch (e) {
      error.value = e.message;
      AppToast.showError(e.message);
    } catch (_) {
      error.value = AppTexts.emptyLoadFailedSubtitle;
      AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  void _seedAmountControllers(List<DmRecoveryInvoiceModel> rows) {
    for (final controller in invoiceAmountControllers.values) {
      controller.dispose();
    }
    invoiceAmountControllers
      ..clear()
      ..addEntries(
        rows.map(
          (invoice) => MapEntry(
            invoice.invoiceId,
            TextEditingController(text: _formatAmount(invoice.amountResidual)),
          ),
        ),
      );
    amountEpoch.value++;
  }

  void onAmountChanged() => amountEpoch.value++;

  void setMethod(PaymentMethod next) {
    method.value = next;
    if (next != PaymentMethod.cheque) {
      chequeImageBytes.value = null;
    }
  }

  void fillInvoiceRemaining(DmRecoveryInvoiceModel invoice) {
    final controller = invoiceAmountControllers[invoice.invoiceId];
    if (controller == null) return;
    controller.text = _formatAmount(invoice.amountResidual);
    onAmountChanged();
  }

  Future<void> pickChequeImage() async {
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
    chequeImageBytes.value = await AppImageCompress.compress(raw);
  }

  Future<void> submit() async {
    if (isSaving.value) return;
    final validationError = _validate();
    if (validationError != null) {
      AppToast.showError(validationError);
      return;
    }

    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmConfirmCollection,
      message: AppTexts.dmConfirmCashCollectionMessage(
        shop.value?.shopName ?? '',
        AppFormatter.currency(collectingTotal, symbol: 'Rs. '),
      ),
      confirmLabel: AppTexts.dmConfirmCollection,
    );
    if (confirmed != true) return;

    isSaving.value = true;
    try {
      final photo = chequeImageBytes.value;
      final result = await _recovery.collect(
        shopId: shopIdInt,
        paymentMethod: method.value,
        chequeNumber: method.value == PaymentMethod.cheque
            ? chequeNumberController.text
            : null,
        chequeImageBase64: method.value == PaymentMethod.cheque && photo != null
            ? base64Encode(photo)
            : null,
        allocations: [
          for (final invoice in invoices)
            (
              invoiceId: invoice.invoiceId,
              amount: _parseAmount(
                invoiceAmountControllers[invoice.invoiceId]?.text,
              ),
            ),
        ],
        notes: notesController.text,
      );
      _refreshRelatedLists();
      final receipt = result.payments.isNotEmpty
          ? result.payments.first.name
          : result.paymentIds.isNotEmpty
          ? '${result.paymentIds.first}'
          : AppFormatter.currency(result.collectedAmount, symbol: 'Rs. ');
      AppToast.showSuccess(AppTexts.dmCollectionRecorded(receipt));
      Get.back(result: true);
    } on ApiException catch (e) {
      AppToast.showError(e.message);
    } catch (_) {
      AppToast.showError(AppTexts.dmCollectionFailed);
    } finally {
      if (!isClosed) isSaving.value = false;
    }
  }

  String? _validate() {
    if (invoices.isEmpty) return AppTexts.dmSelectInvoicesHint;
    var total = 0.0;
    for (final invoice in invoices) {
      final amount = _parseAmount(
        invoiceAmountControllers[invoice.invoiceId]?.text,
      );
      if (amount < 0) return AppTexts.dmAmountRequired;
      if (amount > invoice.amountResidual) {
        return AppTexts.dmAmountExceedsRemaining;
      }
      total += amount;
    }
    if (total <= 0) return AppTexts.dmAmountRequired;

    if (method.value == PaymentMethod.cheque) {
      if (chequeNumberController.text.trim().isEmpty) {
        return AppTexts.dmChequeNumberRequired;
      }
      final photo = chequeImageBytes.value;
      if (photo == null || photo.isEmpty) {
        return AppTexts.dmChequeImageRequired;
      }
    }
    return null;
  }

  void _refreshRelatedLists() {
    if (Get.isRegistered<DmTodayShopsController>()) {
      Get.find<DmTodayShopsController>().loadShops(force: true);
    }
    if (Get.isRegistered<DmDashboardController>()) {
      Get.find<DmDashboardController>().refreshCollections();
    }
    if (Get.isRegistered<DmCollectionHistoryController>()) {
      Get.find<DmCollectionHistoryController>().loadHistory(force: true);
    }
    if (Get.isRegistered<DmWalletController>()) {
      Get.find<DmWalletController>().load(force: true);
    }
  }

  double _parseAmount(String? raw) {
    final cleaned = (raw ?? '').trim().replaceAll(',', '');
    if (cleaned.isEmpty) return 0;
    return double.tryParse(cleaned) ?? 0;
  }

  String _formatAmount(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }
}
