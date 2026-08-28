import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/formatter/app_formatter.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/dashboard/dm_targets_model.dart';

class DmTargetsCard extends StatelessWidget {
  const DmTargetsCard({
    super.key,
    required this.targets,
    this.onDeliveryTap,
    this.onRecoveryTap,
  });

  final DmTargetsModel targets;
  final VoidCallback? onDeliveryTap;
  final VoidCallback? onRecoveryTap;

  @override
  Widget build(BuildContext context) {
    return AppOutlineCard(
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      child: Column(
        children: [
          _TargetRow(
            label: AppTexts.dmDeliveryTarget,
            valueLabel:
                '${targets.deliveryCurrent} / ${targets.deliveryTarget}',
            subtitle:
                '${AppFormatter.compactCurrency(targets.deliveryValueCurrent)} / '
                '${AppFormatter.compactCurrency(targets.deliveryValueTarget, symbol: '')}',
            percent: targets.deliveryPercent,
            progress: targets.deliveryProgress,
            color: AppColors.primary,
            onTap: onDeliveryTap,
          ),
          AppSpacing.vertical(context, 0.018),
          _TargetRow(
            label: AppTexts.dmRecoveryTarget,
            valueLabel:
                '${AppFormatter.compactCurrency(targets.recoveryCurrent)} / '
                '${AppFormatter.compactCurrency(targets.recoveryTarget, symbol: '')}',
            percent: targets.recoveryPercent,
            progress: targets.recoveryProgress,
            color: AppColors.warning,
            onTap: onRecoveryTap,
          ),
        ],
      ),
    );
  }
}

class _TargetRow extends StatelessWidget {
  const _TargetRow({
    required this.label,
    required this.valueLabel,
    required this.percent,
    required this.progress,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  final String label;
  final String valueLabel;
  final String? subtitle;
  final int percent;
  final double progress;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyText(
                  context,
                ).copyWith(color: AppColors.grey),
              ),
            ),
            Text(
              AppTexts.dmProgressPercent(percent),
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        AppSpacing.vertical(context, 0.004),
        Text(
          valueLabel,
          style: AppTextStyles.heading(
            context,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
        if (subtitle != null) ...[
          AppSpacing.vertical(context, 0.002),
          Text(
            subtitle!,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: AppColors.grey),
          ),
        ],
        AppSpacing.vertical(context, 0.01),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
          child: LinearProgressIndicator(
            minHeight: AppSpacing.verticalValue(context, 0.005),
            value: progress.clamp(0, 1),
            backgroundColor: color.withValues(alpha: 0.18),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );

    if (onTap == null) return body;
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, child: body),
    );
  }
}
