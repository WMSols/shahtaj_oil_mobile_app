import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/targets/ob_target_line_row.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/features/order_booker/targets/ob_target_progress_bar.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/controllers/ob_targets_controller.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_target_item_model.dart';

class ObTargetProgressCard extends StatelessWidget {
  const ObTargetProgressCard({
    super.key,
    required this.controller,
    required this.target,
  });

  final ObTargetsController controller;
  final ObTargetItemModel target;

  @override
  Widget build(BuildContext context) {
    final subtitle = controller.subtitleFor(target);
    final typeLabel = target.displayTypeLabel;
    final title = target.displayTitle;
    final showTitle =
        typeLabel == null ||
        title.trim().toLowerCase() != typeLabel.trim().toLowerCase();
    final showProducts = controller.showProducts(target);
    final showLineProgress = controller.showLineProgress(target);

    return AppOutlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (typeLabel != null)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppStatusChip.target(
                label: typeLabel,
                color: target.type.chipColor,
              ),
            ),
          if (showTitle && title.isNotEmpty) ...[
            AppSpacing.vertical(context, 0.006),
            Text(title, style: AppTextStyles.sectionTitle(context)),
          ],
          if (subtitle != null) ...[
            AppSpacing.vertical(context, 0.004),
            Text(
              subtitle,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.textMuted),
            ),
          ],
          if (controller.showCombinedHint(target)) ...[
            AppSpacing.vertical(context, 0.006),
            Text(
              AppTexts.obCombinedTargetHeadlineHint,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.textMuted),
            ),
          ],
          AppSpacing.vertical(context, 0.008),
          Text(
            controller.headlineLabelFor(target),
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.vertical(context, 0.008),
          ObTargetProgressBar(value: target.headlineProgress),
          if (showProducts) ...[
            AppSpacing.vertical(context, 0.014),
            Text(
              AppTexts.obTargetProductsSection,
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            AppSpacing.vertical(context, 0.008),
            ...target.productLines.map(
              (line) => Padding(
                padding: EdgeInsets.only(
                  bottom: AppSpacing.verticalValue(context, 0.008),
                ),
                child: ObTargetLineRow(
                  controller: controller,
                  line: line,
                  showProgress: showLineProgress,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
