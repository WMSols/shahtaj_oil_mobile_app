import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    required this.color,
    this.uppercase = false,
  });

  final String label;
  final Color color;
  final bool uppercase;

  factory AppStatusChip.route(RouteStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.order(OrderStatus status) => AppStatusChip(
    label: status.label,
    color: status.chipColor,
    uppercase: true,
  );

  factory AppStatusChip.delivery(DeliveryStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.collection(CollectionStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.visit(VisitStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.shop(ShopStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.lowStock() =>
      AppStatusChip(label: AppTexts.obLowStock, color: AppColors.warning);

  @override
  Widget build(BuildContext context) {
    final displayLabel = uppercase ? label.toUpperCase() : label;

    final textStyle = (AppTextStyles.hintText(
      context,
    ).copyWith(color: AppColors.white, fontWeight: FontWeight.w600));

    return Container(
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.002),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
      ),
      child: Text(displayLabel, style: textStyle),
    );
  }
}
