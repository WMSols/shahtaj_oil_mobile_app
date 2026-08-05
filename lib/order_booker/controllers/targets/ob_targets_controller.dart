import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/services/cached_load_mixin.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_target_item_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_target_line_model.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/services/targets/ob_targets_service.dart';

class ObTargetsController extends GetxController with CachedLoadMixin {
  ObTargetsController(this._service);

  final ObTargetsService _service;

  final RxList<ObTargetItemModel> targets = <ObTargetItemModel>[].obs;

  @override
  bool get hasCachedData => targets.isNotEmpty;

  @override
  String get loadFailedMessage => AppTexts.error;

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
