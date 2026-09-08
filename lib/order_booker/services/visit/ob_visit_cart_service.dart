import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/database/app_database.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/services/connectivity_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/offline_cache_service.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_product_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_model.dart';

/// Local-first visit cart backed by SQLite. Network is used on initial load
/// and when flushing the submit outbox — not on every cart tap.
class ObVisitCartService extends GetxService {
  ObVisitCartService(
    this._api,
    this._db,
    this._outbox, {
    OfflineCacheService? cache,
  }) : _cache = cache ?? Get.find<OfflineCacheService>();

  final ApiClient _api;
  final AppDatabase _db;
  final SyncOutboxService _outbox;
  final OfflineCacheService _cache;

  int _nextLocalLineId = -1;

  Future<List<ObProductModel>> fetchProducts({
    required int visitId,
    int limit = 500,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _readProductsFromDb(visitId);
      if (cached.isNotEmpty && _shouldServeCacheOnly()) return cached;
      if (cached.isNotEmpty && !forceRefresh) {
        unawaited(
          _fetchProductsFromNetwork(visitId, limit: limit, offset: offset),
        );
        return cached;
      }
    }

    try {
      return await _fetchProductsFromNetwork(
        visitId,
        limit: limit,
        offset: offset,
      );
    } catch (_) {
      final cached = await _readProductsFromDb(visitId);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  Future<List<ObProductModel>> _fetchProductsFromNetwork(
    int visitId, {
    required int limit,
    required int offset,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.obProductsList,
      data: {'visit_id': visitId, 'limit': limit, 'offset': offset},
    );
    final products = ApiMap.listOf(
      data,
      'products',
    ).map(ObProductModel.fromJson).toList(growable: false);

    await _db.replaceProductsForVisit(
      visitId,
      products
          .map(
            (p) => VisitProductsCompanion.insert(
              visitId: visitId,
              productId: p.id,
              jsonPayload: jsonEncode(p.toJson()),
            ),
          )
          .toList(growable: false),
    );
    return products;
  }

  Future<List<ObProductModel>> _readProductsFromDb(int visitId) async {
    final rows = await _db.productsForVisit(visitId);
    return rows
        .map((row) {
          try {
            final json = jsonDecode(row.jsonPayload) as Map<String, dynamic>;
            return ObProductModel.fromJson(json);
          } catch (_) {
            return null;
          }
        })
        .whereType<ObProductModel>()
        .toList(growable: false);
  }

  Future<ObVisitCartModel> fetchCart({
    required int visitId,
    required String shopName,
    bool mergeFromServer = true,
  }) async {
    if (mergeFromServer && !_shouldServeCacheOnly()) {
      try {
        await _mergeServerCart(visitId: visitId);
      } catch (_) {
        // Continue with local lines.
      }
    }

    final lines = await _readLinesFromDb(visitId);
    return ObVisitCartModel(visitId: visitId, shopName: shopName, lines: lines);
  }

  Future<void> _mergeServerCart({required int visitId}) async {
    final data = await _api.postData(
      ApiEndpoints.obVisitsGet,
      data: {'visit_id': visitId},
    );
    final visitJson = ApiMap.asMap(data['visit']) ?? data;
    final lines = ApiMap.listOf(
      visitJson,
      'lines',
    ).map(ObVisitCartLineModel.fromJson).toList(growable: false);

    await _db.clearVisitCart(visitId);
    for (final line in lines) {
      await _db.upsertCartLine(
        VisitCartLinesCompanion.insert(
          visitId: visitId,
          lineId: line.lineId,
          productId: line.productId,
          productName: line.productName,
          quantity: line.quantity,
          priceUnit: line.priceUnit,
          unit: Value(line.unit),
          isLocalOnly: const Value(false),
        ),
      );
    }
  }

  Future<ObVisitCartLineModel> addLine({
    required int visitId,
    required int productId,
    double quantity = 1,
  }) async {
    final existing = await _findLineByProduct(visitId, productId);
    if (existing != null) {
      return updateLine(
        visitId: visitId,
        lineId: existing.lineId,
        quantity: existing.quantity + quantity,
      );
    }

    final products = await _readProductsFromDb(visitId);
    ObProductModel? product;
    for (final item in products) {
      if (item.id == productId) {
        product = item;
        break;
      }
    }
    if (product == null && !_shouldServeCacheOnly()) {
      final fresh = await _fetchProductsFromNetwork(
        visitId,
        limit: 500,
        offset: 0,
      );
      for (final item in fresh) {
        if (item.id == productId) product = item;
      }
    }
    if (product == null) {
      throw ApiException(message: 'Product not found in local catalog.');
    }

    final lineId = _nextLocalLineId--;
    final line = ObVisitCartLineModel(
      lineId: lineId,
      productId: product.id,
      productName: product.name,
      quantity: quantity,
      priceUnit: product.priceUnit,
      unit: product.unit,
    );
    await _persistLine(visitId, line, localOnly: true);
    return line;
  }

  Future<ObVisitCartLineModel> updateLine({
    required int visitId,
    required int lineId,
    double? quantity,
    double? priceUnit,
  }) async {
    final current = await _findLine(visitId, lineId);
    if (current == null) {
      throw ApiException(message: 'Cart line not found locally.');
    }
    final updated = current.copyWith(
      quantity: quantity ?? current.quantity,
      priceUnit: priceUnit ?? current.priceUnit,
    );
    await _persistLine(visitId, updated, localOnly: lineId < 0);
    return updated;
  }

  Future<void> removeLine({required int visitId, required int lineId}) async {
    await _db.deleteCartLine(visitId: visitId, lineId: lineId);
  }

  /// Queues or immediately syncs order submit. Returns order number when synced.
  Future<ObOrderSubmitResult> submitOrder({
    required int visitId,
    required int taskId,
    required String shopId,
    required String shopName,
    required double latitude,
    required double longitude,
  }) async {
    final cart = await fetchCart(
      visitId: visitId,
      shopName: shopName,
      mergeFromServer: false,
    );
    if (cart.lines.isEmpty) {
      throw ApiException(message: 'Cart is empty.');
    }

    final payload = {
      'visit_id': visitId,
      'task_id': taskId,
      'shop_id': shopId,
      'shop_name': shopName,
      'latitude': latitude,
      'longitude': longitude,
      'lines': cart.lines.map((l) => l.toJson()).toList(growable: false),
    };

    if (_shouldServeCacheOnly()) {
      await _outbox.enqueue(
        role: 'orderBooker',
        action: 'submit_order',
        payload: payload,
      );
      return const ObOrderSubmitResult(queued: true, orderNumber: null);
    }

    try {
      await _outbox.enqueue(
        role: 'orderBooker',
        action: 'submit_order',
        payload: payload,
      );
      await _outbox.flush(force: true);
      final orderNumber = await _readOrderNumber(visitId);
      if (orderNumber != null) {
        await _db.clearVisitCart(visitId);
        return ObOrderSubmitResult(queued: false, orderNumber: orderNumber);
      }
      return const ObOrderSubmitResult(queued: true, orderNumber: null);
    } on ApiException catch (e) {
      final existing = await _readOrderNumber(visitId);
      if (existing != null) {
        await _db.clearVisitCart(visitId);
        return ObOrderSubmitResult(queued: false, orderNumber: existing);
      }
      if (_isAmbiguousError(e)) {
        return const ObOrderSubmitResult(queued: true, orderNumber: null);
      }
      rethrow;
    }
  }

  Future<ObOrderSubmitResult> endWithoutOrder({
    required int visitId,
    required int taskId,
    required String shopId,
    required String notes,
    String? shopName,
  }) async {
    final payload = {
      'visit_id': visitId,
      'task_id': taskId,
      'shop_id': shopId,
      if (shopName != null && shopName.isNotEmpty) 'shop_name': shopName,
      'notes': notes.trim(),
    };

    if (_shouldServeCacheOnly()) {
      await _outbox.enqueue(
        role: 'orderBooker',
        action: 'end_visit_without_order',
        payload: payload,
      );
      return const ObOrderSubmitResult(queued: true, orderNumber: null);
    }

    try {
      await _outbox.enqueue(
        role: 'orderBooker',
        action: 'end_visit_without_order',
        payload: payload,
      );
      await _outbox.flush(force: true);
      return const ObOrderSubmitResult(queued: false, orderNumber: null);
    } on ApiException catch (e) {
      if (_isAmbiguousError(e)) {
        return const ObOrderSubmitResult(queued: true, orderNumber: null);
      }
      rethrow;
    }
  }

  Future<bool> saveVisitNotes({
    required int visitId,
    required String notes,
    int? taskId,
    String? shopId,
    String? shopName,
  }) async {
    final trimmed = notes.trim();
    await _persistVisitNotesLocally(
      visitId: visitId,
      notes: trimmed,
      taskId: taskId,
      shopId: shopId,
      shopName: shopName,
    );

    final payload = {
      'visit_id': visitId,
      'notes': trimmed,
      'task_id': ?taskId,
      if (shopId != null && shopId.isNotEmpty) 'shop_id': shopId,
      if (shopName != null && shopName.isNotEmpty) 'shop_name': shopName,
    };

    if (_shouldServeCacheOnly()) {
      await _outbox.enqueue(
        role: 'orderBooker',
        action: 'visit_notes',
        payload: payload,
      );
      return true;
    }
    await _api.postData(
      ApiEndpoints.obVisitsNotes,
      data: {'visit_id': visitId, 'notes': trimmed},
    );
    return false;
  }

  Future<String?> readVisitNotes(int visitId) async {
    final cached = await _cache.readMap(OfflineCacheKeys.visitNotes(visitId));
    return ApiMap.asString(cached?['notes']);
  }

  Future<void> _persistVisitNotesLocally({
    required int visitId,
    required String notes,
    int? taskId,
    String? shopId,
    String? shopName,
  }) async {
    await _cache.saveMap(OfflineCacheKeys.visitNotes(visitId), {
      'visit_id': visitId,
      'notes': notes,
      'task_id': ?taskId,
      'shop_id': ?shopId,
      'shop_name': ?shopName,
    });
  }

  Future<String?> _readOrderNumber(int visitId) async {
    try {
      final data = await _api.postData(
        ApiEndpoints.obVisitsGet,
        data: {'visit_id': visitId},
      );
      final visit = ApiMap.asMap(data['visit']) ?? data;
      return ApiMap.asString(visit['sale_order_name']) ??
          ApiMap.asString(visit['order_number']);
    } catch (_) {
      return null;
    }
  }

  bool _shouldServeCacheOnly() {
    if (!Get.isRegistered<ConnectivityService>()) return false;
    final c = Get.find<ConnectivityService>();
    return !c.isOnline.value || c.quality.value == NetworkQuality.weak;
  }

  bool _isAmbiguousError(ApiException e) {
    final msg = e.message.toLowerCase();
    return msg.contains('timed out') ||
        msg.contains('timeout') ||
        msg.contains('internet') ||
        msg.contains('connection');
  }

  Future<void> _persistLine(
    int visitId,
    ObVisitCartLineModel line, {
    required bool localOnly,
  }) async {
    await _db.upsertCartLine(
      VisitCartLinesCompanion.insert(
        visitId: visitId,
        lineId: line.lineId,
        productId: line.productId,
        productName: line.productName,
        quantity: line.quantity,
        priceUnit: line.priceUnit,
        unit: Value(line.unit),
        isLocalOnly: Value(localOnly),
      ),
    );
  }

  Future<ObVisitCartLineModel?> _findLine(int visitId, int lineId) async {
    final rows = await _db.linesForVisit(visitId);
    for (final row in rows) {
      if (row.lineId == lineId) return _mapLine(row);
    }
    return null;
  }

  Future<ObVisitCartLineModel?> _findLineByProduct(
    int visitId,
    int productId,
  ) async {
    final rows = await _db.linesForVisit(visitId);
    for (final row in rows) {
      if (row.productId == productId) return _mapLine(row);
    }
    return null;
  }

  Future<List<ObVisitCartLineModel>> _readLinesFromDb(int visitId) async {
    final rows = await _db.linesForVisit(visitId);
    return rows.map(_mapLine).toList(growable: false);
  }

  ObVisitCartLineModel _mapLine(VisitCartLine row) => ObVisitCartLineModel(
    lineId: row.lineId,
    productId: row.productId,
    productName: row.productName,
    quantity: row.quantity,
    priceUnit: row.priceUnit,
    unit: row.unit,
  );
}

class ObOrderSubmitResult {
  const ObOrderSubmitResult({required this.queued, this.orderNumber});

  final bool queued;
  final String? orderNumber;
}
