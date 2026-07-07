// ignore_for_file: unused_field

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_product_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_model.dart';

class ObVisitCartService extends GetxService {
  ObVisitCartService(this._api);

  final ApiClient _api;
  final Map<int, List<ObVisitCartLineModel>> _linesByVisit = {};
  final Map<int, List<ObProductModel>> _productsByVisit = {};
  int _lineSeed = 1000;

  Future<List<ObProductModel>> fetchProducts({
    required int visitId,
    int limit = 500,
    int offset = 0,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final products = _productsByVisit.putIfAbsent(
      visitId,
      () => List<ObProductModel>.from(AppMockData.obSellableProducts),
    );
    final start = offset.clamp(0, products.length);
    final end = (start + limit).clamp(0, products.length);
    return products.sublist(start, end);
    // Swap with API when ready:
    // final response = await _api.get(
    //   ApiEndpoints.obProductsList,
    //   queryParameters: {'visit_id': visitId, 'limit': limit, 'offset': offset},
    // );
    // final list = response.data as List<dynamic>;
    // return list.map((e) => ObProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ObVisitCartModel> fetchCart({
    required int visitId,
    required String shopName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final lines = _linesByVisit[visitId] ?? const <ObVisitCartLineModel>[];
    return ObVisitCartModel(visitId: visitId, shopName: shopName, lines: lines);
  }

  Future<ObVisitCartLineModel> addLine({
    required int visitId,
    required int productId,
    double quantity = 1,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final products = _productsByVisit.putIfAbsent(
      visitId,
      () => List<ObProductModel>.from(AppMockData.obSellableProducts),
    );
    final idx = products.indexWhere((p) => p.id == productId);
    if (idx == -1) throw Exception('Product not found');

    final product = products[idx];
    if (product.qtyBookable <= 0) {
      throw Exception('No bookable quantity');
    }

    final lines = _linesByVisit.putIfAbsent(
      visitId,
      () => <ObVisitCartLineModel>[],
    );
    final existingIndex = lines.indexWhere(
      (line) => line.productId == productId,
    );
    if (existingIndex != -1) {
      final existing = lines[existingIndex];
      final nextQty = existing.quantity + quantity;
      final consumed = quantity.clamp(0, product.qtyBookable).toDouble();
      lines[existingIndex] = existing.copyWith(quantity: nextQty);
      products[idx] = product.copyWith(
        qtyBookable: product.qtyBookable - consumed,
      );
      return lines[existingIndex];
    }

    final accepted = quantity.clamp(0, product.qtyBookable).toDouble();
    final line = ObVisitCartLineModel(
      lineId: _lineSeed++,
      productId: product.id,
      productName: product.name,
      quantity: accepted,
      priceUnit: product.priceUnit,
      unit: product.unit,
    );
    lines.add(line);
    products[idx] = product.copyWith(
      qtyBookable: product.qtyBookable - accepted,
    );
    return line;
    // Swap with API when ready:
    // final response = await _api.post(
    //   ApiEndpoints.obVisitsLineAdd,
    //   data: {'visit_id': visitId, 'product_id': productId, 'quantity': quantity},
    // );
    // return ObVisitCartLineModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ObVisitCartLineModel> updateLine({
    required int visitId,
    required int lineId,
    double? quantity,
    double? priceUnit,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    final lines = _linesByVisit.putIfAbsent(
      visitId,
      () => <ObVisitCartLineModel>[],
    );
    final lineIndex = lines.indexWhere((line) => line.lineId == lineId);
    if (lineIndex == -1) throw Exception('Line not found');

    final line = lines[lineIndex];
    final products = _productsByVisit.putIfAbsent(
      visitId,
      () => List<ObProductModel>.from(AppMockData.obSellableProducts),
    );
    final productIndex = products.indexWhere(
      (product) => product.id == line.productId,
    );
    if (productIndex == -1) throw Exception('Product not found');

    final product = products[productIndex];
    final requestedQuantity = quantity ?? line.quantity;
    final delta = requestedQuantity - line.quantity;
    final maxAddable = product.qtyBookable;
    final appliedDelta = delta > 0
        ? delta.clamp(0, maxAddable).toDouble()
        : delta;
    final nextQuantity = (line.quantity + appliedDelta)
        .clamp(1, 1000000)
        .toDouble();
    final remainingAfter = (product.qtyBookable - appliedDelta)
        .clamp(0, 1000000)
        .toDouble();

    final next = line.copyWith(
      quantity: nextQuantity,
      priceUnit: priceUnit ?? line.priceUnit,
    );
    lines[lineIndex] = next;
    products[productIndex] = product.copyWith(qtyBookable: remainingAfter);
    return next;
    // Swap with API when ready:
    // final response = await _api.post(
    //   ApiEndpoints.obVisitsLineUpdate,
    //   data: {'line_id': lineId, 'quantity': quantity, 'price_unit': priceUnit},
    // );
    // return ObVisitCartLineModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> removeLine({required int visitId, required int lineId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final lines = _linesByVisit.putIfAbsent(
      visitId,
      () => <ObVisitCartLineModel>[],
    );
    final lineIndex = lines.indexWhere((line) => line.lineId == lineId);
    if (lineIndex == -1) return;

    final line = lines[lineIndex];
    final products = _productsByVisit.putIfAbsent(
      visitId,
      () => List<ObProductModel>.from(AppMockData.obSellableProducts),
    );
    final productIndex = products.indexWhere(
      (product) => product.id == line.productId,
    );
    if (productIndex != -1) {
      final product = products[productIndex];
      products[productIndex] = product.copyWith(
        qtyBookable: product.qtyBookable + line.quantity,
      );
    }

    lines.removeAt(lineIndex);
    // Swap with API when ready:
    // await _api.post(ApiEndpoints.obVisitsLineRemove, data: {'line_id': lineId});
  }

  Future<String> placeOrder({required int visitId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final lines = _linesByVisit[visitId] ?? const <ObVisitCartLineModel>[];
    if (lines.isEmpty) throw Exception('Cart is empty');
    _linesByVisit[visitId] = [];
    return 'SO-${DateTime.now().millisecondsSinceEpoch}';
    // Swap with API when ready:
    // final response = await _api.post(
    //   ApiEndpoints.obVisitsPlaceOrder,
    //   data: {'visit_id': visitId},
    // );
    // return (response.data as Map<String, dynamic>)['order_id'].toString();
  }

  Future<void> endWithoutOrder({
    required int visitId,
    required String notes,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    _linesByVisit[visitId] = [];
    // Swap with API when ready:
    // await _api.post(
    //   ApiEndpoints.obVisitsEndWithoutOrder,
    //   data: {'visit_id': visitId, 'notes': notes},
    // );
  }

  Future<void> saveVisitNotes({
    required int visitId,
    required String notes,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // Swap with API when ready:
    // await _api.post(
    //   ApiEndpoints.obVisitsNotes,
    //   data: {'visit_id': visitId, 'notes': notes},
    // );
  }
}
