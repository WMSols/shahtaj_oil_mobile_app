import 'package:flutter/material.dart';

import 'package:shahtaj_oil_mobile_app/core/constants/app_enums.dart';
import 'package:shahtaj_oil_mobile_app/core/design/colors/app_colors.dart';
import 'package:shahtaj_oil_mobile_app/core/design/icons/app_icons.dart';
import 'package:shahtaj_oil_mobile_app/core/design/responsive/app_responsive.dart';
import 'package:shahtaj_oil_mobile_app/core/design/spacing/app_spacing.dart';
import 'package:shahtaj_oil_mobile_app/core/design/text_styles/app_text_styles.dart';
import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/buttons/app_primary_button.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/cards/app_outline_card.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/chips/app_status_chip.dart';
import 'package:shahtaj_oil_mobile_app/delivery_man/models/jobs/dm_job_model.dart';
import 'package:shahtaj_oil_mobile_app/core/widgets/text/app_text.dart';

class DmJobCard extends StatelessWidget {
  const DmJobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onRecover,
    this.onNotes,
    this.showDeliveryStatus = true,
  });

  final DmJobModel job;
  final VoidCallback? onTap;
  final VoidCallback? onRecover;
  final VoidCallback? onNotes;

  /// When false (e.g. Recover shop picker), hide field/job status chips.
  final bool showDeliveryStatus;

  bool get _hasNotes => (job.notes ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.bodyText(context).copyWith(
      color: AppColors.grey,
      fontSize: AppResponsive.scaleSize(context, 13),
    );
    final hasOrderName = job.orderName != null && job.orderName!.isNotEmpty;

    return AppOutlineCard(
      onTap: onTap,
      statusColor: job.isWalkIn
          ? AppColors.statPurple
          : (showDeliveryStatus ? job.fieldState.chipColor : AppColors.primary),
      padding: AppSpacing.symmetric(context, h: 0.035, v: 0.016),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText.label(
                  job.shopName,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              if (job.isWalkIn) ...[
                AppStatusChip.walkIn(),
                if (showDeliveryStatus) AppSpacing.horizontal(context, 0.01),
              ],
              if (showDeliveryStatus)
                AppStatusChip(
                  label: job.fieldState.label,
                  color: job.fieldState.chipColor,
                ),
            ],
          ),
          if (showDeliveryStatus || hasOrderName) ...[
            AppSpacing.vertical(context, 0.006),
            Row(
              children: [
                if (showDeliveryStatus)
                  AppStatusChip(
                    label: job.state.label,
                    color: job.state.chipColor,
                    soft: true,
                  ),
                if (showDeliveryStatus && hasOrderName)
                  AppSpacing.horizontal(context, 0.015),
                if (hasOrderName)
                  Flexible(
                    child: Text(
                      job.orderName!,
                      style: muted,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
          if (showDeliveryStatus) ...[
            AppSpacing.vertical(context, 0.006),
            Text(
              '${AppTexts.dmJobIdLabel}: ${job.jobId}'
              '${job.lines.isEmpty ? '' : ' · ${job.lines.length} ${AppTexts.dmLinesLabel}'}',
              style: muted,
            ),
          ],
          if (_hasNotes) ...[
            AppSpacing.vertical(context, 0.012),
            Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context),
              ),
              child: InkWell(
                onTap: onNotes ?? onTap,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context),
                ),
                child: Padding(
                  padding: AppSpacing.symmetric(context, h: 0.025, v: 0.01),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          AppTexts.obTaskNotePreview(job.notes!.trim()),
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppSpacing.horizontal(context, 0.015),
                      Icon(
                        AppIcons.edit,
                        color: AppColors.white,
                        size: AppResponsive.iconSize(context, factor: 0.85),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (onRecover != null &&
              !job.isWalkIn &&
              job.shopId.trim().isNotEmpty) ...[
            AppSpacing.vertical(context, 0.012),
            AppPrimaryButton(
              label: AppTexts.dmRecoverAtShop,
              onPressed: onRecover,
            ),
          ],
        ],
      ),
    );
  }
}
