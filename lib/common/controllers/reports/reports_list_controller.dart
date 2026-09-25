import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/common/models/reports/report_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/common/services/reports/reports_service.dart';
import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/sync_outbox_service.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';

class ReportsListController extends GetxController {
  ReportsListController(this._service);

  final ReportsService _service;

  static const _pageSize = 20;

  final RxBool isLoading = true.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxnString error = RxnString();
  final RxList<ReportSummaryModel> reports = <ReportSummaryModel>[].obs;
  final Rxn<ReportState> stateFilter = Rxn<ReportState>();
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  int _offset = 0;
  int _total = 0;
  Worker? _pendingWorker;
  int _loadToken = 0;

  bool get hasMore => reports.length < _total;

  List<ReportSummaryModel> get filteredReports {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return reports.toList(growable: false);
    return reports
        .where((report) {
          return report.name.toLowerCase().contains(query) ||
              report.subject.toLowerCase().contains(query) ||
              report.description.toLowerCase().contains(query) ||
              report.tags.any((t) => t.name.toLowerCase().contains(query));
        })
        .toList(growable: false);
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(
      () => searchQuery.value = searchController.text,
    );
    load(reset: true, force: true);
    if (Get.isRegistered<SyncOutboxService>()) {
      _pendingWorker = ever(
        Get.find<SyncOutboxService>().pendingCount,
        (_) => load(reset: true),
      );
    }
  }

  @override
  void onClose() {
    _pendingWorker?.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> load({bool reset = false, bool force = false}) async {
    final token = ++_loadToken;

    if (reset) {
      error.value = null;
      _offset = 0;
      if (reports.isEmpty) {
        isLoading.value = true;
      } else {
        isRefreshing.value = true;
      }
    } else {
      if (!hasMore || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    try {
      final result = await _service.fetchMyReports(
        state: stateFilter.value,
        limit: _pageSize,
        offset: reset ? 0 : _offset,
        forceNetwork: force && reset,
      );
      if (token != _loadToken) return;

      _total = result.count;
      if (reset) {
        reports.assignAll(result.reports);
      } else {
        reports.addAll(result.reports);
      }
      reports.refresh();
      _offset = reports.where((r) => r.reportId > 0).length;
      error.value = null;
    } catch (_) {
      if (token != _loadToken) return;
      if (reports.isEmpty) {
        error.value = AppTexts.error;
      } else {
        AppToast.showError(AppTexts.error);
      }
    } finally {
      if (token == _loadToken) {
        isLoading.value = false;
        isRefreshing.value = false;
        isLoadingMore.value = false;
      }
    }
  }

  void selectState(ReportState? state) {
    if (stateFilter.value == state) return;
    stateFilter.value = state;
    load(reset: true, force: true);
  }

  Future<void> openCreate() async {
    await Get.toNamed(AppRoutes.reportCreate);
    await load(reset: true, force: true);
  }

  void openDetail(ReportSummaryModel report) {
    Get.toNamed(
      AppRoutes.reportDetail.replaceFirst(':id', '${report.reportId}'),
      arguments: {'report': report},
    );
  }
}
