import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_map_tiles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_invoice_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_shop_due_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/collections/dm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmShopInvoicesController extends GetxController with CachedLoadMixin {
  DmShopInvoicesController(this._store);

  final DmCollectionStore _store;

  final Rxn<DmShopDueModel> shop = Rxn<DmShopDueModel>();
  final RxList<DmInvoiceModel> invoices = <DmInvoiceModel>[].obs;
  final selectedInvoiceIds = <String>{}.obs;

  String get shopId {
    final fromParams = Get.parameters['id'];
    if (fromParams != null && fromParams.isNotEmpty) return fromParams;
    final args = Get.arguments;
    if (args is Map && args['shopId'] != null) {
      return args['shopId'].toString();
    }
    return '';
  }

  @override
  bool get hasCachedData => shop.value != null;

  @override
  String get loadFailedMessage => AppTexts.emptyLoadFailedSubtitle;

  double get totalOutstanding =>
      shop.value?.outstanding ??
      invoices.fold<double>(0, (sum, invoice) => sum + invoice.remainingAmount);

  List<DmInvoiceModel> get selectedInvoices => invoices
      .where((invoice) => selectedInvoiceIds.contains(invoice.id))
      .toList(growable: false);

  double get selectedTotal => selectedInvoices.fold<double>(
    0,
    (sum, invoice) => sum + invoice.remainingAmount,
  );

  bool get hasCoordinates {
    final current = shop.value;
    return current != null &&
        current.latitude != null &&
        current.longitude != null;
  }

  bool get isPartial => _store.shopHasPartialPayment(shopId);

  @override
  void onInit() {
    super.onInit();
    DmServicesBinding.ensureRegistered();
    loadOutstanding();
  }

  Future<void> loadOutstanding({bool force = false}) =>
      loadCached(force: force);

  @override
  Future<void> fetchData() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _store.hydrate();
    final id = shopId;
    shop.value = _store.shopById(id);
    invoices.assignAll(_store.openInvoicesForShop(id));
    selectedInvoiceIds.retainWhere(
      (invoiceId) => invoices.any((row) => row.id == invoiceId),
    );
  }

  void toggleInvoice(String invoiceId) {
    if (selectedInvoiceIds.contains(invoiceId)) {
      selectedInvoiceIds.remove(invoiceId);
    } else {
      selectedInvoiceIds.add(invoiceId);
    }
  }

  bool isSelected(String invoiceId) => selectedInvoiceIds.contains(invoiceId);

  void selectAll() {
    selectedInvoiceIds
      ..clear()
      ..addAll(invoices.map((invoice) => invoice.id));
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
        'mode': 'invoiceWise',
      },
    );
    if (recorded == true) await loadOutstanding(force: true);
  }

  Future<void> collectBatch() async {
    final recorded = await Get.toNamed(
      AppRoutes.dmRecordCollection,
      arguments: {
        'shopId': shopId,
        'invoiceIds': selectedInvoiceIds.isEmpty
            ? invoices.map((invoice) => invoice.id).toList(growable: false)
            : selectedInvoiceIds.toList(growable: false),
        'mode': 'batch',
      },
    );
    if (recorded == true) await loadOutstanding(force: true);
  }

  Future<void> callShop() async {
    final phone = shop.value?.phone.trim() ?? '';
    if (phone.isEmpty) {
      AppToast.showInformation(AppTexts.dmNoPhoneToCall);
      return;
    }
    final normalized = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri(scheme: 'tel', path: normalized);
    try {
      await launchUrl(uri);
    } catch (e, stackTrace) {
      debugPrint('DmShopInvoicesController: call failed — $e');
      debugPrint('$stackTrace');
    }
  }

  Future<void> openDirections() async {
    final current = shop.value;
    if (current == null || !hasCoordinates) {
      AppToast.showInformation(AppTexts.dmNoLocationForDirections);
      return;
    }
    final latitude = current.latitude!;
    final longitude = current.longitude!;
    final uris = [
      AppMapTiles.googleMapsNavigationUri(latitude, longitude),
      AppMapTiles.googleMapsGeoUri(latitude, longitude),
    ];
    for (final uri in uris) {
      try {
        final opened = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (opened) return;
      } catch (e, stackTrace) {
        debugPrint('DmShopInvoicesController: failed to open $uri — $e');
        debugPrint('$stackTrace');
      }
    }
  }
}
