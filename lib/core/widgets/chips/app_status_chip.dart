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
    this.fullWidth = false,
    this.soft = false,
  });

  final String label;
  final Color color;
  final bool fullWidth;

  /// Soft style: tinted background + colored text (vs solid fill + white text).
  final bool soft;

  factory AppStatusChip.route(RouteStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.order(OrderStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.delivery(DeliveryStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.collection(CollectionStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.visit(VisitStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.visitOutcome(VisitOutcome outcome) =>
      AppStatusChip(label: outcome.label, color: outcome.chipColor);

  factory AppStatusChip.shop(ShopStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.shopType(ShopType type) =>
      AppStatusChip(label: type.label, color: type.chipColor);

  factory AppStatusChip.task(TaskStatus status, {bool fullWidth = false}) =>
      AppStatusChip(
        label: status.label,
        color: status.chipColor,
        fullWidth: fullWidth,
      );

  factory AppStatusChip.shopVisitTag(ShopVisitTag tag) =>
      AppStatusChip(label: tag.label, color: tag.chipColor, soft: true);

  factory AppStatusChip.lowStock() =>
      AppStatusChip(label: AppTexts.obLowStock, color: AppColors.warning);

  factory AppStatusChip.alreadyInCart({bool fullWidth = false}) =>
      AppStatusChip(
        label: AppTexts.obAlreadyInCart,
        color: AppColors.success,
        fullWidth: fullWidth,
      );

  factory AppStatusChip.role(UserRole role) =>
      AppStatusChip(label: role.label, color: AppColors.primary);

  factory AppStatusChip.presence(PresenceStatus status) =>
      AppStatusChip(label: status.label, color: status.chipColor);

  factory AppStatusChip.target({required String label, required Color color}) =>
      AppStatusChip(label: label, color: color);

  factory AppStatusChip.fullWidth({
    required String label,
    required Color color,
  }) => AppStatusChip(label: label, color: color, fullWidth: true);

  @override
  Widget build(BuildContext context) {
    final background = soft ? color.withValues(alpha: 0.2) : color;
    final foreground = soft ? color : AppColors.white;

    final child = Container(
      width: fullWidth ? double.infinity : null,
      padding: AppSpacing.symmetric(context, h: 0.02, v: 0.002),
      alignment: fullWidth ? Alignment.center : null,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
      ),
      child: Text(
        label.toUpperCase(),
        textAlign: fullWidth ? TextAlign.center : TextAlign.start,
        style: AppTextStyles.hintText(
          context,
        ).copyWith(color: foreground, fontWeight: FontWeight.w600),
      ),
    );

    if (!fullWidth) return child;
    return SizedBox(width: double.infinity, child: child);
  }
}
