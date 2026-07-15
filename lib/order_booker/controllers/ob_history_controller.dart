import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker_mode.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_visit_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/ob_visit_service.dart';

class ObHistoryController extends GetxController {
  ObHistoryController(this._visitService);

  final ObVisitService _visitService;

  static const _pageSize = 20;

  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxnString error = RxnString();
  final RxList<ObVisitSummaryModel> visits = <ObVisitSummaryModel>[].obs;
  final Rxn<DateTime> dateFrom = Rxn<DateTime>();
  final Rxn<DateTime> dateTo = Rxn<DateTime>();
  final Rxn<VisitOutcome> outcomeFilter = Rxn<VisitOutcome>();

  int _offset = 0;
  int _total = 0;

  bool get hasMore => visits.length < _total;

  static const outcomeFilters = <VisitOutcome?>[
    null,
    VisitOutcome.orderPlaced,
    VisitOutcome.endedWithoutOrder,
    VisitOutcome.skipped,
  ];

  List<ObVisitSummaryModel> get filteredVisits {
    final filter = outcomeFilter.value;
    if (filter == null) return visits;
    return visits.where((visit) => visit.outcome == filter).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadVisits(reset: true);
  }

  Future<void> loadVisits({bool reset = false}) async {
    final hadCache = visits.isNotEmpty;
    if (reset && !hadCache) {
      isLoading.value = true;
    }
    if (!reset) {
      // pagination / append — keep current error until success
    } else if (!hadCache) {
      error.value = null;
    }

    try {
      final result = await _visitService.fetchMyVisits(
        limit: _pageSize,
        offset: reset ? 0 : _offset,
        dateFrom: dateFrom.value,
        dateTo: dateTo.value,
      );
      _total = result.total;
      if (reset) {
        visits.assignAll(result.visits);
        _offset = visits.length;
      } else {
        visits.addAll(result.visits);
        _offset = visits.length;
      }
      error.value = null;
    } catch (_) {
      if (!hadCache) {
        error.value = AppTexts.error;
        if (reset) {
          visits.clear();
          _offset = 0;
          _total = 0;
        }
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMore) return;
    isLoadingMore.value = true;
    await loadVisits();
  }

  void selectOutcomeFilter(VisitOutcome? outcome) {
    outcomeFilter.value = outcome;
  }

  bool isOutcomeSelected(VisitOutcome? outcome) =>
      outcomeFilter.value == outcome;

  String outcomeFilterLabel(VisitOutcome? outcome) {
    if (outcome == null) return AppTexts.obVisitsFilterAll;
    return outcome.label;
  }

  String get dateFromLabel => dateFrom.value == null
      ? AppTexts.obVisitFilterDateFrom
      : AppFormatter.shortDate(dateFrom.value!);

  String get dateToLabel => dateTo.value == null
      ? AppTexts.obVisitFilterDateTo
      : AppFormatter.shortDate(dateTo.value!);

  bool get hasDateFilter => dateFrom.value != null || dateTo.value != null;

  Future<void> pickDateFrom(BuildContext context) async {
    final today = DateTime.now();
    final maxDate = DateTime(today.year, today.month, today.day);
    final picked = await AppDateTimePicker.show(
      context,
      title: AppTexts.obVisitFilterDateFrom,
      initial: dateFrom.value ?? maxDate,
      maxDate: maxDate,
      mode: AppDateTimePickerMode.dateOnly,
    );
    if (picked == null) return;
    dateFrom.value = DateTime(picked.year, picked.month, picked.day);
    if (dateTo.value != null && dateTo.value!.isBefore(dateFrom.value!)) {
      dateTo.value = dateFrom.value;
    }
    await loadVisits(reset: true);
  }

  Future<void> pickDateTo(BuildContext context) async {
    final today = DateTime.now();
    final maxDate = DateTime(today.year, today.month, today.day);
    final picked = await AppDateTimePicker.show(
      context,
      title: AppTexts.obVisitFilterDateTo,
      initial: dateTo.value ?? dateFrom.value ?? maxDate,
      minDate: dateFrom.value,
      maxDate: maxDate,
      mode: AppDateTimePickerMode.dateOnly,
    );
    if (picked == null) return;
    dateTo.value = DateTime(picked.year, picked.month, picked.day);
    await loadVisits(reset: true);
  }

  Future<void> clearDateFilter() async {
    dateFrom.value = null;
    dateTo.value = null;
    await loadVisits(reset: true);
  }

  void openVisit(ObVisitSummaryModel visit) {
    Get.toNamed(
      AppRoutes.obVisitDetail.replaceFirst(':id', '${visit.visitId}'),
    );
  }

  String visitTimeLabel(ObVisitSummaryModel visit) {
    final date = AppFormatter.shortDate(visit.checkedInAt);
    final time = AppFormatter.timeOfDay(visit.checkedInAt);
    return '$date • $time';
  }
}
