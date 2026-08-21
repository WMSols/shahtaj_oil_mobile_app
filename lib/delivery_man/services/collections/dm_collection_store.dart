import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_collection_line_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_invoice_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/collections/dm_shop_due_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/handover/dm_handover_summary_model.dart';

/// In-memory DM collection store backed by [OfflineCacheService] for persistence across
/// hot restarts. API integration will replace the mock-seed path.
class DmCollectionStore extends GetxService {
  DmCollectionStore({
    OfflineCacheService? cache,
    ConnectivityService? connectivity,
  }) : _cache = cache ?? Get.find<OfflineCacheService>(),
       _connectivity = connectivity ?? Get.find<ConnectivityService>();

  final OfflineCacheService _cache;
  final ConnectivityService _connectivity;

  final shops = <DmShopDueModel>[];
  final invoices = <DmInvoiceModel>[];
  final collections = <DmCollectionSummaryModel>[];
  final handovers = <DmHandoverSummaryModel>[];

  bool _hydrated = false;
  static const _role = 'deliveryMan';

  @override
  void onInit() {
    super.onInit();
    _cache.registerSyncHandler(_role, 'record_collection', (_) async {});
    _cache.registerSyncHandler(_role, 'submit_handover', (_) async {});
  }

  Future<void> hydrate() async {
    if (_hydrated) return;
    _hydrated = true;

    final cachedShops = await _cache.readList(OfflineCacheKeys.dmShops);
    final cachedInvoices = await _cache.readList(OfflineCacheKeys.dmInvoices);
    final cachedCollections = await _cache.readList(
      OfflineCacheKeys.dmCollections,
    );
    final cachedHandovers = await _cache.readList(OfflineCacheKeys.dmHandovers);

    if (cachedShops.isNotEmpty &&
        cachedInvoices.isNotEmpty &&
        cachedCollections.isNotEmpty) {
      shops.addAll(cachedShops.map(DmShopDueModel.fromJson));
      invoices.addAll(cachedInvoices.map(DmInvoiceModel.fromJson));
      collections.addAll(
        cachedCollections.map(DmCollectionSummaryModel.fromJson),
      );
      handovers.addAll(cachedHandovers.map(DmHandoverSummaryModel.fromJson));
    } else {
      shops.addAll(AppMockData.dmShops);
      invoices.addAll(AppMockData.dmInvoices);
      collections.addAll(AppMockData.dmCollections);
      handovers.addAll(AppMockData.dmHandovers);
      await _persistAll();
    }
  }

  /// Legacy synchronous seed used by services that do not await [hydrate].
  void seedIfEmpty() {
    if (_hydrated || shops.isNotEmpty) return;
    _hydrated = true;
    shops.addAll(AppMockData.dmShops);
    invoices.addAll(AppMockData.dmInvoices);
    collections.addAll(AppMockData.dmCollections);
    handovers.addAll(AppMockData.dmHandovers);
  }

  // ── Persistence helpers ───────────────────────────────────────────────────

  Future<void> _persistAll() async {
    await Future.wait([
      _persistShops(),
      _persistInvoices(),
      _persistCollections(),
      _persistHandovers(),
    ]);
  }

  Future<void> _persistShops() => _cache.saveList(
    OfflineCacheKeys.dmShops,
    shops.map((e) => e.toJson()).toList(growable: false),
  );

  Future<void> _persistInvoices() => _cache.saveList(
    OfflineCacheKeys.dmInvoices,
    invoices.map((e) => e.toJson()).toList(growable: false),
  );

  Future<void> _persistCollections() => _cache.saveList(
    OfflineCacheKeys.dmCollections,
    collections.map((e) => e.toJson()).toList(growable: false),
  );

  Future<void> _persistHandovers() => _cache.saveList(
    OfflineCacheKeys.dmHandovers,
    handovers.map((e) => e.toJson()).toList(growable: false),
  );

  Future<void> _enqueue(String action, Map<String, dynamic> payload) async {
    await _cache.enqueueSync(role: _role, action: action, payload: payload);
    if (_connectivity.isOnline.value) {
      await _cache.flushSyncQueue();
    }
  }

