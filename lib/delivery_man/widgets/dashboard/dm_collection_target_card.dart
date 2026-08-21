import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_collection_targets_model.dart';

class DmCollectionTargetCard extends StatelessWidget {
  const DmCollectionTargetCard({super.key, required this.targets});

  final DmCollectionTargetsModel targets;

  @override
  Widget build(BuildContext context) {
    final progress = targets.recoveryTarget == 0
        ? 0.0
        : targets.recoveryCurrent / targets.recoveryTarget;

    return AppOutlineCard(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.dmRecoveryTarget,
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(color: AppColors.grey),
          ),
          AppSpacing.vertical(context, 0.006),
          Text(
            '${AppFormatter.compactCurrency(targets.recoveryCurrent)} / '
            '${AppFormatter.compactCurrency(targets.recoveryTarget, symbol: '')}',
            style: AppTextStyles.heading(
              context,
            ).copyWith(fontWeight: FontWeight.w700),
          ),
          AppSpacing.vertical(context, 0.012),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
            child: LinearProgressIndicator(
              minHeight: AppSpacing.verticalValue(context, 0.005),
              value: progress.clamp(0, 1),
              backgroundColor: AppColors.warning.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
