import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/network/api_map.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_target_line_model.dart';

enum ObTargetType {
  collectiveQuantity,
  collectiveWeight,
  combinedProduct,
  productQuantity,
  productWeight,
  unknown,
}

extension ObTargetTypeX on ObTargetType {
  bool get isCollective =>
      this == ObTargetType.collectiveQuantity ||
      this == ObTargetType.collectiveWeight;

  bool get showLineBars => this == ObTargetType.combinedProduct;

  String? get label => switch (this) {
    ObTargetType.collectiveQuantity => AppTexts.obTargetTypeCollectiveQuantity,
    ObTargetType.collectiveWeight => AppTexts.obTargetTypeCollectiveWeight,
    ObTargetType.combinedProduct => AppTexts.obTargetTypeCombinedProduct,
    ObTargetType.productQuantity => AppTexts.obTargetTypeProductQuantity,
    ObTargetType.productWeight => AppTexts.obTargetTypeProductWeight,
    ObTargetType.unknown => null,
  };

  Color get chipColor => switch (this) {
    ObTargetType.collectiveQuantity => AppColors.accentBlue,
    ObTargetType.collectiveWeight => AppColors.warning,
    ObTargetType.combinedProduct => AppColors.statPurple,
    ObTargetType.productQuantity => AppColors.success,
    ObTargetType.productWeight => AppColors.information,
    ObTargetType.unknown => AppColors.grey,
  };
}

class ObTargetItemModel {
  const ObTargetItemModel({
    required this.id,
    required this.title,
    required this.type,
    this.typeLabel,
    this.dateStart,
    this.dateEnd,
    required this.current,
    required this.target,
    this.unit = '',
    this.progressPercent,
    this.headlineProgressPercent,
    this.lines = const [],
  });

  final String id;
  final String title;
  final ObTargetType type;
  final String? typeLabel;
  final String? dateStart;
  final String? dateEnd;
  final double current;
  final double target;
  final String unit;
  final double? progressPercent;
  final double? headlineProgressPercent;
  final List<ObTargetLineModel> lines;

  String? get displayTypeLabel {
    final apiLabel = typeLabel?.trim();
    if (apiLabel != null && apiLabel.isNotEmpty) {
      return AppFormatter.displayLabel(apiLabel);
    }
    return type.label;
  }

  /// Title without booker prefix and without redundant type wording.
  String get displayTitle {
    var text = _stripBookerPrefix(title);
    final typeText = displayTypeLabel;
    if (typeText != null && typeText.isNotEmpty) {
      if (text.toLowerCase().startsWith(typeText.toLowerCase())) {
        text = text.substring(typeText.length).trim();
        if (text.startsWith('-')) text = text.substring(1).trim();
      }
    }
    final countMatch = RegExp(
      r'^\((\d+\s+products?)\)$',
      caseSensitive: false,
    ).firstMatch(text);
    if (countMatch != null) {
      text = countMatch.group(1)!;
    }
    text = text.trim();

    if (text.isEmpty) {
      final fallback = dateRange ?? productSummary ?? typeText ?? title;
      return AppFormatter.displayLabel(fallback);
    }
    return AppFormatter.displayLabel(text);
  }

  String? get subtitle => dateRange;

  bool get hasProducts =>
      lines.any((line) => line.displayProductName.trim().isNotEmpty);

  List<ObTargetLineModel> get productLines => lines
      .where((line) => line.displayProductName.trim().isNotEmpty)
      .toList(growable: false);

  bool get showLineProgress => type.showLineBars;

  String? get dateRange {
    if (dateStart != null && dateEnd != null) {
      return '$dateStart → $dateEnd';
    }
    return dateStart ?? dateEnd;
  }

  String? get productSummary {
    if (lines.isEmpty) return null;
    final names = lines
        .map((line) => line.displayProductName)
        .where((name) => name.isNotEmpty)
        .toList(growable: false);
    if (names.isEmpty) return null;
    return names.join(', ');
  }

  /// Parent / headline progress (0–1). Prefer API headline %, then progress %.
  double get headlineProgress {
    final headline = headlineProgressPercent ?? progressPercent;
    if (headline != null) {
      return (headline / 100).clamp(0, 1);
    }
    if (type.showLineBars && lines.isNotEmpty) {
      final sum = lines.fold<double>(0, (total, line) => total + line.progress);
      return (sum / lines.length).clamp(0, 1);
    }
    if (target <= 0) return 0;
    return (current / target).clamp(0, 1);
  }

  int get headlinePercentRounded => (headlineProgress * 100).round();

  /// Legacy alias used by dashboard aggregation.
  double get progress => headlineProgress;

