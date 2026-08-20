import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_line_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_invoice_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_shop_due_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/handover/rm_handover_summary_model.dart';

/// In-memory RM store backed by [OfflineCacheService] for persistence across
/// hot restarts. API integration will replace the mock-seed path.
class RmCollectionStore extends GetxService {
  RmCollectionStore({
    OfflineCacheService? cache,
    ConnectivityService? connectivity,
  }) : _cache = cache ?? Get.find<OfflineCacheService>(),
       _connectivity = connectivity ?? Get.find<ConnectivityService>();

  final OfflineCacheService _cache;
  final ConnectivityService _connectivity;

  final shops = <RmShopDueModel>[];
  final invoices = <RmInvoiceModel>[];
  final collections = <RmCollectionSummaryModel>[];
  final handovers = <RmHandoverSummaryModel>[];

  bool _hydrated = false;
  static const _role = 'recoveryMan';

  @override
  void onInit() {
    super.onInit();
    _cache.registerSyncHandler(_role, 'record_collection', (_) async {});
    _cache.registerSyncHandler(_role, 'submit_handover', (_) async {});
  }

  Future<void> hydrate() async {
    if (_hydrated) return;
    _hydrated = true;

    final cachedShops = await _cache.readList(OfflineCacheKeys.rmShops);
    final cachedInvoices = await _cache.readList(OfflineCacheKeys.rmInvoices);
    final cachedCollections = await _cache.readList(
      OfflineCacheKeys.rmCollections,
    );
    final cachedHandovers = await _cache.readList(OfflineCacheKeys.rmHandovers);

    if (cachedShops.isNotEmpty &&
        cachedInvoices.isNotEmpty &&
        cachedCollections.isNotEmpty) {
      shops.addAll(cachedShops.map(RmShopDueModel.fromJson));
      invoices.addAll(cachedInvoices.map(RmInvoiceModel.fromJson));
      collections.addAll(
        cachedCollections.map(RmCollectionSummaryModel.fromJson),
      );
      handovers.addAll(cachedHandovers.map(RmHandoverSummaryModel.fromJson));
    } else {
      shops.addAll(AppMockData.rmShops);
      invoices.addAll(AppMockData.rmInvoices);
      collections.addAll(AppMockData.rmCollections);
      handovers.addAll(AppMockData.rmHandovers);
      await _persistAll();
    }
  }

  /// Legacy synchronous seed used by services that do not await [hydrate].
  void seedIfEmpty() {
    if (_hydrated || shops.isNotEmpty) return;
    _hydrated = true;
    shops.addAll(AppMockData.rmShops);
    invoices.addAll(AppMockData.rmInvoices);
    collections.addAll(AppMockData.rmCollections);
    handovers.addAll(AppMockData.rmHandovers);
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
    OfflineCacheKeys.rmShops,
    shops.map((e) => e.toJson()).toList(growable: false),
  );

  Future<void> _persistInvoices() => _cache.saveList(
    OfflineCacheKeys.rmInvoices,
    invoices.map((e) => e.toJson()).toList(growable: false),
  );

  Future<void> _persistCollections() => _cache.saveList(
    OfflineCacheKeys.rmCollections,
    collections.map((e) => e.toJson()).toList(growable: false),
  );

  Future<void> _persistHandovers() => _cache.saveList(
    OfflineCacheKeys.rmHandovers,
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

  List<RmCollectionSummaryModel> get bagCollections =>
      collections.where((item) => item.isInBag).toList(growable: false);

  double get cashInBag => bagCollections
      .where((item) => item.method == PaymentMethod.cash)
      .fold<double>(0, (sum, item) => sum + item.amount);

  double get chequeInBag => bagCollections
      .where((item) => item.method == PaymentMethod.cheque)
      .fold<double>(0, (sum, item) => sum + item.amount);

  double get bagTotal => cashInBag + chequeInBag;

  int get shopsDueCount => shops.where((shop) => shop.outstanding > 0).length;

  List<RmCollectionSummaryModel> get recentCollections {
    final sorted = [...collections]
      ..sort((a, b) => b.collectedAt.compareTo(a.collectedAt));
    return sorted.take(3).toList(growable: false);
  }

  List<RmCollectionSummaryModel> collectionsForHistory({
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

  RmCollectionSummaryModel? collectionById(String id) {
    for (final item in collections) {
      if (item.id == id) return item;
    }
    return null;
  }

  List<RmHandoverSummaryModel> get recentHandovers {
    final sorted = [...handovers]
      ..sort((a, b) => b.handedAt.compareTo(a.handedAt));
    return sorted;
  }

  RmHandoverSummaryModel? handoverById(String id) {
    for (final item in handovers) {
      if (item.id == id) return item;
    }
    return null;
  }

  List<RmCollectionSummaryModel> collectionsForHandover(String handoverId) {
    return collections
        .where((item) => item.handoverId == handoverId)
        .toList(growable: false);
  }

  List<RmShopDueModel> get shopsWithDue =>
      shops.where((shop) => shop.outstanding > 0).toList(growable: false);

  RmShopDueModel? shopById(String shopId) {
    for (final shop in shops) {
      if (shop.id == shopId) return shop;
    }
    return null;
  }

  List<RmInvoiceModel> invoicesForShop(String shopId) {
    final rows = invoices.where((invoice) => invoice.shopId == shopId).toList();
    rows.sort((a, b) => a.issuedAt.compareTo(b.issuedAt));
    return rows;
  }

  List<RmInvoiceModel> openInvoicesForShop(String shopId) => invoicesForShop(
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

  Future<RmCollectionSummaryModel> recordCollection({
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
    final lines = <RmCollectionLineModel>[];
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
        RmCollectionLineModel(
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

    final collection = RmCollectionSummaryModel(
      id: 'rm-col-${DateTime.now().millisecondsSinceEpoch}',
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

  Future<RmHandoverSummaryModel> submitHandover({
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

    final handover = RmHandoverSummaryModel(
      id: 'rm-ho-${DateTime.now().millisecondsSinceEpoch}',
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
