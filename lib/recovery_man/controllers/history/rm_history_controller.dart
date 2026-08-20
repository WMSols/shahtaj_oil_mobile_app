import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/routes/app_routes.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/form/app_datetime_picker_mode.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/models/collections/rm_collection_summary_model.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/services/collections/rm_collection_store.dart';
import 'package:shahtaj_oil_mobile_app/recovery_man/shell/recovery_man_services_binding.dart';

class RmHistoryController extends GetxController with CachedLoadMixin {
  RmHistoryController(this._store);

  final RmCollectionStore _store;

  static const methodFilters = <PaymentMethod?>[
    null,
    PaymentMethod.cash,
    PaymentMethod.cheque,
    PaymentMethod.bank,
  ];

  final RxList<RmCollectionSummaryModel> collections =
      <RmCollectionSummaryModel>[].obs;
  final Rxn<DateTime> dateFrom = Rxn<DateTime>();
  final Rxn<DateTime> dateTo = Rxn<DateTime>();
  final Rxn<PaymentMethod> methodFilter = Rxn<PaymentMethod>();
  final RxString searchQuery = ''.obs;

  @override
  bool get hasCachedData => collections.isNotEmpty;

  @override
  String get loadFailedMessage => AppTexts.emptyLoadFailedSubtitle;

  bool get hasDateFilter => dateFrom.value != null || dateTo.value != null;

  String get dateFromLabel =>
      dateFrom.value == null ? '' : AppFormatter.shortDate(dateFrom.value!);

  String get dateToLabel =>
      dateTo.value == null ? '' : AppFormatter.shortDate(dateTo.value!);

  List<RmCollectionSummaryModel> get filteredCollections {
    final query = searchQuery.value.trim().toLowerCase();
    final method = methodFilter.value;
    return collections
        .where((item) {
          if (method != null && item.method != method) return false;
          if (query.isEmpty) return true;
          return item.shopName.toLowerCase().contains(query) ||
              item.receiptNumber.toLowerCase().contains(query) ||
              item.reference.toLowerCase().contains(query);
        })
        .toList(growable: false);
  }

  double get filteredTotal =>
      filteredCollections.fold<double>(0, (sum, item) => sum + item.amount);

  @override
  void onInit() {
    super.onInit();
    RecoveryManServicesBinding.ensureRegistered();
    loadHistory();
  }

  bool isMethodSelected(PaymentMethod? method) => methodFilter.value == method;

  String methodFilterLabel(PaymentMethod? method) =>
      method?.label ?? AppTexts.obShopsFilterAll;

  void selectMethodFilter(PaymentMethod? method) => methodFilter.value = method;

  void onSearchChanged(String value) => searchQuery.value = value;

  Future<void> loadHistory({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _store.hydrate();
    collections.assignAll(
      _store.collectionsForHistory(
        dateFrom: dateFrom.value,
        dateTo: dateTo.value,
      ),
    );
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

  String timeLabel(RmCollectionSummaryModel collection) {
    return '${AppFormatter.shortDate(collection.collectedAt)} • ${AppFormatter.timeOfDay(collection.collectedAt)}';
  }

  void openCollection(RmCollectionSummaryModel collection) {
    Get.toNamed(
      AppRoutes.rmCollectionDetail.replaceFirst(':id', collection.id),
      arguments: {'collectionId': collection.id},
    );
  }
}