  bool get showValueRow => !type.showLineBars;

  factory ObTargetItemModel.fromJson(Map<String, dynamic> json) {
    final type = _parseType(json['target_type']);
    final rawLines = ApiMap.listOf(json, 'lines');
    final lines = rawLines.isNotEmpty
        ? rawLines.map(ObTargetLineModel.fromJson).toList(growable: false)
        : _linesFromProducts(json);

    final current =
        ApiMap.asDouble(json['achieved_value']) ??
        ApiMap.asDouble(json['current']) ??
        0;
    final target =
        ApiMap.asDouble(json['target_value']) ??
        ApiMap.asDouble(json['target']) ??
        0;
    final unit =
        ApiMap.asString(json['weight_unit_label']) ??
        ApiMap.asString(json['target_weight_uom']) ??
        ApiMap.asString(json['unit']) ??
        '';

    return ObTargetItemModel(
      id: ApiMap.asString(json['id']) ?? '',
      title:
          ApiMap.asString(json['name']) ?? ApiMap.asString(json['title']) ?? '',
      type: type,
      typeLabel: ApiMap.asString(json['target_type_label']),
      dateStart: ApiMap.asString(json['date_start']),
      dateEnd: ApiMap.asString(json['date_end']),
      current: current,
      target: target,
      unit: unit,
      progressPercent: ApiMap.asDouble(json['progress_percent']),
      headlineProgressPercent: ApiMap.asDouble(
        json['headline_progress_percent'],
      ),
      lines: lines,
    );
  }

  /// Live API keys: `collective_qty`, `collective_weight`, `product_bundle`.
  /// Also accepts older aliases and Odoo selection pairs `[key, label]`.
  static ObTargetType _parseType(dynamic raw) {
    final normalized = _selectionKey(raw);
    return switch (normalized) {
      'collective_qty' ||
      'collective_quantity' ||
      'collective quantity' => ObTargetType.collectiveQuantity,
      'collective_weight' ||
      'collective weight' => ObTargetType.collectiveWeight,
      'product_bundle' ||
      'combined_product' ||
      'combined' ||
      'combined_product_targets' ||
      'combined product' ||
      'combined product targets' => ObTargetType.combinedProduct,
      'product_quantity' ||
      'product_qty' ||
      'product quantity' => ObTargetType.productQuantity,
      'product_weight' || 'product weight' => ObTargetType.productWeight,
      _ => ObTargetType.unknown,
    };
  }

  static String _selectionKey(dynamic raw) {
    if (raw is List && raw.isNotEmpty) {
      return ApiMap.asString(raw.first)?.toLowerCase() ?? '';
    }
    return ApiMap.asString(raw)?.toLowerCase() ?? '';
  }

  static String _stripBookerPrefix(String raw) {
    final trimmed = raw.trim();
    final match = RegExp(r'^(.+?)\s*[-–—]\s*(.+)$').firstMatch(trimmed);
    if (match == null) return trimmed;

    final prefix = match.group(1)!.trim();
    final rest = match.group(2)!.trim();
    if (rest.isEmpty) return trimmed;

    final looksLikeBookerPrefix =
        !prefix.contains('(') &&
        !prefix.toLowerCase().contains('target') &&
        !prefix.toLowerCase().contains('collective') &&
        !prefix.toLowerCase().contains('combined') &&
        prefix.split(RegExp(r'\s+')).length <= 3;

    return looksLikeBookerPrefix ? rest : trimmed;
  }

  static List<ObTargetLineModel> _linesFromProducts(Map<String, dynamic> json) {
    final products = ApiMap.listOf(json, 'products');
    if (products.isNotEmpty) {
      return products
          .map(
            (row) => ObTargetLineModel(
              productId: ApiMap.asString(row['id']) ?? '',
              productName: ApiMap.asString(row['name']) ?? '',
              current: 0,
              target: 0,
            ),
          )
          .toList(growable: false);
    }

    final product = ApiMap.asMap(json['product']);
    if (product == null) return const [];

    return [
      ObTargetLineModel(
        productId: ApiMap.asString(product['id']) ?? '',
        productName: ApiMap.asString(product['name']) ?? '',
        current:
            ApiMap.asDouble(json['achieved_value']) ??
            ApiMap.asDouble(json['current']) ??
            0,
        target:
            ApiMap.asDouble(json['target_value']) ??
            ApiMap.asDouble(json['target']) ??
            0,
        unit:
            ApiMap.asString(json['weight_unit_label']) ??
            ApiMap.asString(json['target_weight_uom']) ??
            '',
        progressPercent: ApiMap.asDouble(json['progress_percent']),
      ),
    ];
  }
}
