import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_invoice_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_recovery_shop_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmShopInvoicesController extends GetxController {
  DmShopInvoicesController(this._recovery);

  final DmRecoveryService _recovery;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final Rxn<DmRecoveryShopModel> shop = Rxn<DmRecoveryShopModel>();
  final selectedInvoiceIds = <int>{}.obs;

  String get shopId {
    final fromParams = Get.parameters['id'];
    if (fromParams != null && fromParams.isNotEmpty) return fromParams;
    final args = Get.arguments;
    if (args is Map && args['shopId'] != null) {
      return args['shopId'].toString();
    }
    return '';
  }

  int get shopIdInt => int.tryParse(shopId) ?? 0;

  bool get hasCachedData => shop.value != null;

  List<DmRecoveryInvoiceModel> get invoices =>
      shop.value?.openInvoices ?? const [];

  List<DmRecoveryInvoiceModel> get paidInvoices =>
      shop.value?.paidInvoices ?? const [];

  int get paidInvoiceCount =>
      shop.value?.paidInvoiceCount ?? paidInvoices.length;

  double get totalOutstanding =>
      shop.value?.effectiveOutstanding ??
      shop.value?.outstanding ??
      invoices.fold<double>(0, (sum, invoice) => sum + invoice.amountResidual);

  List<DmRecoveryInvoiceModel> get selectedInvoices => invoices
      .where((invoice) => selectedInvoiceIds.contains(invoice.invoiceId))
      .toList(growable: false);

  double get selectedTotal => selectedInvoices.fold<double>(
    0,
    (sum, invoice) => sum + invoice.amountResidual,
  );

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    loadOutstanding();
  }

  Future<void> loadOutstanding({bool force = true}) async {
    if (shopIdInt <= 0) {
      isLoading.value = false;
      error.value = AppTexts.emptyLoadFailedSubtitle;
      return;
    }
    final showLoader = shop.value == null;
    if (showLoader) isLoading.value = true;
    try {
      shop.value = await _recovery.fetchShop(shopIdInt, forceNetwork: force);
      selectedInvoiceIds.retainWhere(
        (id) => invoices.any((row) => row.invoiceId == id),
      );
      error.value = null;
    } on ApiException catch (e) {
      error.value = e.message;
      if (shop.value == null) AppToast.showError(e.message);
    } catch (_) {
      error.value = AppTexts.emptyLoadFailedSubtitle;
      if (shop.value == null) AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleInvoice(int invoiceId) {
    if (selectedInvoiceIds.contains(invoiceId)) {
      selectedInvoiceIds.remove(invoiceId);
    } else {
      selectedInvoiceIds.add(invoiceId);
    }
  }

  bool isSelected(int invoiceId) => selectedInvoiceIds.contains(invoiceId);

  void selectAll() {
    selectedInvoiceIds
      ..clear()
      ..addAll(invoices.map((invoice) => invoice.invoiceId));
  }

  void clearSelection() => selectedInvoiceIds.clear();

  Future<void> collectSelected() async {
    if (selectedInvoiceIds.isEmpty) {
      AppToast.showInformation(AppTexts.dmSelectInvoicesHint);
      return;
    }
    final recorded = await Get.toNamed(
      AppRoutes.dmRecordCollection,
      arguments: {
        'shopId': shopId,
        'invoiceIds': selectedInvoiceIds.toList(growable: false),
      },
    );
    if (recorded == true) await loadOutstanding(force: true);
  }

  Future<void> collectAllOpen() async {
    final recorded = await Get.toNamed(
      AppRoutes.dmRecordCollection,
      arguments: {
        'shopId': shopId,
        'invoiceIds': invoices.map((i) => i.invoiceId).toList(growable: false),
      },
    );
    if (recorded == true) await loadOutstanding(force: true);
  }
}
