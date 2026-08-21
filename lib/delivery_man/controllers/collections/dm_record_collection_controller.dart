import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/media/app_image_compress.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_confirm_dialog.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_today_shops_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/dashboard/dm_dashboard_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/handover/dm_handover_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/controllers/collections/dm_collection_history_controller.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_invoice_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_shop_due_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmRecordCollectionController extends GetxController with CachedLoadMixin {
  DmRecordCollectionController(this._store);

  final DmCollectionStore _store;
  final ImagePicker _picker = ImagePicker();

  final Rxn<DmShopDueModel> shop = Rxn<DmShopDueModel>();
  final RxList<DmInvoiceModel> invoices = <DmInvoiceModel>[].obs;
  final Rx<PaymentMethod> method = PaymentMethod.cash.obs;
  final RxBool isSaving = false.obs;
  final amountEpoch = 0.obs;
  final Rxn<Uint8List> bankScreenshotBytes = Rxn<Uint8List>();

  final batchAmountController = TextEditingController();
  final referenceController = TextEditingController();
  final notesController = TextEditingController();
  final invoiceAmountControllers = <String, TextEditingController>{};

  late final CollectionMode mode;
  late final List<String> invoiceIds;

  String get shopId {
    final args = Get.arguments;
    if (args is Map && args['shopId'] != null) {
      return args['shopId'].toString();
    }
    return '';
  }

  bool get isBatch => mode == CollectionMode.batch;

  @override
  bool get hasCachedData => shop.value != null;

  @override
  String get loadFailedMessage => AppTexts.emptyLoadFailedSubtitle;

  double get remainingTotal =>
      invoices.fold<double>(0, (sum, invoice) => sum + invoice.remainingAmount);

  double get collectingTotal {
    amountEpoch.value;
    if (isBatch) return _parseAmount(batchAmountController.text);
    return invoices.fold<double>(0, (sum, invoice) {
      return sum + _parseAmount(invoiceAmountControllers[invoice.id]?.text);
    });
  }

  @override
  void onInit() {
    super.onInit();
    DmServicesBinding.ensureRegistered();
    final args = Get.arguments;
    mode = CollectionModeX.fromApi(
      args is Map ? args['mode'] : CollectionMode.invoiceWise.name,
    );
    invoiceIds = args is Map && args['invoiceIds'] is List
        ? (args['invoiceIds'] as List).map((id) => id.toString()).toList()
        : const <String>[];
    loadForm();
  }

  @override
  void onClose() {
    batchAmountController.dispose();
    referenceController.dispose();
    notesController.dispose();
    for (final controller in invoiceAmountControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> loadForm({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _store.hydrate();
    shop.value = _store.shopById(shopId);
    final open = _store.openInvoicesForShop(shopId);
    final selected = invoiceIds.isEmpty
        ? open
        : open.where((invoice) => invoiceIds.contains(invoice.id)).toList();
    invoices.assignAll(selected);
    _seedAmountControllers(selected);
  }

  void _seedAmountControllers(List<DmInvoiceModel> rows) {
    for (final controller in invoiceAmountControllers.values) {
      controller.dispose();
    }
    invoiceAmountControllers
      ..clear()
      ..addEntries(
        rows.map(
          (invoice) => MapEntry(
            invoice.id,
            TextEditingController(text: _formatAmount(invoice.remainingAmount)),
          ),
        ),
      );
    batchAmountController.text = _formatAmount(
      rows.fold<double>(0, (sum, invoice) => sum + invoice.remainingAmount),
    );
    amountEpoch.value++;
  }

  void selectMethod(PaymentMethod value) {
    method.value = value;
    if (value != PaymentMethod.bank) {
      bankScreenshotBytes.value = null;
    }
  }

  void onAmountChanged() => amountEpoch.value++;

  void fillInvoiceRemaining(DmInvoiceModel invoice) {
    final controller = invoiceAmountControllers[invoice.id];
    if (controller == null) return;
    controller.text = _formatAmount(invoice.remainingAmount);
    onAmountChanged();
  }

  void fillBatchRemaining() {
    batchAmountController.text = _formatAmount(remainingTotal);
    onAmountChanged();
  }

  Future<void> pickBankScreenshot() async {
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
    bankScreenshotBytes.value = await AppImageCompress.compress(raw);
  }

  Future<void> submit() async {
    if (isSaving.value) return;
    final error = _validate();
    if (error != null) {
      AppToast.showError(error);
      return;
    }

    final confirmed = await AppConfirmSheet.show(
      title: AppTexts.dmConfirmCollection,
      message: AppTexts.dmConfirmCollectionMessage(
        shop.value?.name ?? '',
        _formatAmount(collectingTotal),
        method.value.label,
      ),
      confirmLabel: AppTexts.dmConfirmCollection,
    );
    if (confirmed != true) return;

    isSaving.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 280));
      final screenshot = bankScreenshotBytes.value;
      final recorded = await _store.recordCollection(
        shopId: shopId,
        allocations: _allocations(),
        method: method.value,
        mode: mode,
        notes: notesController.text,
        reference: referenceController.text,
        proofPhotoBase64: screenshot == null || screenshot.isEmpty
            ? null
            : base64Encode(screenshot),
      );
      _refreshRelatedLists();
      AppToast.showSuccess(
        AppTexts.dmCollectionRecorded(recorded.receiptNumber),
      );
      Get.back(result: true);
    } catch (_) {
      AppToast.showError(AppTexts.dmCollectionFailed);
    } finally {
      if (!isClosed) isSaving.value = false;
    }
  }

  Map<String, double> _allocations() {
    if (!isBatch) {
      return {
        for (final invoice in invoices)
          invoice.id: _parseAmount(invoiceAmountControllers[invoice.id]?.text),
      };
    }

    var remaining = _parseAmount(batchAmountController.text);
    final allocations = <String, double>{};
    for (final invoice in invoices) {
      if (remaining <= 0) {
        allocations[invoice.id] = 0;
        continue;
      }
      final take = remaining > invoice.remainingAmount
          ? invoice.remainingAmount
          : remaining;
      allocations[invoice.id] = take;
      remaining = ((remaining - take) * 100).round() / 100;
    }
    return allocations;
  }

  String? _validate() {
    if (invoices.isEmpty) return AppTexts.dmSelectInvoicesHint;
    if (isBatch) {
      final amount = _parseAmount(batchAmountController.text);
      if (amount <= 0) return AppTexts.dmAmountRequired;
      if (amount > remainingTotal) return AppTexts.dmAmountExceedsRemaining;
    } else {
      var total = 0.0;
      for (final invoice in invoices) {
        final amount = _parseAmount(invoiceAmountControllers[invoice.id]?.text);
        if (amount < 0) return AppTexts.dmAmountRequired;
        if (amount > invoice.remainingAmount) {
          return AppTexts.dmAmountExceedsRemaining;
        }
        total += amount;
      }
      if (total <= 0) return AppTexts.dmAmountRequired;
    }

    final reference = referenceController.text.trim();
    if (method.value == PaymentMethod.cheque && reference.isEmpty) {
      return AppTexts.dmChequeNumberRequired;
    }
    if (method.value == PaymentMethod.bank && reference.isEmpty) {
      return AppTexts.dmBankReferenceRequired;
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
    if (Get.isRegistered<DmHandoverController>()) {
      Get.find<DmHandoverController>().loadHandover(force: true);
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
