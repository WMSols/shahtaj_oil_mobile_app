import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_target_item_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_target_line_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/targets/ob_targets_service.dart';

enum ObTargetSortMode { progressAsc, progressDesc, dateEndSoonest, type }

class ObTargetsController extends GetxController with CachedLoadMixin {
  ObTargetsController(this._service);

  final ObTargetsService _service;

  /// Progress below this with an end date within [atRiskDays] is "at risk".
  static const atRiskProgressThreshold = 0.7;
  static const atRiskDays = 7;

  final RxList<ObTargetItemModel> targets = <ObTargetItemModel>[].obs;
  final Rxn<ObTargetType> typeFilter = Rxn<ObTargetType>();
  final Rx<ObTargetSortMode> sortMode = ObTargetSortMode.progressAsc.obs;

  @override
  bool get hasCachedData => targets.isNotEmpty;

  @override
  String get loadFailedMessage => AppTexts.error;

  static const typeFilters = <ObTargetType?>[
    null,
    ObTargetType.collectiveQuantity,
    ObTargetType.collectiveWeight,
    ObTargetType.combinedProduct,
    ObTargetType.productQuantity,
    ObTargetType.productWeight,
  ];

  List<ObTargetItemModel> get filteredSortedTargets {
    final filter = typeFilter.value;
    final list = targets
        .where((t) => filter == null || t.type == filter)
        .toList();

    int byProgress(ObTargetItemModel a, ObTargetItemModel b) =>
        a.headlineProgress.compareTo(b.headlineProgress);

    int byDate(ObTargetItemModel a, ObTargetItemModel b) {
      final aDate = parseTargetDate(a.dateEnd);
      final bDate = parseTargetDate(b.dateEnd);
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return aDate.compareTo(bDate);
    }

    list.sort((a, b) {
      return switch (sortMode.value) {
        ObTargetSortMode.progressAsc => byProgress(a, b),
        ObTargetSortMode.progressDesc => byProgress(b, a),
        ObTargetSortMode.dateEndSoonest => byDate(a, b),
        ObTargetSortMode.type => a.type.name.compareTo(b.type.name),
      };
    });
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({bool force = false}) => loadCached(force: force);

  @override
  Future<void> fetchData() async {
    targets.assignAll(await _service.fetchTargets());
  }

  void selectTypeFilter(ObTargetType? type) => typeFilter.value = type;

  bool isTypeSelected(ObTargetType? type) => typeFilter.value == type;

  void selectSortMode(ObTargetSortMode mode) => sortMode.value = mode;

  String typeFilterLabel(ObTargetType? type) {
    if (type == null) return AppTexts.obShopsFilterAll;
    return type.label ?? type.name;
  }

  String sortModeLabel(ObTargetSortMode mode) => switch (mode) {
    ObTargetSortMode.progressAsc => AppTexts.obTargetSortProgressLow,
    ObTargetSortMode.progressDesc => AppTexts.obTargetSortProgressHigh,
    ObTargetSortMode.dateEndSoonest => AppTexts.obTargetSortDateEnd,
    ObTargetSortMode.type => AppTexts.obTargetSortType,
  };

  static DateTime? parseTargetDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final trimmed = raw.trim();
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) return iso;
    final parts = trimmed.split(RegExp(r'[/-]'));
    if (parts.length == 3) {
      final y = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final d = int.tryParse(parts[2]);
      if (y != null && m != null && d != null && y > 31) {
        return DateTime(y, m, d);
      }
      final d2 = int.tryParse(parts[0]);
      final m2 = int.tryParse(parts[1]);
      final y2 = int.tryParse(parts[2]);
      if (d2 != null && m2 != null && y2 != null) {
        return DateTime(y2, m2, d2);
      }
    }
    return null;
  }

  bool isAtRisk(ObTargetItemModel target) {
    if (target.headlineProgress >= atRiskProgressThreshold) return false;
    final end = parseTargetDate(target.dateEnd);
    if (end == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endDay = DateTime(end.year, end.month, end.day);
    final daysLeft = endDay.difference(today).inDays;
    return daysLeft >= 0 && daysLeft <= atRiskDays;
  }

  String? subtitleFor(ObTargetItemModel target) => target.subtitle;

  String headlineLabelFor(ObTargetItemModel target) {
    if (target.showValueRow) {
      return AppFormatter.targetProgressValues(
        current: target.current,
        target: target.target,
        unit: target.unit,
      );
    }
    return AppTexts.obTargetsProgressPercent(target.headlinePercentRounded);
  }

  String lineValueLabel(ObTargetLineModel line) {
    return AppFormatter.targetProgressValues(
      current: line.current,
      target: line.target,
      unit: line.unit,
    );
  }

  String lineMeasureLabel(ObTargetLineModel line) {
    final raw = line.measure.trim().toLowerCase();
    final base = switch (raw) {
      'weight' => _localized(AppTexts.obTargetMeasureWeight, 'Weight'),
      'qty' ||
      'quantity' => _localized(AppTexts.obTargetMeasureQuantity, 'Quantity'),
      _ => '',
    };
    if (base.isEmpty) return '';

    if (raw == 'weight') {
      final unit = AppFormatter.targetDisplayUnit(line.unit);
      if (unit.isNotEmpty) return '$base · $unit';
    }
    return base;
  }

  Color lineMeasureChipColor(ObTargetLineModel line) {
    final raw = line.measure.trim().toLowerCase();
    return switch (raw) {
      'weight' => AppColors.warning,
      'qty' || 'quantity' => AppColors.accentBlue,
      _ => AppColors.darkGrey,
    };
  }

  bool showCombinedHint(ObTargetItemModel target) => target.type.showLineBars;

  bool showProducts(ObTargetItemModel target) => target.hasProducts;

  bool showLineProgress(ObTargetItemModel target) => target.showLineProgress;

  String _localized(String value, String fallback) {
    if (value.startsWith('obTarget') || value.startsWith('ob')) {
      return fallback;
    }
    return value.isEmpty ? fallback : value;
  }
}
