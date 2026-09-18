import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';

class DmJobCard extends StatelessWidget {
  const DmJobCard({super.key, required this.job, this.onTap});

  final DmJobModel job;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.bodyText(context).copyWith(
      color: AppColors.grey,
      fontSize: AppResponsive.scaleSize(context, 13),
    );

    return AppOutlineCard(
      onTap: onTap,
      statusColor: job.fieldState.chipColor,
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  job.shopName,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              AppStatusChip(
                label: job.fieldState.label,
                color: job.fieldState.chipColor,
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.006),
          Row(
            children: [
              AppStatusChip(
                label: job.state.label,
                color: job.state.chipColor,
                soft: true,
              ),
              if (job.orderName != null && job.orderName!.isNotEmpty) ...[
                AppSpacing.horizontal(context, 0.015),
                Flexible(
                  child: Text(
                    job.orderName!,
                    style: muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          if (job.shopAddress != null &&
              job.shopAddress!.trim().isNotEmpty) ...[
            AppSpacing.vertical(context, 0.008),
            Row(
              children: [
                Icon(
                  AppIcons.location5,
                  size: AppResponsive.iconSize(context, factor: 0.8),
                  color: AppColors.primary,
                ),
                AppSpacing.horizontal(context, 0.01),
                Flexible(
                  child: Text(
                    job.shopAddress!,
                    style: muted.copyWith(color: AppColors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          AppSpacing.vertical(context, 0.006),
          Text(
            '${AppTexts.dmJobIdLabel}: ${job.jobId}'
            '${job.lines.isEmpty ? '' : ' · ${job.lines.length} ${AppTexts.dmLinesLabel}'}',
            style: muted,
          ),
        ],
      ),
    );
  }
}