  // ── Computed getters ─────────────────────────────────────────────────────

  bool _isToday(DateTime at) {
    final now = DateTime.now();
    return at.year == now.year && at.month == now.month && at.day == now.day;
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  double get collectedToday => collections
      .where((item) => _isToday(item.collectedAt))
      .fold<double>(0, (sum, item) => sum + item.amount);

  double get stillDue =>
      shops.fold<double>(0, (sum, shop) => sum + shop.outstanding);

  List<DmCollectionSummaryModel> get bagCollections =>
      collections.where((item) => item.isInBag).toList(growable: false);

  double get cashInBag => bagCollections
      .where((item) => item.method == PaymentMethod.cash)
      .fold<double>(0, (sum, item) => sum + item.amount);

  double get chequeInBag => bagCollections
      .where((item) => item.method == PaymentMethod.cheque)
      .fold<double>(0, (sum, item) => sum + item.amount);

  double get bagTotal => cashInBag + chequeInBag;

  int get shopsDueCount => shops.where((shop) => shop.outstanding > 0).length;

  List<DmCollectionSummaryModel> get recentCollections {
    final sorted = [...collections]
      ..sort((a, b) => b.collectedAt.compareTo(a.collectedAt));
    return sorted.take(3).toList(growable: false);
  }

  List<DmCollectionSummaryModel> collectionsForHistory({
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    final from = dateFrom == null ? null : _dateOnly(dateFrom);
    final to = dateTo == null ? null : _dateOnly(dateTo);
    final rows = collections.where((item) {
      final day = _dateOnly(item.collectedAt);
      if (from != null && day.isBefore(from)) return false;
      if (to != null && day.isAfter(to)) return false;
      return true;
    }).toList();
    rows.sort((a, b) => b.collectedAt.compareTo(a.collectedAt));
    return rows;
  }

  DmCollectionSummaryModel? collectionById(String id) {
    for (final item in collections) {
      if (item.id == id) return item;
    }
    return null;
  }

  List<DmHandoverSummaryModel> get recentHandovers {
    final sorted = [...handovers]
      ..sort((a, b) => b.handedAt.compareTo(a.handedAt));
    return sorted;
  }

  DmHandoverSummaryModel? handoverById(String id) {
    for (final item in handovers) {
      if (item.id == id) return item;
    }
    return null;
  }

  List<DmCollectionSummaryModel> collectionsForHandover(String handoverId) {
    return collections
        .where((item) => item.handoverId == handoverId)
        .toList(growable: false);
  }

  List<DmShopDueModel> get shopsWithDue =>
      shops.where((shop) => shop.outstanding > 0).toList(growable: false);

  DmShopDueModel? shopById(String shopId) {
    for (final shop in shops) {
      if (shop.id == shopId) return shop;
    }
    return null;
  }

  List<DmInvoiceModel> invoicesForShop(String shopId) {
    final rows = invoices.where((invoice) => invoice.shopId == shopId).toList();
    rows.sort((a, b) => a.issuedAt.compareTo(b.issuedAt));
    return rows;
  }

  List<DmInvoiceModel> openInvoicesForShop(String shopId) => invoicesForShop(
    shopId,
  ).where((invoice) => !invoice.isSettled).toList(growable: false);

  bool shopHasPartialPayment(String shopId) {
    return invoicesForShop(shopId).any(
      (invoice) =>
          invoice.remainingAmount > 0 &&
          invoice.remainingAmount < invoice.originalAmount,
    );
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  Future<DmCollectionSummaryModel> recordCollection({
    required String shopId,
    required Map<String, double> allocations,
    required PaymentMethod method,
    required CollectionMode mode,
    String notes = '',
    String reference = '',
    String? proofPhotoBase64,
  }) async {
    seedIfEmpty();
    final shopIndex = shops.indexWhere((shop) => shop.id == shopId);
    if (shopIndex < 0) throw StateError('Shop not found');

    var applied = 0.0;
    final lines = <DmCollectionLineModel>[];
    for (final entry in allocations.entries) {
      final take = _money(entry.value);
      if (take <= 0) continue;
      final invoiceIndex = invoices.indexWhere(
        (invoice) => invoice.id == entry.key && invoice.shopId == shopId,
      );
      if (invoiceIndex < 0) continue;
      final invoice = invoices[invoiceIndex];
      final capped = take > invoice.remainingAmount
          ? invoice.remainingAmount
          : take;
      invoices[invoiceIndex] = invoice.copyWith(
        remainingAmount: _money(invoice.remainingAmount - capped),
      );
      applied += capped;
      lines.add(
        DmCollectionLineModel(
          invoiceId: invoice.id,
          invoiceNumber: invoice.invoiceNumber,
          amount: _money(capped),
        ),
      );
    }

    if (applied <= 0) throw StateError('Nothing to collect');

    final shop = shops[shopIndex];
    final open = openInvoicesForShop(shopId);
    shops[shopIndex] = shop.copyWith(
      outstanding: _money(
        open.fold<double>(0, (sum, invoice) => sum + invoice.remainingAmount),
      ),
      invoiceCount: open.length,
    );

    final collection = DmCollectionSummaryModel(
      id: 'dm-col-${DateTime.now().millisecondsSinceEpoch}',
      receiptNumber: 'RC-${_nextReceiptNumber()}',
      shopId: shopId,
      shopName: shop.name,
      amount: _money(applied),
      collectedAt: DateTime.now(),
      method: method,
      mode: mode,
      status: CollectionStatus.collected,
      notes: notes.trim(),
      reference: reference.trim(),
      proofPhotoBase64: proofPhotoBase64,
      lines: lines,
    );
    collections.insert(0, collection);

    await Future.wait([
      _persistShops(),
      _persistInvoices(),
      _persistCollections(),
    ]);
    await _enqueue('record_collection', {
      'shop_id': shopId,
      'amount': applied,
      'method': method.name,
      'mode': mode.name,
      'notes': notes.trim(),
      'reference': reference.trim(),
      'has_proof_photo':
          proofPhotoBase64 != null && proofPhotoBase64.isNotEmpty,
      'allocations': allocations.map((key, value) => MapEntry(key, value)),
    });

    return collection;
  }

  Future<DmHandoverSummaryModel> submitHandover({
    required double countedCash,
    String cashierName = '',
    String notes = '',
  }) async {
    seedIfEmpty();
    final bag = bagCollections;
    if (bag.isEmpty) throw StateError('Bag is empty');
    final expectedCash = _money(cashInBag);
    if (_money(countedCash) != expectedCash) {
      throw StateError('Cash count mismatch');
    }

    final handover = DmHandoverSummaryModel(
      id: 'dm-ho-${DateTime.now().millisecondsSinceEpoch}',
      reference: 'HO-${_nextHandoverNumber()}',
      handedAt: DateTime.now(),
      cashAmount: expectedCash,
      chequeAmount: _money(chequeInBag),
      collectionIds: bag.map((item) => item.id).toList(growable: false),
      cashierName: cashierName.trim(),
      notes: notes.trim(),
    );
    handovers.insert(0, handover);

    for (var i = 0; i < collections.length; i++) {
      final item = collections[i];
      if (!item.isInBag) continue;
      collections[i] = item.copyWith(
        status: CollectionStatus.handedOver,
        handoverId: handover.id,
      );
    }

    await Future.wait([_persistCollections(), _persistHandovers()]);
    await _enqueue('submit_handover', {
      'counted_cash': countedCash,
      'cashier_name': cashierName.trim(),
      'notes': notes.trim(),
      'collection_ids': handover.collectionIds,
    });

    return handover;
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  int _nextReceiptNumber() {
    var max = 10020;
    for (final item in collections) {
      final digits = int.tryParse(
        item.receiptNumber.replaceAll(RegExp(r'\D'), ''),
      );
      if (digits != null && digits > max) max = digits;
    }
    return max + 1;
  }

  int _nextHandoverNumber() {
    var max = 10000;
    for (final item in handovers) {
      final digits = int.tryParse(item.reference.replaceAll(RegExp(r'\D'), ''));
      if (digits != null && digits > max) max = digits;
    }
    return max + 1;
  }

  double _money(double value) => (value * 100).round() / 100;
}
