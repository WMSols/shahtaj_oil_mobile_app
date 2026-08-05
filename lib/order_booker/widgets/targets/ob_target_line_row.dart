import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/widgets/targets/ob_target_progress_bar.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/targets/ob_targets_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/targets/ob_target_line_model.dart';

/// Nested product tile used on every targets card.
class ObTargetLineRow extends StatelessWidget {
  const ObTargetLineRow({
    super.key,
    required this.controller,
    required this.line,
    this.showProgress = false,
  });

  final ObTargetsController controller;
  final ObTargetLineModel line;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final measure = controller.lineMeasureLabel(line);
    final accent = showProgress
        ? controller.lineMeasureChipColor(line)
        : AppColors.primary;

    return AppOutlineCard(
      color: AppColors.inputFill,
      borderColor: AppColors.lightGrey,
      padding: AppSpacing.symmetric(context, h: 0.03, v: 0.012),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppResponsive.iconSize(context, factor: 1.8),
                height: AppResponsive.iconSize(context, factor: 1.8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  AppIcons.myshops5,
                  color: accent,
                  size: AppResponsive.iconSize(context, factor: 0.95),
                ),
              ),
              AppSpacing.horizontal(context, 0.025),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.displayProductName,
                      style: AppTextStyles.bodyText(context).copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (measure.isNotEmpty) ...[
                      AppSpacing.vertical(context, 0.005),
                      AppStatusChip.target(
                        label: measure,
                        color: controller.lineMeasureChipColor(line),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (showProgress) ...[
            AppSpacing.vertical(context, 0.008),
            Text(
              controller.lineValueLabel(line),
              style: AppTextStyles.caption(context).copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.darkGrey,
              ),
            ),
            AppSpacing.vertical(context, 0.006),
            ObTargetProgressBar(value: line.progress),
          ],
        ],
      ),
    );
  }
}
