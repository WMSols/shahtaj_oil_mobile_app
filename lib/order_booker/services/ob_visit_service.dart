// ignore_for_file: unused_field

import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/mock/app_mock_data.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_client.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_detail_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_summary_model.dart';

class ObVisitService extends GetxService {
  ObVisitService(this._api);
  final ApiClient _api;

  Future<ObVisitListResult> fetchMyVisits({
    int limit = 50,
    int offset = 0,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    var visits = List<ObVisitSummaryModel>.from(AppMockData.obVisitHistory);
    visits = _filterByDateRange(visits, dateFrom: dateFrom, dateTo: dateTo);
    visits.sort((a, b) => b.checkedInAt.compareTo(a.checkedInAt));

    final slice = visits.skip(offset).take(limit).toList();
    return ObVisitListResult(visits: slice, total: visits.length);

    // Swap with API when ready:
    // final response = await _api.get(
    //   ApiEndpoints.obVisitsMine,
    //   queryParameters: {
    //     'limit': limit,
    //     'offset': offset,
    //     if (dateFrom != null) 'date_from': AppFormatter.apiDate(dateFrom),
    //     if (dateTo != null) 'date_to': AppFormatter.apiDate(dateTo),
    //   },
    // );
    // return ObVisitListResult.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ObVisitDetailModel> fetchVisitDetail({required int visitId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final exists = AppMockData.obVisitHistory.any(
      (visit) => visit.visitId == visitId,
    );
    if (!exists) throw Exception('Visit not found');
    return AppMockData.obVisitDetail(visitId);

    // Swap with API when ready:
    // final response = await _api.get(
    //   ApiEndpoints.obVisitsGet,
    //   queryParameters: {'visit_id': visitId},
    // );
    // return ObVisitDetailModel.fromJson(response.data as Map<String, dynamic>);
  }

  List<ObVisitSummaryModel> _filterByDateRange(
    List<ObVisitSummaryModel> visits, {
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return visits.where((visit) {
      final day = DateTime(
        visit.checkedInAt.year,
        visit.checkedInAt.month,
        visit.checkedInAt.day,
      );
      if (dateFrom != null) {
        final from = DateTime(dateFrom.year, dateFrom.month, dateFrom.day);
        if (day.isBefore(from)) return false;
      }
      if (dateTo != null) {
        final to = DateTime(dateTo.year, dateTo.month, dateTo.day);
        if (day.isAfter(to)) return false;
      }
      return true;
    }).toList();
  }
}
