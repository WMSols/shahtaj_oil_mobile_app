import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/api_endpoints.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_product_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_line_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/visit/ob_visit_cart_model.dart';

class ObVisitCartService extends GetxService {
  ObVisitCartService(this._api);

  final ApiClient _api;
  final Map<int, List<ObVisitCartLineModel>> _linesByVisit = {};
  final Map<int, List<ObProductModel>> _productsByVisit = {};

  Future<List<ObProductModel>> fetchProducts({
    required int visitId,
    int limit = 500,
    int offset = 0,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.obProductsList,
      data: {'visit_id': visitId, 'limit': limit, 'offset': offset},
    );
    final products = ApiMap.listOf(
      data,
      'products',
    ).map(ObProductModel.fromJson).toList(growable: false);
    _productsByVisit[visitId] = List<ObProductModel>.from(products);
    return products;
  }

  Future<ObVisitCartModel> fetchCart({
    required int visitId,
    required String shopName,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.obVisitsGet,
      data: {'visit_id': visitId},
    );
    final visitJson = ApiMap.asMap(data['visit']) ?? data;
    final lines = ApiMap.listOf(
      visitJson,
      'lines',
    ).map(ObVisitCartLineModel.fromJson).toList(growable: false);
    _linesByVisit[visitId] = List<ObVisitCartLineModel>.from(lines);
    return ObVisitCartModel(visitId: visitId, shopName: shopName, lines: lines);
  }

  Future<ObVisitCartLineModel> addLine({
    required int visitId,
    required int productId,
    double quantity = 1,
  }) async {
    final data = await _api.postData(
      ApiEndpoints.obVisitsLineAdd,
      data: {
        'visit_id': visitId,
        'product_id': productId,
        'quantity': quantity,
      },
    );
    _cacheVisitLines(visitId, data);
    return _lineFromResponse(data);
  }

  Future<ObVisitCartLineModel> updateLine({
    required int visitId,
    required int lineId,
    double? quantity,
    double? priceUnit,
  }) async {
    final payload = <String, dynamic>{'line_id': lineId};
    if (quantity != null) payload['quantity'] = quantity;
    if (priceUnit != null) payload['price_unit'] = priceUnit;

    final data = await _api.postData(
      ApiEndpoints.obVisitsLineUpdate,
      data: payload,
    );
    _cacheVisitLines(visitId, data);
    return _lineFromResponse(data);
  }

  Future<void> removeLine({required int visitId, required int lineId}) async {
    final data = await _api.postData(
      ApiEndpoints.obVisitsLineRemove,
      data: {'line_id': lineId},
    );
    _cacheVisitLines(visitId, data);
  }

  Future<String> placeOrder({required int visitId}) async {
    final data = await _api.postData(
      ApiEndpoints.obVisitsPlaceOrder,
      data: {'visit_id': visitId},
    );
    _linesByVisit[visitId] = [];
    _productsByVisit.remove(visitId);

    final visit = ApiMap.asMap(data['visit']);
    final order =
        ApiMap.asString(data['sale_order_name']) ??
        ApiMap.asString(data['order_number']) ??
        ApiMap.asString(data['order_id']) ??
        ApiMap.asString(visit?['sale_order_name']) ??
        ApiMap.asString(visit?['order_number']) ??
        ApiMap.asString(visit?['order_id']);
    if (order == null || order.isEmpty) {
      throw ApiException(message: 'Order placed but no order id was returned.');
    }
    return order;
  }

  Future<void> endWithoutOrder({
    required int visitId,
    required String notes,
  }) async {
    await _api.postData(
      ApiEndpoints.obVisitsEndWithoutOrder,
      data: {'visit_id': visitId, 'notes': notes.trim()},
    );
    _linesByVisit[visitId] = [];
    _productsByVisit.remove(visitId);
  }

  Future<void> saveVisitNotes({
    required int visitId,
    required String notes,
  }) async {
    await _api.postData(
      ApiEndpoints.obVisitsNotes,
      data: {'visit_id': visitId, 'notes': notes.trim()},
    );
  }

  void _cacheVisitLines(int visitId, Map<String, dynamic> data) {
    final visit = ApiMap.asMap(data['visit']);
    if (visit == null) return;
    _linesByVisit[visitId] = ApiMap.listOf(
      visit,
      'lines',
    ).map(ObVisitCartLineModel.fromJson).toList();
  }

  ObVisitCartLineModel _lineFromResponse(Map<String, dynamic> data) {
    final line = ApiMap.asMap(data['line']);
    if (line != null) return ObVisitCartLineModel.fromJson(line);

    final visit = ApiMap.asMap(data['visit']);
    final lines = visit == null
        ? const <Map<String, dynamic>>[]
        : ApiMap.listOf(visit, 'lines');
    if (lines.isNotEmpty) {
      return ObVisitCartLineModel.fromJson(lines.last);
    }
    throw ApiException(message: 'Cart line response was empty.');
  }
}
