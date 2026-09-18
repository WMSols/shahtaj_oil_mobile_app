import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_exception.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/feedback/app_toast.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker_mode.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/recovery/dm_wallet_collection_model.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/services/recovery/dm_recovery_service.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/shell/dm_services_binding.dart';

class DmCollectionHistoryController extends GetxController {
  DmCollectionHistoryController(this._recovery);

  final DmRecoveryService _recovery;

  final RxBool isLoading = true.obs;
  final RxnString error = RxnString();
  final RxList<DmWalletCollectionModel> collections =
      <DmWalletCollectionModel>[].obs;
  final RxDouble walletBalance = 0.0.obs;
  final Rxn<DateTime> dateFrom = Rxn<DateTime>();
  final Rxn<DateTime> dateTo = Rxn<DateTime>();
  final RxString searchQuery = ''.obs;

  bool get hasCachedData => collections.isNotEmpty;
  bool get hasDateFilter => dateFrom.value != null || dateTo.value != null;

  String get dateFromLabel =>
      dateFrom.value == null ? '' : AppFormatter.shortDate(dateFrom.value!);

  String get dateToLabel =>
      dateTo.value == null ? '' : AppFormatter.shortDate(dateTo.value!);

  List<DmWalletCollectionModel> get filteredCollections {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return collections.toList(growable: false);
    return collections
        .where((item) {
          return item.shopName.toLowerCase().contains(query) ||
              item.name.toLowerCase().contains(query) ||
              item.invoices.any((inv) => inv.toLowerCase().contains(query)) ||
              (item.notes?.toLowerCase().contains(query) ?? false);
        })
        .toList(growable: false);
  }

  double get filteredTotal =>
      filteredCollections.fold<double>(0, (sum, item) => sum + item.amount);

  @override
  void onInit() {
    DmServicesBinding.ensureRegistered();
    super.onInit();
    loadHistory();
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  Future<void> loadHistory({bool force = true}) async {
    final showLoader = collections.isEmpty;
    if (showLoader) isLoading.value = true;
    try {
      final page = await _recovery.fetchCollections(
        dateFrom: dateFrom.value,
        dateTo: dateTo.value,
        forceNetwork: force,
      );
      collections.assignAll(page.collections);
      walletBalance.value = page.walletBalance;
      error.value = null;
    } on ApiException catch (e) {
      error.value = e.message;
      if (collections.isEmpty) AppToast.showError(e.message);
    } catch (_) {
      error.value = AppTexts.emptyLoadFailedSubtitle;
      if (collections.isEmpty) AppToast.showError(AppTexts.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickDateFrom(BuildContext context) async {
    final today = DateTime.now();
    final maxDate = DateTime(today.year, today.month, today.day);
    final picked = await AppDateTimePicker.show(
      context,
      title: AppTexts.obVisitFilterDateFrom,
      initial: dateFrom.value ?? dateTo.value ?? maxDate,
      maxDate: dateTo.value ?? maxDate,
      mode: AppDateTimePickerMode.dateOnly,
    );
    if (picked == null) return;
    dateFrom.value = DateTime(picked.year, picked.month, picked.day);
    await loadHistory(force: true);
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
    await loadHistory(force: true);
  }

  Future<void> clearDateFilter() async {
    dateFrom.value = null;
    dateTo.value = null;
    await loadHistory(force: true);
  }

  String timeLabel(DmWalletCollectionModel collection) {
    return '${AppFormatter.shortDate(collection.date)} • ${AppFormatter.timeOfDay(collection.date)}';
  }
}
