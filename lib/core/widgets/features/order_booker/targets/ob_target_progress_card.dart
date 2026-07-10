import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/order_booker/models/ob_target_item_model.dart';

class ObTargetProgressCard extends StatelessWidget {
  const ObTargetProgressCard({super.key, required this.target});

  final ObTargetItemModel target;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(target.title, style: AppTextStyles.sectionTitle(context)),
          if (target.subtitle != null) ...[
            AppSpacing.vertical(context, 0.004),
            Text(
              target.subtitle!,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.textMuted),
            ),
          ],
          AppSpacing.vertical(context, 0.008),
          Text(
            '${target.current.toStringAsFixed(0)} / ${target.target.toStringAsFixed(0)} ${target.unit}',
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.vertical(context, 0.008),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
            child: LinearProgressIndicator(
              minHeight: AppSpacing.verticalValue(context, 0.005),
              value: target.progress,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}
