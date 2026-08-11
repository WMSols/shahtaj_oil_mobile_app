import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker_mode.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/history/ob_visit_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/history/ob_visit_service.dart';

class ObHistoryController extends GetxController {
  ObHistoryController(this._visitService);

  final ObVisitService _visitService;

  static const _pageSize = 20;
  static const _minFilteredDesired = 8;

  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxnString error = RxnString();
  final RxList<ObVisitSummaryModel> visits = <ObVisitSummaryModel>[].obs;
  final Rxn<DateTime> dateFrom = Rxn<DateTime>();
  final Rxn<DateTime> dateTo = Rxn<DateTime>();
  final Rxn<VisitOutcome> outcomeFilter = Rxn<VisitOutcome>();
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  int _offset = 0;
  int _total = 0;

  bool get hasMore => visits.length < _total;

  static const outcomeFilters = <VisitOutcome?>[
    null,
    VisitOutcome.orderPlaced,
    VisitOutcome.endedWithoutOrder,
  ];

  List<ObVisitSummaryModel> get filteredVisits {
    final filter = outcomeFilter.value;
    final query = searchQuery.value.trim().toLowerCase();
    return visits.where((visit) {
      if (filter != null && visit.outcome != filter) return false;
      if (query.isEmpty) return true;
      return visit.shopName.toLowerCase().contains(query) ||
          (visit.ownerName?.toLowerCase().contains(query) ?? false) ||
          (visit.orderNumber?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  int get filteredCount => filteredVisits.length;

  double get filteredOrdersTotal => filteredVisits.fold<double>(
    0,
    (sum, visit) => sum + (visit.subtotal ?? 0),
  );

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(
      () => searchQuery.value = searchController.text,
    );
    loadVisits(reset: true);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadVisits({bool reset = false}) async {
    final hadCache = visits.isNotEmpty;
    if (reset && !hadCache) {
      isLoading.value = true;
    }
    if (reset && !hadCache) {
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
      if (reset || outcomeFilter.value != null) {
        await _fillFilteredIfNeeded();
      }
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

  Future<void> _fillFilteredIfNeeded() async {
    if (outcomeFilter.value == null) return;
    var guard = 0;
    while (hasMore &&
        filteredVisits.length < _minFilteredDesired &&
        guard < 5) {
      guard++;
      final result = await _visitService.fetchMyVisits(
        limit: _pageSize,
        offset: _offset,
        dateFrom: dateFrom.value,
        dateTo: dateTo.value,
      );
      _total = result.total;
      if (result.visits.isEmpty) break;
      visits.addAll(result.visits);
      _offset = visits.length;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMore) return;
    isLoadingMore.value = true;
    await loadVisits();
  }

  void selectOutcomeFilter(VisitOutcome? outcome) {
    outcomeFilter.value = outcome;
    if (outcome != null) {
      unawaitedFill();
    }
  }

  void unawaitedFill() {
    Future.microtask(() async {
      if (isLoading.value || isLoadingMore.value) return;
      isLoadingMore.value = true;
      try {
        await _fillFilteredIfNeeded();
      } finally {
        isLoadingMore.value = false;
      }
    });
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

  String? visitDurationLabel(ObVisitSummaryModel visit) {
    final out = visit.checkedOutAt;
    if (out == null) return null;
    final duration = out.difference(visit.checkedInAt);
    if (duration.isNegative) return null;
    return AppFormatter.durationShort(duration);
  }
}
